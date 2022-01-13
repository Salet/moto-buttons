import 'dart:io';

import 'package:flutter/material.dart';

class ButtonsPage extends StatefulWidget {
  final List<Map> buttons;
  final pubnub;

  ButtonsPage({Key key, this.buttons, this.pubnub}) : super(key: key);

  @override
  _ButtonsPageState createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  List<int> activeButtons = [];

  @override
  void initState() {
    super.initState();

    var subscription = widget.pubnub.subscribe(channels: {'moto-buttons'});

    subscription.messages.listen((message) {
      setState(() {
        activeButtons.contains(message.content)
            ? activeButtons.remove(message.content)
            : activeButtons.add(message.content);
      });
    });
  }

  void _sendClick(int id) async {
    await widget.pubnub.publish('moto-buttons', id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double screenHeight =
        size.height - kToolbarHeight - (Platform.isIOS ? 80 : 0);
    final double itemHeight = screenHeight / 4;
    final double itemWidth = size.width / 2;

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(14),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      children: [
        for (var item in widget.buttons)
          TextButton(
            onPressed: () {
              _sendClick(item['id']);
            },
            child: Text(
              item['text'],
              style: TextStyle(
                fontSize: 20,
                height: 1.4,
                color: activeButtons.contains(item['id'])
                    ? Colors.grey.shade800
                    : item['color'],
              ),
              textAlign: TextAlign.center,
            ),
            style: TextButton.styleFrom(
                side: BorderSide(width: 4, color: item['color']),
                backgroundColor: activeButtons.contains(item['id'])
                    ? item['color']
                    : Colors.transparent),
          ),
      ],
    );
  }
}
