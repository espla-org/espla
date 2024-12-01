import 'package:espla/state/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen>
    with WidgetsBindingObserver {
  late AssetsState _assetsState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _assetsState = context.read<AssetsState>();

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
    _assetsState.fetchAssets();
  }

  Future<void> onRefresh() async {
    await _assetsState.fetchAssets();
  }

  @override
  Widget build(BuildContext context) {
    final assets = context.watch<AssetsState>().assets;
    final loading = context.watch<AssetsState>().loading;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Assets'),
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
            if (loading && assets.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final asset = assets[index];
                    return CupertinoListTile(
                      leading: asset.token?.logoUri != null
                          ? Image.network(
                              asset.token!.logoUri!,
                              width: 32,
                              height: 32,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                      CupertinoIcons.money_dollar_circle),
                            )
                          : const Icon(CupertinoIcons.money_dollar_circle),
                      title: Text(asset.token?.name ?? 'Unknown Token'),
                      subtitle: Text(
                        '${(BigInt.parse(asset.balance) / BigInt.from(10).pow(asset.token?.decimals ?? 18)).toStringAsFixed(2)} ${asset.token?.symbol ?? ''}',
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () {
                        // Handle asset tap
                      },
                    );
                  },
                  childCount: assets.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
