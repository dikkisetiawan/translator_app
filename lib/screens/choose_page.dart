import 'dart:math';
import 'package:flutter/material.dart';
import 'package:translator_app/screens/homepage.dart';
import '../language_list.dart';

class ChooseLanguagePage extends StatelessWidget {
  ChooseLanguagePage({super.key});

  String from = 'auto';
  String to = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kAppBar(context),
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: DefaultTabController(
            length: 2,
            initialIndex: 1,
            //we need builder to read controller index
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  kTabBar(context),
                  kTabBarView(context),
                ])),
      ),
    );
  }

  Widget kTabBarView(BuildContext context) => Expanded(
          child: TabBarView(children: [
        languageListView(mode.from),

        // second tab bar view widget
        languageListView(mode.to),
      ]));

  Widget languageListView(mode which) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: Language().languageList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 25, right: 10),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: () {
                if (which == mode.from) {
                  from = Language().languageList.keys.elementAt(index);
                  DefaultTabController.of(context)!.animateTo(1);
                } else {
                  to = Language().languageList.keys.elementAt(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        from: from,
                        to: to,
                      ),
                    ),
                  );
                }
              },
              selectedTileColor: Colors.blue,
              leading: CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)][200],
                child: Text(
                  Language()
                      .languageList
                      .values
                      .elementAt(index)
                      .characters
                      .first,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PoppinsBold',
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                Language().languageList.values.elementAt(index).toUpperCase(),
                style: TextStyle(
                    fontFamily: 'PoppinsBold', fontWeight: FontWeight.bold),
              )),
        );
      },
    );
  }

  Widget kTabBar(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
        child: TabBar(
            labelStyle: TextStyle(
                fontFamily: 'PoppinsBold', fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20.0,
              ),
              color: Colors.blue,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'FROM'),
              Tab(text: 'TO'),
            ]),
      );

  AppBar kAppBar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))),
      toolbarHeight: 65,
      leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  from: from,
                  to: to,
                ),
              ),
            );
          },
          icon: Icon(Icons.arrow_back)),
      elevation: 0.0,
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: Text(
        'CHOOSE LANGUAGE',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontFamily: 'PoppinsBold'),
      ),
    );
  }
}
