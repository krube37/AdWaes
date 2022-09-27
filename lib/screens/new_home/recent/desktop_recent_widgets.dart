part of new_home_page;

class _DesktopRecentItem extends StatelessWidget {
  const _DesktopRecentItem({
    required this.asset,
  });

  final ImageProvider asset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: Semantics(
        container: true,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Column(
            children: [
              _DesktopRecentHeader(
                asset: asset,
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: colorScheme.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopRecentHeader extends StatelessWidget {
  const _DesktopRecentHeader({
    required this.asset,
  });

  final ImageProvider asset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.onBackground,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: FadeInImagePlaceholder(
              image: asset,
              placeholder: const SizedBox(
                height: 64,
                width: 64,
              ),
              width: 64,
              height: 64,
              excludeFromSemantics: true,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Semantics(
                header: true,
                child: SelectableText(
                  'Recent Events',
                  style: Theme.of(context).textTheme.headlineSmall!.apply(
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animates the recent item to stagger in. The [_AnimatedRecentItem.startDelayFraction]
/// gives a delay in the unit of a fraction of the whole animation duration,
/// which is defined in [_AnimatedHomePageState].
class _AnimatedRecentItem extends StatelessWidget {
  _AnimatedRecentItem({
    required double startDelayFraction,
    required this.controller,
    required this.child,
  }) : topPaddingAnimation = Tween(
          begin: 60.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.000 + startDelayFraction,
              0.400 + startDelayFraction,
              curve: Curves.ease,
            ),
          ),
        );

  final Widget child;
  final AnimationController controller;
  final Animation<double> topPaddingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(top: topPaddingAnimation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}
