import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'العربية';
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // محاذاة إلى المنتصف
        children: [
          const Text(
            'الإعدادات',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // محاذاة إلى المنتصف
            children: [
              DropdownButton<String>(
                value: _selectedLanguage,
                items: <String>['العربية', 'الإنجليزية', 'الهندية', 'الاردية', 'البنغالية']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
              SizedBox(width: 8), // مسافة بين الدراب داون والنص
              const Text('اللغة:', style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // محاذاة إلى المنتصف
            children: [
              IconButton(
                icon: Icon(
                  _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 30,
                ),
                onPressed: _toggleDarkMode,
                tooltip: _isDarkMode ? 'تفعيل الوضع المضيء' : 'تفعيل الوضع المظلم',
              ),
              SizedBox(width: 8), // مسافة بين الزر والنص
              const Text('المظهر:', style: TextStyle(fontSize: 18)),
            ],
          ),
          SizedBox(height: 16),
          const Text(
            'الإصدار: 1.0',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
