import 'package:espla/state/owners.dart';
import 'package:espla/utils/address_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen>
    with WidgetsBindingObserver {
  late OwnersState _ownersState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _ownersState = context.read<OwnersState>();
      onLoad();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        onLoad();
        break;
      default:
    }
  }

  void onLoad() {
    _ownersState.fetchOwners();
  }

  Future<void> onRefresh() async {
    await _ownersState.fetchOwners();
  }

  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Text(
          '👤',
          style: TextStyle(fontSize: 32),
        ),
      );
    }
    return const Text(
      '👤',
      style: TextStyle(fontSize: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    final owners = context.watch<OwnersState>().owners;
    final loading = context.watch<OwnersState>().loading;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Members'),
        trailing: CupertinoButton(
          onPressed: onRefresh,
          child: const Icon(CupertinoIcons.refresh, size: 16),
        ),
      ),
      child: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: onRefresh,
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
              ),
            ),
            if (loading && owners.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final owner = owners[index];
                    return CupertinoListTile(
                      leading: _buildProfileImage(owner.profile?.imageMedium),
                      title: Text(
                        owner.profile?.name ??
                            formatAddress(owner.address.hexEip55),
                      ),
                      subtitle: owner.profile != null
                          ? Text(
                              '@${owner.profile!.username}',
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            )
                          : null,
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        // Handle owner tap
                      },
                    );
                  },
                  childCount: owners.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
