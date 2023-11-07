import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:furniture_mcommerce_app/local_store/db/account_handler.dart';
import 'package:furniture_mcommerce_app/views/screens/search_screen/product_search.dart';

import '../../../local_store/db/history_search_handler.dart';
import '../../../models/localstore/item_history_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen>{

  final List<ItemHistorySearch> _list = [];
  String? text;

  @override
  void initState() {
    HistorySearchHandler.getListItemHistorySearch().then((data) => {
        setState((){
          _list.addAll(data);
        })
    });
    super.initState();
  }

  void hadlerSaveHistorySearch() async {
    if(!await HistorySearchHandler.checkHistorySearch(text!)){
    int newID = await HistorySearchHandler.lastIndex() + 1;
    String idUser = await AccountHandler.getIdUser();
    if(idUser.isEmpty || text!.isEmpty) return;
    ItemHistorySearch itemHistorySearch = ItemHistorySearch(id: newID, idUser: idUser, text: text ?? '');
    HistorySearchHandler.insertHistorySearch(itemHistorySearch);
    setState(() {
      _list.add(itemHistorySearch);
    });
    }
  }


  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Search Screen',
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
                expandedHeight: 100,
                leading: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(
                    icon: const SvgIcon(
                      icon: SvgIconData('assets/icons/icon_back.svg'),
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                backgroundColor: Colors.white,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      margin: const EdgeInsets.only(
                      top: 5, left: 50, right: 30, bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextField(
                            onChanged: (value){
                                text = value;
                            },
                            onSubmitted: (String value){
                               text = value;
                               hadlerSaveHistorySearch();
                               Navigator.of(context, rootNavigator: true).push(
                                   MaterialPageRoute(
                                       builder: (_) => ProductSearch(search: text!, idcatParent: '', nameRoom: '')));
                            },
                            decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color(0xff242424), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: Color(0xff242424), width: 1.0)),
                          hintText: 'Nhập từ khóa cần tìm...',
                          hintStyle: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              color: Color(0xffE0E0E0),
                              fontSize: 16),
                          suffixIcon: IconButton(
                            icon: const SvgIcon(
                              icon: SvgIconData('assets/icons/icon_search.svg'),
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              hadlerSaveHistorySearch();
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (_) => ProductSearch(search: text!, idcatParent: '', nameRoom: '',)));
                            },
                          ),
                        ),
                      )),
                ))),
            SliverList.builder(
                itemBuilder: _buildItemSearch,
                itemCount: _list.length,
            ),
            SliverToBoxAdapter(
              child: _list.isEmpty ? const SizedBox()
                  : TextButton(
                      onPressed: (){
                        HistorySearchHandler.deleteAll();
                        setState(() {
                            _list.clear();
                        });
                      },
                      child: const Text(
                        'Xóa lịch sử tìm kiếm',
                        style: TextStyle(
                            fontFamily: 'Gelasio',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Color(0xff242424)),
                      )
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildItemSearch(BuildContext context, int index){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          print(_list[index].text);
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (_) => ProductSearch(search: _list[index].text, idcatParent: '', nameRoom: '',)));
          //Navigator.pop(context, _list[index]);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    _list[index].text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xff808080)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
  );
}
}



