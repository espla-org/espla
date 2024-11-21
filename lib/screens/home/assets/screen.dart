import 'package:espla/state/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AssetsScreen extends StatefulWidget {
  final String address;

  const AssetsScreen({super.key, required this.address});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  late AssetsState _assetsState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _assetsState = context.read<AssetsState>();

      onLoad();
    });
  }

  void onLoad() {
    _assetsState.fetchAssets(widget.address);
  }

  @override
  Widget build(BuildContext context) {
    final assets = context.watch<AssetsState>().assets;
    final loading = context.watch<AssetsState>().loading;

    return CupertinoScrollbar(
      child: CustomScrollView(
        slivers: [
          if (loading)
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
                                const Icon(CupertinoIcons.money_dollar_circle),
                          )
                        : const Icon(CupertinoIcons.money_dollar_circle),
                    title: Text(asset.token?.name ?? 'Unknown Token'),
                    subtitle: Text(
                      '${(BigInt.parse(asset.balance) / BigInt.from(10).pow(asset.token?.decimals ?? 18)).toStringAsFixed(2)} ${asset.token?.symbol ?? 'POL'}',
                      style: const TextStyle(color: CupertinoColors.systemGrey),
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
    );
  }
}
