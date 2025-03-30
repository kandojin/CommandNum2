import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About app"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Логотип приложения
          Center(
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/menu_icon.png",
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "App version 1.0.0",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const Text(
                  "Android device 13",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Список пунктов
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMenuItem("User agreement", context),
                _buildMenuItem("Privacy policy", context),
                _buildMenuItem("Rate the app", context),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          // Социальные сети
          const Text(
            "News and useful information:",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                "assets/menu_icon.png",
                "https://chatgpt.com",
              ), // Иконка приложения
              const SizedBox(width: 20),
              _buildSocialIcon(
                "assets/instagram.png",
                "https://www.instagram.com/qorgau_app?igsh=MWh3dWJ4bWE4NnB0aQ%3D%3D&utm_source=qr",
              ), // Иконка Instagram
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Не удалось открыть $url';
    }
  }

  // Виджет пункта меню
  Widget _buildMenuItem(String title, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            if (title == "User agreement") {
              _showAgreementDialog(context);
            } else if (title == "Privacy policy") {
              _showPrivacyPolicyDialog(context);
            } else if (title == "Rate the app") {
              _showRateDialog(context);
            }
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(assetPath, width: 60, height: 60),
    );
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "You can rate the \"Qorgau\" in the GooglePlay when it appears there!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрывает диалог
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("User agreement of mobile app \"Qorgau\""),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Last updated: 30.03.2025\n\n"
                  "   This User Agreement (hereinafter referred to as the \"Agreement\") regulates the relationship between the user (hereinafter referred to as the \"User\") and the Administration of the Qorgau mobile application (hereinafter referred to as the \"Administration\") related to establishing communication between the public and law enforcement agencies.\n\n"
                  "   Please read the terms of the Agreement carefully before using the app. By installing and using the application, the User agrees to the terms of this Agreement.\n",
                ),
                Text(
                  "1. General provisions\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "1.1. \"Qorgau\" is intended for the operational communication of citizens with law enforcement agencies.\n"
                  "1.2. The use of the Application is free of charge, however, Internet access may be required.\n"
                  "1.3. The application does not replace emergency services such as 102 (Police).\n\n",
                ),
                Text(
                  "2. Registration and account usage\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "2.1. To use the full functionality, the User can register by providing correct information.\n"
                  "2.2. The User is responsible for the security of his account."
                  "2.3. The Administration reserves the right to suspend accounts that violate the terms.\n\n",
                ),
                Text(
                  "3. Duties and responsibilities of the User\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "3.1. The User undertakes to use the Application only for legitimate purposes."
                  "3.2. Misuse of functions (for example, false calls) may result in administrative liability.\n\n",
                ),
                Text(
                  "4. Duties and responsibilities of the Administration\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "4.1. The Administration is not responsible for the accuracy of the information provided by Users.\n"
                  "4.2. The Administration undertakes to ensure the protection of Users' personal data.\n\n",
                ),
                Text(
                  "5. Personal data processing\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "5.1. Upon registration, the User submits his personal data to the Administration.\n"
                  "5.2. The data is processed in accordance with the Privacy Policy.\n\n",
                ),
                Text(
                  "6. Intellectual Property\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "6.1. All elements of the Application are the intellectual property of the Administration.\n"
                  "6.2. It is prohibited to copy and distribute materials without written consent.\n\n",
                ),
                Text(
                  "7. Amendment of the terms of the Agreement\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "7.1. The Administration reserves the right to change the terms of the Agreement."
                  "7.2. The amended terms and Conditions come into force from the moment of their publication.\n\n",
                ),
                Text(
                  "8. Contact information\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "📧 Email: Qorgau_Aplication.gmail.com\n"
                  "📞 Phone: +7 777 777-77-77\n"
                  "🏢 Address: Pushkin Street, Kolotushkin House\n\n",
                ),
                Text(
                  "⚠ If you do not agree with the terms of this Agreement, stop using the Application and delete it from your device.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Privacy Policy of the \"Qorgau\" mobile application",
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Last updated: 30.03.2025\n\n"
                  " This Privacy Policy (hereinafter referred to as the \"Policy\") explains how the Qorgau application (hereinafter referred to as the \"Application\") collects, uses, processes and protects users' personal data (hereinafter referred to as the \"User\").\n\n"
                  " By using the Application, the User agrees to the terms of this Policy. If the User does not agree with the terms, they must stop using the Application.\n",
                ),
                Text(
                  "1. What data do we collect?\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " We may collect the following categories of data:\n"
                  "1.1. Registration data: name, phone number, email (during registration).\n"
                  "1.2. Technical information: IP address, device model, operating system, application version.\n\n"
                  "1.3. Data provided by the User: complaints, reports of violations, feedback.\n\n"
                  "1.4. Location data (if authorized by the User) is used for the accurate provision of services.\n",
                ),
                Text(
                  "2. How do we use the data?\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " We use the collected data to:"
                  "2.1. Ensure the operation of the Application and its functionality.\n"
                  "2.2. User feedback support.\n"
                  "2.3. Service quality improvements (bug fixes, new features added).\n"
                  "2.4. Informing the User about important changes and updates.\n"
                  "2.5. Compliance with legal requirements.\n\n",
                ),
                Text(
                  "3. Transfer of data to third parties\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " We do not sell or transfer Users' personal data to third parties, except in the following cases::\n"
                  "3.1. At the request of law enforcement agencies in accordance with the legislation.\n"
                  "3.2. To ensure User safety and fraud prevention.\n"
                  "3.3. If the User has given explicit consent to the transfer of data.\n\n",
                ),
                Text(
                  "4. How do we protect data?\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " We are taking all necessary measures to protect User data:\n"
                  "4.1. We use modern encryption technologies.\n"
                  "4.2. We restrict access to data only to authorized employees.\n"
                  "4.3. We are constantly improving measures to protect against data leaks."
                  "However, we cannot guarantee 100% security of the data when it is transmitted over the Internet, so the User must also take precautions.\n\n",
                ),
                Text(
                  "5. Data storage\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "5.1. Personal Data is stored for the period necessary to fulfill the purposes specified in this Policy."
                  "5.2. After account deletion, User data may be stored for [N] months in order to fulfill legal obligations.\n\n",
                ),
                Text(
                  "6. User Rights\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " The user has the following rights with respect to his data:\n"
                  "6.1. Get information about what data is stored about it.\n"
                  "6.2. Correct or delete your data if necessary."
                  "6.3. Restrict the processing of your data within the framework of the law."
                  "6.4. Revoke consent to data processing (but this may limit the use of the Application).\n"
                  " If you have any questions about deleting or changing your data, please contact us using the contact information below.\n\n",
                ),
                Text(
                  "7. Changes to the Privacy Policy\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "7.1. We reserve the right to make changes to the Policy.\n"
                  "7.2. The updated version of the Policy will be published in the Appendix.\n"
                  "7.3. Continued use of the Application after making changes means that the User agrees with the new version of the Policy.\n\n",
                ),
                Text(
                  "8. Contact information\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "If you have any questions about the Privacy Policy, please contact us:\n"
                  "📧 Email: Qorgau_Aplication.gmail.com\n"
                  "📞 Phone: +7 777 777-77-77\n"
                  "🏢 Address: Pushkin Street, Kolotushkin House\n\n",
                ),
                Text(
                  "💡 This Privacy Policy is designed to protect your data and ensure transparency in their processing.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрывает диалог
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
