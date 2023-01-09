import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'constants.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({Key? key}) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with TickerProviderStateMixin {
  Artboard? artboard;
  SMIInput<double>? numValueInput;
  SMIInput<bool>? increaseInput;
  String assetPaths = "assets/tables.riv";

  double oldValue = 0.0;

  initializeArtboard() async {
    final data = await rootBundle.load(assetPaths);

    final file = RiveFile.import(data);
    artboard = file.mainArtboard;
    final controller =
        StateMachineController.fromArtboard(artboard!, "table_state_machine");
    if (controller != null) {
      artboard!.addController(controller);
      numValueInput = controller.findInput<double>("persons");
      increaseInput = controller.findInput<bool>("increase");
      numValueInput!.value = 0.0;
      increaseInput!.value = true;
    } else {
      print('controller not found');
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
      backgroundColor: Color.fromARGB(255, 54, 54, 54),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: artboard == null
                  ? const SizedBox()
                  : Rive(artboard: artboard!),
            ),
            SizedBox(
              width: 250,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        size: 50,
                      ),
                      onPressed: () {
                        if (numValueInput!.value < 8.0) {
                          setState(() {
                            increaseInput!.value = true;
                          });
                          setState(() {
                            oldValue = numValueInput!.value;
                            numValueInput!.value = numValueInput!.value + 1.0;
                          });
                        }
                      }),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${numValueInput?.value ?? oldValue}',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      child: Icon(
                        Icons.remove,
                        size: 50,
                      ),
                      onPressed: () {
                        if (numValueInput!.value > 1.0) {
                          setState(() {
                            increaseInput!.value = false;
                          });
                          setState(() {
                            oldValue = numValueInput!.value;
                            numValueInput!.value = numValueInput!.value - 1.0;
                          });
                        }
                      }),
                ],
              ),
            )
          ],
        ),
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
