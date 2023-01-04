import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Artboard? artboard;
  SMITrigger? hitInput;
  SMITrigger? pressInput;
  String assetPaths = "assets/game.riv";

  bool isPressed = false;

  initializeArtboard() async {
    final data = await rootBundle.load(assetPaths);

    final file = RiveFile.import(data);
    artboard = file.mainArtboard;
    final controller =
        StateMachineController.fromArtboard(artboard!, "State Machine 1");
    if (controller != null) {
      artboard!.addController(controller);
      hitInput = controller.findInput<bool>("Hit") as SMITrigger;
      pressInput = controller.findInput<bool>("Pressed") as SMITrigger;
    } else {
      print('controller not fonud');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await initializeArtboard();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              hitInput!.fire();
            });
            print('test press');
            print('BE:${pressInput!.value}');
            print('BE2:${hitInput!.value}');

            if (pressInput!.value == false) {
              print('AF:${pressInput!.value}');
              print('AFa:${hitInput!.value}');
              setState(() {
                pressInput!.fire();
              });
            } else {
              print('AF2:${pressInput!.value}');
              print('AF2//:${hitInput!.value}');
            }
          },
          child:
              artboard == null ? const SizedBox() : Rive(artboard: artboard!),
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: artboards.map<Widget>((artboard) {
        //     final index = artboards.indexOf(artboard);
        //     return BottomAppBarItem(
        //       artboard: artboard,
        //       currentIndex: currentActiveIndex,
        //       tabIndex: index,
        //       input: inputs[index],
        //       onpress: () {
        //         setState(() {
        //           currentActiveIndex = index;
        //         });
        //       },
        //     );
        //   }).toList(),
        // ),
      ),
    );
  }
}

class BottomAppBarItem extends StatelessWidget {
  const BottomAppBarItem({
    Key? key,
    required this.artboard,
    required this.onpress,
    required this.currentIndex,
    required this.tabIndex,
    required this.input,
  }) : super(key: key);
  final Artboard? artboard;
  final VoidCallback onpress;
  final int currentIndex;
  final int tabIndex;
  final SMIInput<bool>? input;

  @override
  Widget build(BuildContext context) {
    if (input != null) {
      input!.value = currentIndex == tabIndex;
    }
    return SizedBox(
      width: 150,
      height: 150,
      child: GestureDetector(
        onTap: onpress,
        child: artboard == null ? const SizedBox() : Rive(artboard: artboard!),
      ),
    );
  }
}
