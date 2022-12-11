part of home_page;

class _ProductListIconTile extends StatefulWidget {
  final ProductType type;

  const _ProductListIconTile({Key? key, required this.type}) : super(key: key);

  @override
  State<_ProductListIconTile> createState() => _ProductListIconTileState();
}

class _ProductListIconTileState extends State<_ProductListIconTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: SizedBox(
          width: 100.0,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _onItemClicked,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.type.getIcon(),
                  color: isHovering ? primaryColor : null,
                ),
                Text(
                  widget.type.getDisplayName(),
                  style: theme.textTheme.headline5?.copyWith(
                    color: isHovering ? primaryColor : null,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                isHovering
                    ? Container(
                        width: 30.0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.5,
                              color: isHovering ? primaryColor : Colors.transparent,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onItemClicked() {
    PageManager.of(context).navigateToProduct(widget.type);
  }
}
