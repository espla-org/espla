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

  @override
  Widget build(BuildContext context) {
    final id = state.pathParameters['id'];

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
                        );
                      },
                    ),
                  )
                ],
              )),
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
