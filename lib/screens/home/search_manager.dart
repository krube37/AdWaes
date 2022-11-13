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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
      ),
    );
  }

  _updateSuggestions(String value, StreamController<List<SearchFieldListItem?>?> suggestionsStream) async {
    if (value.isEmpty) {
      suggestionsStream.sink.add(<SearchFieldListItem<dynamic>>[]);
      return;
    }
    List<SearchFieldListItem<dynamic>> list = [];

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
      PageManager.of(context).navigateToCompany(item.type, item.userName);
    } else if (item is ProductEvent) {
      PageManager.of(context).navigateToProductEventPage(item.eventId);
    }
  }
}
