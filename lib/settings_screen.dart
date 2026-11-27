import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';
import 'settings_translations.dart';
import 'notification_service.dart';

class SettingsScreen extends StatefulWidget {
  final AppLanguage appLanguage;

  const SettingsScreen({super.key, required this.appLanguage});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFEAF3EA);
  static const Color background = Color(0xFFF7F9F7);

  static const String countryKey = 'selected_product_country';

  static const List<String> countries = [
    'Saudi Arabia',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Canada',
    'Australia',
    'France',
    'Germany',
    'Italy',
    'Spain',
    'Portugal',
    'Russia',
    'China',
    'Japan',
    'South Korea',
    'India',
    'Brazil',
  ];

  String selectedCountry = 'Saudi Arabia';
  bool loading = true;

  String t(String key) {
    return SettingsTranslations.text(widget.appLanguage.languageCode, key);
  }

  @override
  void initState() {
    super.initState();
    loadCountry();
  }

  Future<void> loadCountry() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCountry = preferences.getString(countryKey);

    if (!mounted) return;

    setState(() {
      if (savedCountry != null && countries.contains(savedCountry)) {
        selectedCountry = savedCountry;
      }

      loading = false;
    });
  }

  Future<void> saveCountry(String country) async {
    setState(() {
      selectedCountry = country;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(countryKey, country);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${t('country_saved')} $country'),
        backgroundColor: green,
      ),
    );
  }

  Future<void> _sendTestNotification() async {
    try {
      await NotificationService.showTestNotification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Test notification sent. Check your Mac notifications.',
          ),
          backgroundColor: green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          t('settings'),
          style: const TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: darkGreen),
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: green))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: green, size: 30),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            t('personalise'),
                            style: const TextStyle(
                              color: darkGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    t('language'),
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE8EEE8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.language, color: green),
                              const SizedBox(width: 10),
                              Text(
                                t('app_language'),
                                style: const TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          DropdownButtonFormField<String>(
                            key: ValueKey(widget.appLanguage.languageCode),
                            initialValue: widget.appLanguage.languageCode,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: AppLanguage.languages.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                widget.appLanguage.setLanguage(value);
                              }
                            },
                          ),

                          const SizedBox(height: 8),

                          Text(
                            t('language_saved'),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    t('food_explorer'),
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE8EEE8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.public_outlined, color: green),
                              const SizedBox(width: 10),
                              Text(
                                t('product_country'),
                                style: const TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          DropdownButtonFormField<String>(
                            initialValue: selectedCountry,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: countries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                saveCountry(value);
                              }
                            },
                          ),

                          const SizedBox(height: 8),

                          Text(
                            t('country_info'),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'NOTIFICATIONS',
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE8EEE8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                color: green,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Test notifications',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Check that Smart Health notifications are working.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              onPressed: _sendTestNotification,
                              icon: const Icon(Icons.notifications),
                              label: const Text('Send test notification'),
                              style: FilledButton.styleFrom(
                                backgroundColor: green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
