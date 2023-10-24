import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key, required this.onSearchChange});
  final Function(String value) onSearchChange;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);

    return SizedBox(
      width: size.width - 50,
      height: 50,
      child: TextField(
        // style: TextStyle(fontSize: 20),
        controller: _searchController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                widget.onSearchChange(_searchController.text);
              },
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            filled: true,
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 10),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        onChanged: (value) {
          widget.onSearchChange(value);
        },
      ),
    );
  }
}
