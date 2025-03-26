import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onToggle; // Add onToggle callback

  const ToggleSwitch({Key? key, required this.initialValue, required this.onToggle}) : super(key: key);

  @override
  ToggleSwitchState createState() => ToggleSwitchState(); // Public class
}

class ToggleSwitchState extends State<ToggleSwitch> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialValue;
  }

  void _toggleSwitch(bool value) {
    setState(() {
      isToggled = value;
    });
    widget.onToggle(value); // Call the callback function
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isToggled,
      onChanged: _toggleSwitch, // Trigger toggle function
      activeColor: Colors.green,
      inactiveTrackColor: Colors.grey,
    );
  }
}
