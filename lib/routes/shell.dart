import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:espla/services/preferences/preferences.dart';
import 'package:espla/state/assets.dart';
import 'package:espla/state/members.dart';
import 'package:espla/state/orgs.dart';
import 'package:espla/state/voting.dart';
import 'package:espla/widgets/badge.dart';
import 'package:espla/widgets/blurry_child.dart';
import 'package:espla/widgets/image_or_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Destination {
  final Widget name;
  final String location;
  final String icon;

  Destination({
    required this.name,
    required this.location,
    required this.icon,
  });
}

class RouterShell extends StatefulWidget {
  final Widget? child;
  final GoRouterState state;

  const RouterShell({
    super.key,
    this.child,
    required this.state,
  });

  @override
  State<RouterShell> createState() => _RouterShellState();
}

class _RouterShellState extends State<RouterShell> with WidgetsBindingObserver {
  final PreferencesService _preferences = PreferencesService();
  late AssetsState _assetsState;
  late MembersState _membersState;
  late VotingState _votingState;

  bool isExpanded = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onLoad();
    });
  }

  @override
  void didUpdateWidget(covariant RouterShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.key != widget.key) {
      onLoad();
    }
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
    _assetsState = context.read<AssetsState>();
    _membersState = context.read<MembersState>();
    _votingState = context.read<VotingState>();

    _assetsState.fetchAssets();
    _membersState.fetchMembers();
    _votingState.getThreshold();
  }

  void handleCreateOrg(BuildContext context) {
    print('create org');
  }

  void handleSelectOrg(BuildContext context, String id) {
    GoRouter.of(context).go('/$id/home');
    _preferences.setLastActiveOrgId(id);
  }

  void handleNavigation(
      BuildContext context, String id, Destination destination) {
    GoRouter.of(context).go('/$id/${destination.location}');
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final child = widget.child;

    final id = state.pathParameters['id'];
    final parts = state.uri.toString().split('/');
    final location = parts.length > 2 ? parts[2] : '/';

    final orgs = context.watch<OrgsState>().orgs;

    final memberCount = context.watch<MembersState>().membersCount;
    final assetsCount = context.watch<AssetsState>().assetsCount;

    final (votingThreshold, threshold) =
        context.select<VotingState, (VotingThreshold?, double?)>(
            selectVotingThreshold(memberCount));

    final activeOrgIndex = context.select(
      (OrgsState state) => state.orgs.indexWhere((org) => org.id == id),
    );

    final activeOrg = orgs.isNotEmpty ? orgs[activeOrgIndex] : null;

    final List<Destination> destinations = [
      Destination(
        name: const Text('Home'),
        location: 'home',
        icon: '🏠',
      ),
      Destination(
        name: memberCount > 0
            ? Text('Members ($memberCount)')
            : const Text('Members'),
        location: 'members',
        icon: '👥',
      ),
      Destination(
        name: assetsCount > 0
            ? Text('Assets ($assetsCount)')
            : const Text('Assets'),
        location: 'assets',
        icon: '💰',
      ),
      Destination(
        name: votingThreshold != null
            ? Row(
                children: [
                  const Text('Proposals'),
                  const SizedBox(width: 8),
                  CupertinoCustomBadge(label: votingThreshold.name),
                  if (votingThreshold == VotingThreshold.custom)
                    const SizedBox(
                      width: 8,
                    ),
                  if (votingThreshold == VotingThreshold.custom)
                    Text(
                      '(${threshold?.toStringAsFixed(2)}%)',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                ],
              )
            : const Text('Proposals'),
        location: 'proposals',
        icon: '🗣️',
      ),
    ];

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
                                        color: CupertinoColors.white,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: ImageOrSvg(
                                          image: org.image,
                                          fit: BoxFit.contain,
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
                activeOrg != null
                    ? CupertinoSidebarCollapsible(
                        isExpanded: isExpanded,
                        child: CupertinoSidebar(
                          selectedIndex: destinations.indexWhere(
                            (destination) => destination.location == location,
                          ),
                          onDestinationSelected: (value) {
                            if (value > destinations.length - 1) {
                              return;
                            }

                            final destination = destinations[value];
                            handleNavigation(
                              context,
                              id ?? '',
                              destination,
                            );
                          },
                          navigationBar: SidebarNavigationBar(
                            title: Text(activeOrg.name),
                          ),
                          children: [
                            SizedBox(
                              height: 50,
                              child: Text(
                                activeOrg.description,
                                maxLines: 2,
                              ),
                            ),
                            ...destinations.map(
                              (destination) {
                                return SidebarDestination(
                                  icon: Text(destination.icon),
                                  label: destination.name,
                                );
                              },
                            ),
                            const SidebarSection(
                              label: Text('Discussions'),
                              children: [
                                SidebarDestination(
                                  icon: Text('🔔'),
                                  label: Text('Announcements'),
                                ),
                                SidebarDestination(
                                  icon: Text('💬'),
                                  label: Text('General'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                if (child != null)
                  Expanded(
                    child: child,
                  ),
              ],
            ),
            activeOrg != null
                ? Positioned(
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
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
