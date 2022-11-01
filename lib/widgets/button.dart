import 'package:flutter/material.dart';

class NeoButton extends StatefulWidget {
  const NeoButton({
    Key? key,
    required this.notificationType,
    required this.onTap,
  }) : super(key: key);

  final String notificationType;
  final Function onTap;

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future.delayed(const Duration(milliseconds: 250), () {
          widget.onTap();
        });
        setState(() {
          isPressed = true;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            isPressed = false;
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: 240,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isPressed
                ? []
                : [
                    //dark shadow at bottom right corner
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: const Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    //light shadow at top left corner
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    )
                  ]),
        child: Center(
          child: Text(
            widget.notificationType,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isPressed ? Colors.blueGrey.shade300 : Colors.blueGrey,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
