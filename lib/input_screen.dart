
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'health_records_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final supabase = Supabase.instance.client;

  final activityController = TextEditingController();
  final sleepController = TextEditingController();
  final foodSearchController = TextEditingController();

  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFEAF3EA);
  static const Color background = Color(0xFFF7F9F7);

  String selectedGoal = 'Improve my daily habits';
  String recommendations = '';

  bool isSaving = false;

  final Set<String> selectedFoodPreferences = {
    'No specific preference',
  };

  final List<String> foodPreferences = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Halal',
    'Kosher',
    'Lactose-free',
    'Dairy-free',
    'Gluten-free',
    'Low-sodium preference',
    'Nut allergy',
    'Peanut allergy',
    'Egg allergy',
    'Seafood allergy',
    'Shellfish allergy',
    'Soy allergy',
    'Sesame allergy',
  ];

  final List<String> goals = [
    'Improve my daily habits',
    'Eat more balanced meals',
    'Improve my sleep',
    'Become more active',
    'Improve my overall wellbeing',
  ];

  List<String> get filteredFoodPreferences {
    final search = foodSearchController.text.trim().toLowerCase();

    if (search.isEmpty) return [];

    return foodPreferences
        .where((preference) =>
            preference.toLowerCase().contains(search))
        .toList();
  }

  bool get showCustomOption {
    final search = foodSearchController.text.trim();

    if (search.isEmpty) return false;

    return !foodPreferences.any(
      (preference) =>
          preference.toLowerCase() == search.toLowerCase(),
    );
  }

  void toggleFoodPreference(String preference) {
    setState(() {
      if (selectedFoodPreferences.contains(preference)) {
        selectedFoodPreferences.remove(preference);
      } else {
        selectedFoodPreferences.remove('No specific preference');
        selectedFoodPreferences.add(preference);
      }

      if (selectedFoodPreferences.isEmpty) {
        selectedFoodPreferences.add('No specific preference');
      }
    });
  }

  void addCustomPreference() {
    final customPreference = foodSearchController.text.trim();

    if (customPreference.isEmpty) return;

    final alreadyExists = selectedFoodPreferences.any(
      (preference) =>
          preference.toLowerCase() ==
          customPreference.toLowerCase(),
    );

    if (!alreadyExists) {
      setState(() {
        selectedFoodPreferences.remove('No specific preference');
        selectedFoodPreferences.add(customPreference);
        foodSearchController.clear();
      });
    } else {
      setState(() {
        foodSearchController.clear();
      });
    }

    FocusScope.of(context).unfocus();
  }

  // Create a wellness plan locally without using an AI API.
  String createWellnessPlan({
    required String activity,
    required String sleep,
    required List<String> preferences,
  }) {
    final activityText = activity.trim();
    final sleepText = sleep.trim();

    final normalizedPreferences =
        preferences.map((item) => item.toLowerCase()).toList();

    bool hasPreference(String value) {
      return normalizedPreferences.any(
        (item) => item.contains(value.toLowerCase()),
      );
    }

    final hasAllergy = normalizedPreferences.any(
      (item) => item.contains('allergy'),
    );

    final foodNotes = <String>[];

    if (hasPreference('vegan')) {
      foodNotes.add(
        'Choose plant-based foods that suit your preferences.',
      );
    } else if (hasPreference('vegetarian')) {
      foodNotes.add(
        'Choose vegetarian food options that suit your preferences.',
      );
    } else if (hasPreference('pescatarian')) {
      foodNotes.add(
        'Choose meals that fit your pescatarian preference.',
      );
    } else {
      foodNotes.add(
        'Try to include a variety of foods from different food groups.',
      );
    }

    if (hasPreference('halal')) {
      foodNotes.add(
        'Check that food and ingredients meet your halal preference.',
      );
    }

    if (hasPreference('kosher')) {
      foodNotes.add(
        'Check that food and ingredients meet your kosher preference.',
      );
    }

    if (hasPreference('lactose-free') ||
        hasPreference('dairy-free')) {
      foodNotes.add(
        'Choose lactose-free or dairy-free alternatives where needed.',
      );
    }

    if (hasPreference('gluten-free')) {
      foodNotes.add(
        'Look for suitable gluten-free food options and check labels.',
      );
    }

    if (hasPreference('low-sodium')) {
      foodNotes.add(
        'Be mindful of salty packaged foods and check food labels.',
      );
    }

    if (hasAllergy) {
      foodNotes.add(
        'You selected an allergy. Avoid the relevant allergen, '
        'check ingredient labels carefully, and ask a trusted '
        'adult or healthcare professional about food safety.',
      );
    }

    final activitySuggestions = <String>[];

    switch (selectedGoal) {
      case 'Become more active':
        activitySuggestions.addAll([
          'Look for enjoyable ways to move during your day.',
          'Try short movement breaks between long periods of sitting.',
          'Choose activities that feel comfortable and appropriate for you.',
        ]);
        break;

      case 'Eat more balanced meals':
        activitySuggestions.addAll([
          'Build regular meals with a variety of foods.',
          'Include foods you enjoy while respecting your selected preferences.',
          'Try to eat meals at consistent times when possible.',
        ]);
        break;

      case 'Improve my sleep':
        activitySuggestions.addAll([
          'Try to keep a consistent bedtime and wake-up routine.',
          'Create a calm environment when getting ready for bed.',
          'Give yourself time to relax before sleeping.',
        ]);
        break;

      case 'Improve my overall wellbeing':
        activitySuggestions.addAll([
          'Make time for activities that help you feel relaxed.',
          'Balance school, hobbies, rest and time with family or friends.',
          'Try to include enjoyable movement in your routine.',
        ]);
        break;

      default:
        activitySuggestions.addAll([
          'Start with one or two small habits you can practise regularly.',
          'Take breaks during long periods of schoolwork or screen time.',
          'Make time for rest, hobbies and enjoyable activities.',
        ]);
    }

    final sleepSuggestions = [
      'Try to follow a consistent sleep and wake-up schedule.',
      'Reduce stimulating screen activities before bedtime if they make it harder to relax.',
      'Keep your sleeping space comfortable, quiet and suitable for rest.',
    ];

    final goalSummary = switch (selectedGoal) {
      'Eat more balanced meals' =>
        'Your plan focuses on building balanced eating habits.',
      'Improve my sleep' =>
        'Your plan focuses on creating a more consistent sleep routine.',
      'Become more active' =>
        'Your plan focuses on enjoyable movement and regular activity.',
      'Improve my overall wellbeing' =>
        'Your plan focuses on balancing everyday activities and rest.',
      _ =>
        'Your plan focuses on building positive everyday habits.',
    };

    final sections = <String>[
      '1. Personalised Overview\n'
          '$goalSummary\n\n'
          'Your current activity routine: $activityText\n'
          'Your current sleep routine: $sleepText',

      '2. Daily Activity Suggestions\n'
          '${activitySuggestions.map((item) => '• $item').join('\n')}\n\n'
          'Your activity routine is a starting point. '
          'Make changes gradually and choose what feels comfortable.',

      '3. Sleep Routine Suggestions\n'
          '${sleepSuggestions.map((item) => '• $item').join('\n')}',

      '4. Balanced Food Suggestions\n'
          '${foodNotes.map((item) => '• $item').join('\n')}\n\n'
          'Your selected preferences: ${preferences.join(', ')}\n'
          'These are general ideas, not a personalised medical diet.',

      '5. Simple Daily Habits\n'
          '• Take regular breaks during schoolwork.\n'
          '• Drink water throughout the day.\n'
          '• Make time for hobbies and activities you enjoy.\n'
          '• Keep a simple record of habits you want to practise.',

      '6. Weekly Goals\n'
          '• Choose one small habit to practise this week.\n'
          '• Notice which parts of your routine work well.\n'
          '• Adjust your routine when something is not practical.\n'
          '• Remember that consistency matters more than perfection.',
    ];

    return sections.join('\n\n');
  }

  Future<void> generatePlan() async {
    final activity = activityController.text.trim();
    final sleep = sleepController.text.trim();
    final food = selectedFoodPreferences.toList()..sort();

    if (activity.isEmpty || sleep.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all the fields.'),
        ),
      );
      return;
    }

    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please log in before saving your information.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
      recommendations = '';
    });

    try {
      // Generate the recommendations directly on the device.
      final generatedRecommendations = createWellnessPlan(
        activity: activity,
        sleep: sleep,
        preferences: food,
      );

      if (!mounted) return;

      setState(() {
        recommendations = generatedRecommendations;
      });

      final savedPlan = '''
Your Personal Wellness Plan

Your Goal:
$selectedGoal

Activity:
$activity

Sleep:
$sleep

Food Preferences:
${food.join(', ')}

Your Recommendations:

$generatedRecommendations

These are general wellness suggestions, not medical advice.
''';

      // Save the plan to the user's Supabase account.
      await supabase.from('health_records').insert({
        'user_id': user.id,
        'health_data': {
          'goal': selectedGoal,
          'activity': activity,
          'sleep': sleep,
          'food_preferences': food.join(', '),
          'recommendations': savedPlan,
        },
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your wellness plan was generated and saved!',
          ),
          backgroundColor: green,
        ),
      );
    } on PostgrestException catch (error) {
      debugPrint('DATABASE ERROR: ${error.toString()}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Database error: ${error.message}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('GENERAL ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 10),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    activityController.dispose();
    sleepController.dispose();
    foodSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Row(
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              color: green,
              size: 27,
            ),
            SizedBox(width: 9),
            Text(
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
            tooltip: 'My Health Records',
            icon: const Icon(
              Icons.folder_open_outlined,
              color: darkGreen,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HealthRecordsScreen(),
                ),
              );
            },
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(23),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PERSONAL WELLNESS',
                          style: TextStyle(
                            color: green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your Health, Your Journey',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tell us about your daily habits and '
                          'let us help you build a balanced routine.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF526452),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              color: green,
                              size: 19,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Small steps make a difference.',
                              style: TextStyle(
                                color: darkGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  sectionTitle(
                    Icons.flag_outlined,
                    'Your Main Goal',
                    'What would you like to improve?',
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFE1E9E1),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedGoal,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      items: goals.map((goal) {
                        return DropdownMenuItem(
                          value: goal,
                          child: Text(
                            goal,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedGoal = value;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  sectionTitle(
                    Icons.directions_walk_outlined,
                    'Daily Activity',
                    'Tell us about your usual daily activities.',
                  ),

                  const SizedBox(height: 13),

                  buildTextField(
                    title: 'Daily Activity',
                    hint: 'Describe your usual daily activities...',
                    controller: activityController,
                  ),

                  const SizedBox(height: 23),

                  sectionTitle(
                    Icons.bedtime_outlined,
                    'Sleep Routine',
                    'Tell us about your usual sleep routine.',
                  ),

                  const SizedBox(height: 13),

                  buildTextField(
                    title: 'Sleep Routine',
                    hint: 'Describe your usual sleep routine...',
                    controller: sleepController,
                  ),

                  const SizedBox(height: 23),

                  sectionTitle(
                    Icons.restaurant_outlined,
                    'Food Preferences',
                    'Search and select your food preferences.',
                  ),

                  const SizedBox(height: 13),

                  buildFoodPreferenceSelector(),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : generatePlan,
                      icon: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(
                        isSaving
                            ? 'Saving Your Wellness Plan...'
                            : 'Generate My Wellness Plan',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (recommendations.isNotEmpty)
                    buildRecommendationsCard(),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      'Your health matters.',
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

  Widget sectionTitle(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: green,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE1E9E1),
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.all(17),
          border: InputBorder.none,
          hintStyle: const TextStyle(
            color: Colors.black38,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget buildFoodPreferenceSelector() {
    final filteredOptions = filteredFoodPreferences;
    final search = foodSearchController.text.trim();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE1E9E1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find your preferences',
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Type a preference below to see matching options.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: foodSearchController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'E.g. gluten-free, lactose-free, vegetarian...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: green,
              ),
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 19,
                      ),
                      onPressed: () {
                        foodSearchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: background,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          if (search.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: const Color(0xFFE1E9E1),
                ),
              ),
              child: Column(
                children: [
                  if (filteredOptions.isNotEmpty)
                    ...filteredOptions.map((preference) {
                      final isSelected =
                          selectedFoodPreferences.contains(preference);

                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (_) {
                          toggleFoodPreference(preference);
                        },
                        title: Text(
                          preference,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF394939),
                          ),
                        ),
                        activeColor: green,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      );
                    }),

                  if (showCustomOption)
                    ListTile(
                      leading: const Icon(
                        Icons.add_circle_outline,
                        color: green,
                      ),
                      title: const Text(
                        'Add custom preference',
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '"$search"',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.add,
                        color: green,
                      ),
                      onTap: addCustomPreference,
                    ),

                  if (filteredOptions.isEmpty && !showCustomOption)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No matching preferences found.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          const Text(
            'Selected preferences',
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          if (selectedFoodPreferences.isEmpty)
            const Text(
              'No preferences selected.',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedFoodPreferences.map((preference) {
                return Chip(
                  label: Text(
                    preference,
                    style: const TextStyle(
                      color: darkGreen,
                      fontSize: 12,
                    ),
                  ),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 16,
                    color: darkGreen,
                  ),
                  onDeleted: () {
                    toggleFoodPreference(preference);
                  },
                  backgroundColor: lightGreen,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget buildRecommendationsCard() {
    final sections = recommendations
        .split(RegExp(r'^\d+\.\s+', multiLine: true))
        .where((section) => section.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: green,
              size: 23,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Your Personalised Wellness Plan',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Suggestions created using your answers.',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),

        if (sections.isEmpty)
          recommendationSection(
            'Your Recommendations',
            recommendations,
            Icons.lightbulb_outline,
          )
        else
          ...sections.asMap().entries.map((entry) {
            final index = entry.key;
            final lines = entry.value.trim().split('\n');
            final heading = lines.first
                .replaceAll('**', '')
                .replaceAll('#', '')
                .replaceAll(':', '')
                .trim();

            final content = lines.skip(1).join('\n').trim();

            final icons = [
              Icons.person_outline,
              Icons.directions_walk_outlined,
              Icons.bedtime_outlined,
              Icons.restaurant_outlined,
              Icons.spa_outlined,
              Icons.calendar_month_outlined,
            ];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: recommendationSection(
                heading.isEmpty ? 'Recommendation' : heading,
                content.isEmpty ? entry.value.trim() : content,
                icons[index % icons.length],
              ),
            );
          }),

        const SizedBox(height: 10),
        const Text(
          'These are general wellness suggestions, not medical advice.',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget recommendationSection(
    String heading,
    String content,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDCEADC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 13),
            Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                height: 1.7,
                color: Color(0xFF394939),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
