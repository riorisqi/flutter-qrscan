import 'package:flutter/material.dart';
import 'package:test_flutter/utils/constant.dart' as constants;
import 'package:test_flutter/utils/menu_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  List<MenuItem> allMenuItems = constants.allMenuItems;
  late List<MenuItem> filteredMenuItems;

  @override
  void initState() {
    filteredMenuItems = allMenuItems;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Search"),
          backgroundColor: constants.COLOR,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Search",
                    prefixIcon: const Icon(Icons.search)
                  ),
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 35),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMenuItems.length,
                  itemBuilder:(context, index) {
                    final menuItem = filteredMenuItems[index];
                    return ListTile(
                      iconColor: constants.COLOR,
                      leading: Icon(menuItem.icon),
                      title: Text(menuItem.name),
                      trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                      onTap: () {
                        Navigator.pushNamed(context, menuItem.routePage);
                      },
                    );
                  },
                  separatorBuilder:(context, index) => const Divider(height: 1),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredMenuItems = allMenuItems
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}