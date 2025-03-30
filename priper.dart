import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  String geolocationStatus = "On";
  String mobileInternetStatus = "On";
  Map<String, String> privacyData = {
    "Personal data": "",
    "Personal address": "",
    "Work/study place": "",
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      geolocationStatus = prefs.getString('geolocationStatus') ?? "On";
      mobileInternetStatus = prefs.getString('mobileInternetStatus') ?? "On";
      privacyData = {
        "Personal data": prefs.getString('personalData') ?? "",
        "Personal address": prefs.getString('personalAddress') ?? "",
        "Work/study place": prefs.getString('workplace') ?? "",
      };
    });
  }

  Future<void> _savePermission(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _savePrivacyData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes were saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(title: const Text("Security")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsCard(
              title: "Permission",
              items: [
                _buildClickableItem(
                  "Geolocation",
                  geolocationStatus,
                  () => _showPermissionDialog(
                    "Geolocation",
                    geolocationStatus,
                    "geolocationStatus",
                  ),
                ),
                _buildDivider(),
                _buildClickableItem(
                  "Mobile internet",
                  mobileInternetStatus,
                  () => _showPermissionDialog(
                    "Mobile internet",
                    mobileInternetStatus,
                    "mobileInternetStatus",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              title: "Confidentiality",
              items: [
                _buildClickableItem(
                  "Personal data",
                  privacyData["Personal data"] ?? "",
                  () => _showPrivacyDialog(
                    "Personal data",
                    privacyData["Personal data"] ?? "",
                    "personalData",
                  ),
                ),
                _buildDivider(),
                _buildClickableItem(
                  "Personal address",
                  privacyData["Personal address"] ?? "",
                  () => _showPrivacyDialog(
                    "Personal address",
                    privacyData["Personal address"] ?? "",
                    "personalAddress",
                  ),
                ),
                _buildDivider(),
                _buildClickableItem(
                  "Work/study place",
                  privacyData["Work/study place"] ?? "",
                  () => _showPrivacyDialog(
                    "Work/study place",
                    privacyData["Work/study place"] ?? "",
                    "workplace",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableItem(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              "$value >",
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Colors.grey);
  }

  void _showPermissionDialog(
    String title,
    String currentStatus,
    String prefKey,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change $title"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ["On", "Off"].map((option) {
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        color:
                            option == currentStatus
                                ? Colors.blue
                                : Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(
                        () =>
                            prefKey == "geolocationStatus"
                                ? geolocationStatus = option
                                : mobileInternetStatus = option,
                      );
                      _savePermission(prefKey, option);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showPrivacyDialog(String title, String currentValue, String prefKey) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => privacyData[title] = controller.text);
                  _savePrivacyData(prefKey, controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
