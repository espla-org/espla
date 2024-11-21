import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:espla/state/org.dart';
import 'package:espla/widgets/blurry_child.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> destinations = [
  {
    'name': 'Home',
    'location': 'home',
    'icon': CupertinoIcons.home,
  },
  {
    'name': 'Assets',
    'location': 'assets',
    'icon': CupertinoIcons.circle,
  },
  {
    'name': 'Proposals',
    'location': 'proposals',
    'icon': CupertinoIcons.square,
  },
];

class RouterShell extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const RouterShell({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  State<RouterShell> createState() => _RouterShellState();
}

class _RouterShellState extends State<RouterShell> {
  bool isExpanded = true;

  void handleCreateOrg(BuildContext context) {
    print('create org');
  }

  void handleSelectOrg(BuildContext context, String id) {
    GoRouter.of(context).go('/$id/home');
  }

  void handleNavigation(BuildContext context, String path) {
    GoRouter.of(context).go(path);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final child = widget.child;

    final id = state.pathParameters['id'];
    final parts = state.uri.toString().split('/');
    final location = parts.length > 2 ? parts[2] : '/';

    final orgs = context.watch<OrgState>().orgs;

    final activeOrg = context.select(
      (OrgState state) => state.orgs.firstWhere(
        (org) => org.id == id,
      ),
    );

    return CupertinoPageScaffold(
      key: Key(state.uri.toString()),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 65,
                  color: CupertinoColors.darkBackgroundGray,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        scrollBehavior: const CupertinoScrollBehavior(),
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 30,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 3,
                                    color: CupertinoColors.white.withOpacity(0),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => handleCreateOrg(context),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      width: 2,
                                      color: CupertinoColors.systemCyan,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      CupertinoIcons.plus,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: orgs.length,
                              (context, index) {
                                final org = orgs[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        width: 3,
                                        color: org.id == id
                                            ? CupertinoColors.white
                                            : CupertinoColors.white
                                                .withOpacity(0),
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        handleSelectOrg(context, org.id),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          width: 2,
                                          color: CupertinoColors.systemCyan,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          org.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stack) => Text(
                                            org.name.substring(0, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: BlurryChild(
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSidebarCollapsible(
                  isExpanded: isExpanded,
                  child: CupertinoSidebar(
                    selectedIndex: destinations.indexWhere(
                      (destination) => destination['location'] == location,
                    ),
                    onDestinationSelected: (value) {
                      final destination = destinations[value];
                      handleNavigation(
                          context, '/$id/${destination['location']}');
                    },
                    navigationBar: SidebarNavigationBar(
                      title: Text(activeOrg.name),
                    ),
                    children: destinations.map((destination) {
                      return SidebarDestination(
                        icon: Icon(destination['icon']),
                        label: Text(destination['name']),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 60,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: const Icon(CupertinoIcons.sidebar_left),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
