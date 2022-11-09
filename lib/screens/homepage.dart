import 'dart:async';

import 'package:flutter/services.dart'; //untuk paste data baca clipboard
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../language_list.dart';

class HomePage extends StatefulWidget {
  String from, to;
  HomePage({super.key, required this.from, required this.to});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  GoogleTranslator translator = GoogleTranslator();

  String textButtonText = 'Translate';
  String? out;
  final _textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  void translate() {
    setState(() {
      textButtonText = 'Loading';
    });

    translator
        .translate(_textController.text, from: widget.from, to: widget.to)
        .then((value) {
      setState(() {
        out = value.toString();
        textButtonText = 'Translate';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: kAppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 20,
          ),
          kContainerBox(
              context, kTextField(), clearAndPasteButton(), mode.from),
          kIconButton(),
          kContainerBox(context, kSelectableText(), copyButton(), mode.to),
          kButton(context),
        ],
      ),
    );
  }

  IconButton kIconButton() {
    return IconButton(
        color: Colors.blue,
        iconSize: 40.0,
        onPressed: () {
          setState(() {
            //swap from to
            String helper;
            helper = widget.from;
            widget.from = widget.to;
            widget.to = helper;
            _textController.text = out ?? ''; //swap text

            translate();
          });
        },
        icon: Icon(Icons.swap_vert_circle_rounded));
  }

  Widget kButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 100, right: 100, bottom: 40),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        color: Colors.blue[400],
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            _textController.text.isEmpty
                ? kSnackBar(context,
                    title: 'Text Field cannot be empty doh :(',
                    color: Colors.red[300])
                : translate();
          });
        },
        child: Text(textButtonText,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'PoppinsBold')),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> kSnackBar(
      BuildContext context,
      {String? title,
      Color? color}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        title!,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: color,
    ));
  }

  Widget kSelectableText() {
    return SelectableText(
      out ?? '',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'PoppinsReg',
      ),
      showCursor: true,
      cursorColor: Colors.white,
      minLines: 5,
      maxLines: 999,
      scrollPhysics: ClampingScrollPhysics(),
    );
  }

  Widget kContainerBox(
      BuildContext context, Widget child, Widget kIconButton, mode which) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.7,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 1, //                   <--- border width here
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                    ),
                    label: Text(
                      which == mode.from
                          ? Language().languageList[widget.from]!
                          : Language().languageList[widget.to]!,
                      textAlign: TextAlign.center,
                    )),
              ),
              kIconButton,
            ],
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  TextField kTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          Timer(
            Duration(seconds: 5),
            () {
              translate(); //auto translate without pressing button
            },
          );
        });
      },
      controller: _textController,
      maxLines: null, //wrap text
      autofocus: true,
      autocorrect: true,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Tap to enter text',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'PoppinsReg',
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(
          fontFamily: 'PoppinsReg', fontSize: 16, color: Colors.black),
    );
  }

  AppBar kAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))),
      toolbarHeight: 65,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)),
      elevation: 0.0,
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
                text: 'Quick',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF121212),
                    fontFamily: 'PoppinsBold')),
            TextSpan(
                text: 'Translator',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'PoppinsBold')),
          ],
        ),
      ),
    );
  }

  Widget clearButton() => IconButton(
      onPressed: () {
        setState(() {
          _textController.text = '';
        });
      },
      icon: Icon(
        Icons.delete_sweep,
        color: Colors.grey,
      ));

  Widget pasteButton() => IconButton(
      onPressed: () async {
        Clipboard.getData(Clipboard.kTextPlain).then((value) {
          _textController.text = _textController.text + value!.text! ?? '';
          translate();
        });
      },
      icon: Icon(
        Icons.paste,
        color: Colors.grey,
      ));

  Widget copyButton() => IconButton(
      onPressed: () {
        kSnackBar(context,
            title: 'Copied to cliboard : $out', color: Colors.blue[300]);
        Clipboard.setData(ClipboardData(text: out));
      },
      icon: Icon(Icons.copy, color: Colors.grey));

  Widget clearAndPasteButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [clearButton(), pasteButton()],
      );
}
