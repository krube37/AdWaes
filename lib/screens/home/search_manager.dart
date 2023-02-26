part of app_bar;

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  void initState() {
    super.initState();
  }

  var suggestions = ProductType.values.toList();

  @override
  Widget build(BuildContext context) {
    return SearchField<dynamic>(
      onSuggestionTap: _onSuggestionTapped,
      itemHeight: 50.0,
      suggestions: const [],
      onChanged: _updateSuggestions,
      maxSuggestionsInViewPort: 6,
      searchInputDecoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'search for products',
        border: Theme.of(context).inputDecorationTheme.border,
      ),
    );
  }

  _updateSuggestions(String value, StreamController<List<SearchFieldListItem?>?> suggestionsStream) async {
    if (value.isEmpty) {
      suggestionsStream.sink.add(<SearchFieldListItem<dynamic>>[]);
      return;
    }
    List<SearchFieldListItem<dynamic>> list = [];

    await Future.delayed(const Duration(milliseconds: 500)); // to restrict multiple request for every letter

    List<ProductData> results = await FirestoreManager().getProductDataSearchResults(value);

    list.addAll(results
        .map(
          (e) => SearchFieldListItem<ProductData>(
            e.name,
            item: e,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.business,
                    color: Colors.grey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Text(e.name),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList());
    if (list.length >= 6) {
      suggestionsStream.sink.add(list.take(6).toList());
      return;
    }

    List<ProductEvent> eventResults = await FirestoreManager().getProductEventSearchResults(value);

    list.addAll(eventResults
        .map(
          (e) => SearchFieldListItem<ProductEvent>(
            e.eventName,
            item: e,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.event,
                    color: Colors.grey,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Text(e.eventName),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList());

    suggestionsStream.sink.add(list.take(6).toList());
  }

  _onSuggestionTapped(SearchFieldListItem<dynamic> clickedItem) {
    dynamic item = clickedItem.item!;

    if (item is ProductData) {
      PageManager.of(context).navigateToProductProfilePage(item.userName);
    } else if (item is ProductEvent) {
      PageManager.of(context).navigateToProductEventPage(
        item.eventId,
        event: item,
      );
    }
  }
}

class CustomMobileSearchDelegate extends SearchDelegate<dynamic> {
  CustomMobileSearchDelegate({String? searchFieldLabel})
      : super(
          searchFieldLabel: searchFieldLabel,
          searchFieldStyle: const TextStyle(
            color: Colors.grey,
          ),
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.trim().isNotEmpty)
        _getIconButton(
          context,
          Icons.clear_rounded,
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return _getIconButton(
      context,
      Icons.arrow_back_outlined,
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ProductEvent> recentEvents = DataManager().recentEvents;

    if (query.isEmpty) {
      return ListView.builder(
        itemCount: recentEvents.length,
        itemBuilder: (context, index) => MobileSearchEventTile(
          event: recentEvents[index],
        ),
      );
    }

    return FutureBuilder<List<ProductEvent>>(
        future: FirestoreManager().getProductEventSearchResults(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData && !snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching results'),
            );
          }
          List<ProductEvent> events = snapshot.data!;

          if (events.isEmpty) {
            return const Center(child: Text('No result found '));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) => MobileSearchEventTile(event: events[index]),
          );
        });
  }

  _getIconButton(
    BuildContext context,
    IconData iconData, {
    required Function onPressed,
  }) =>
      IconButton(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => onPressed.call(),
          icon: Icon(iconData));
}
