
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'input_screen.dart';
import 'health_records_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Widget Function() loginScreenBuilder;

  const DashboardScreen({
    super.key,
    required this.loginScreenBuilder,
  });

  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFEAF3EA);
  static const Color background = Color(0xFFF7F9F7);

  Future<void> logout(BuildContext context) async {
    final supabase = Supabase.instance.client;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: green,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.auth.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => loginScreenBuilder(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not log out: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final fullName =
        user?.userMetadata?['full_name']?.toString();

    final emailName = user?.email?.split('@').first ?? 'User';

    final displayName =
        fullName != null && fullName.trim().isNotEmpty
            ? fullName
            : emailName;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const Icon(
              Icons.health_and_safety,
              color: green,
              size: 29,
            ),
            const SizedBox(width: 10),
            const Text(
              'Smart Health',
              style: TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(
              Icons.logout_rounded,
              color: darkGreen,
            ),
            onPressed: () => logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Welcome section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR WELLNESS JOURNEY',
                          style: TextStyle(
                            color: green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Welcome, $displayName!',
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Take small steps towards a healthier '
                          'and more balanced lifestyle.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF526452),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Row(
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              color: green,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Your health matters.',
                              style: TextStyle(
                                color: darkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Dashboard heading
                  const Text(
                    'Your Dashboard',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'What would you like to do today?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 17),

                  // Create wellness plan
                  dashboardCard(
                    icon: Icons.add_circle_outline,
                    title: 'Create Wellness Plan',
                    description:
                        'Enter your daily habits and generate '
                        'a personalised wellness plan.',
                    buttonText: 'Get Started',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InputScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Health records
                  dashboardCard(
                    icon: Icons.folder_open_outlined,
                    title: 'My Health Records',
                    description:
                        'View and manage your saved wellness plans.',
                    buttonText: 'View Records',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const HealthRecordsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Wellness tips
                  const Text(
                    'Daily Wellness Tips',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'A few simple reminders for your day.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 17),

                  tipCard(
                    Icons.water_drop_outlined,
                    'Stay Hydrated',
                    'Remember to drink water regularly.',
                  ),

                  tipCard(
                    Icons.bedtime_outlined,
                    'Build a Sleep Routine',
                    'Try to maintain a regular sleep schedule.',
                  ),

                  tipCard(
                    Icons.directions_walk_outlined,
                    'Keep Moving',
                    'Make time for enjoyable daily activities.',
                  ),

                  tipCard(
                    Icons.restaurant_outlined,
                    'Enjoy Balanced Meals',
                    'Include different types of food in your meals.',
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      'Small steps. Better habits. Healthier living.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Color(0xFFE8EEE8),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: green,
                  size: 29,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: green,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tipCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 11),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Color(0xFFE8EEE8),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: green,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
