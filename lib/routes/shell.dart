import 'package:espla/routes/tab.dart';
import 'package:espla/state/org.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RouterShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const RouterShell({
    super.key,
    required this.child,
    required this.state,
  });

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
    final id = state.pathParameters['id'];
    final parts = state.uri.toString().split('/');
    final location = parts.length > 2 ? parts[2] : '/';

    final orgs = context.watch<OrgState>().orgs;

    return CupertinoPageScaffold(
      key: Key(state.uri.toString()),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              width: 65,
              child: Expanded(
                  child: CustomScrollView(
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
                                    : CupertinoColors.white.withOpacity(0),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => handleSelectOrg(context, org.id),
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
                                  errorBuilder: (context, error, stack) => Text(
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
              )),
            ),
            SizedBox(
              width: 240,
              child: Expanded(
                child: ListView(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  children: [
                    Tab(
                      name: 'Home',
                      location: 'home',
                      currentLocation: location,
                      path: '/$id/home',
                      icon: CupertinoIcons.home,
                      onPressed: (context, path) =>
                          handleNavigation(context, path),
                    ),
                    Tab(
                      name: 'Assets',
                      location: 'assets',
                      currentLocation: location,
                      path: '/$id/assets',
                      icon: CupertinoIcons.circle,
                      onPressed: (context, path) =>
                          handleNavigation(context, path),
                    ),
                    Tab(
                      name: 'Proposals',
                      location: 'proposals',
                      currentLocation: location,
                      path: '/$id/proposals',
                      icon: CupertinoIcons.square,
                      onPressed: (context, path) =>
                          handleNavigation(context, path),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
