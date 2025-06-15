import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class InstalledAppsScreen extends StatefulWidget {
  @override
  _InstalledAppsScreenState createState() => _InstalledAppsScreenState();
}

class _InstalledAppsScreenState extends State<InstalledAppsScreen> {
  List<Application> _apps = [];
  Set<String> _allowedPackages = {};

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  void _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      includeAppIcons: true,
    );
    setState(() {
      _apps = apps;
    });
  }

  void _toggleAllowed(String packageName) {
    setState(() {
      if (_allowedPackages.contains(packageName)) {
        _allowedPackages.remove(packageName);
      } else {
        _allowedPackages.add(packageName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Allowed Apps')),
      body: ListView.builder(
        itemCount: _apps.length,
        itemBuilder: (context, index) {
          final app = _apps[index];
          return ListTile(
            leading: app is ApplicationWithIcon
                ? Image.memory(app.icon, width: 40)
                : null,
            title: Text(app.appName),
            subtitle: Text(app.packageName),
            trailing: Checkbox(
              value: _allowedPackages.contains(app.packageName),
              onChanged: (_) => _toggleAllowed(app.packageName),
            ),
          );
        },
      ),
    );
  }
}