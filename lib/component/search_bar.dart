import 'package:flutter/material.dart';
import 'package:lister_app/util/delayed_callback.dart';

class SearchBar extends StatefulWidget {
  final void Function(String text)? onTextChange;
  final String? initialText;

  const SearchBar({super.key, this.onTextChange, this.initialText});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController? _searchTextController;

  @override
  void initState() {
    super.initState();

    _searchTextController = TextEditingController(text: widget.initialText);

    _searchTextController!.addListener(() {
      DelayedCallback().run(() {
        widget.onTextChange!(_searchTextController!.text);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchTextController,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: _searchTextController!.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() => _searchTextController!.clear());
                    },
                  ),
          ),
          hintText: MaterialLocalizations.of(context).searchFieldLabel),
    );
  }
}
