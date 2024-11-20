import 'package:flutter/cupertino.dart';

class Tab extends StatelessWidget {
  final String name;
  final String location;
  final String currentLocation;
  final String path;
  final IconData icon;
  final void Function(BuildContext context, String path) onPressed;

  const Tab({
    super.key,
    required this.name,
    required this.location,
    required this.currentLocation,
    required this.path,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: location == currentLocation ? CupertinoColors.systemCyan : null,
        onPressed: () => onPressed(context, path),
        child: SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon),
              ),
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
