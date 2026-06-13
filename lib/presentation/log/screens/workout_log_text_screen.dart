import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/meal_log/excersise_search_result.dart';
import '../../../data/models/save_log_request.dart';
import '../manager/log_bloc.dart';
import '../widgets/text_log_shared_widgets.dart';
import 'log_choice_screen.dart';
import 'log_page_shell.dart';

class TextLogWorkoutPage extends StatefulWidget {
  const TextLogWorkoutPage({super.key});

  @override
  State<TextLogWorkoutPage> createState() => _TextLogWorkoutPageState();
}

class _TextLogWorkoutPageState extends State<TextLogWorkoutPage> {
  Color get accent => AppConstants.primaryColor;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  ExerciseSearchResult? _selectedExercise;
  int _sets = 3;
  int _reps = 10;
  double? _weight;
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  static const _quickSearches = [
    'chest push with barbell',
    'back pull cable',
    'leg press machine',
    'shoulder press dumbbell',
    'bicep curl',
  ];

  // ── Actions ───────────────────────────────────────────────────────────────

  void _search(String query) {
    if (query.trim().length < 2) return;
    _searchFocus.unfocus();
    context.read<LogBloc>().add(SearchExercisesEvent(query.trim()));
  }

  void _onSave() {
    if (_selectedExercise == null) return;
    final weightText = _weightController.text.trim();
    final request = SaveLogRequest(
      category: 'workout',
      logDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      logMethod: 'TEXT',
      workoutEntries: [
        WorkoutLogEntry(
          centralExerciseId: _selectedExercise!.id,
          setsCompleted: _sets,
          repsCompleted: _reps,
          weightUsed: weightText.isNotEmpty
              ? double.tryParse(weightText)
              : null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        ),
      ],
    );
    context.read<LogBloc>().add(SaveLogsEvent(request));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogBloc, LogState>(
      listener: (context, state) {
        if (state is LogSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${_selectedExercise!.name} logged! '
                    '$_sets sets × $_reps reps',
              ),
              backgroundColor: accent,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is LogError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: LogPageShell(
        type: LogType.workout,
        methodLabel: 'Text',
        body: GestureDetector(
          onTap: () => _searchFocus.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Search bar ─────────────────────────────────────────────
                SearchBar(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  accent: accent,
                  hint: 'Describe the exercise...',
                  onSearch: _search,
                ),

                const SizedBox(height: 12),

                // ── Quick search chips ─────────────────────────────────────
                if (_selectedExercise == null)
                  QuickChips(
                    items: _quickSearches,
                    accent: accent,
                    onTap: (q) {
                      _searchController.text = q;
                      _search(q);
                    },
                  ),

                const SizedBox(height: 16),

                // ── Results / selected exercise ────────────────────────────
                Expanded(
                  child: BlocBuilder<LogBloc, LogState>(
                    builder: (context, state) {
                      if (state is LogLoading && !state.isSaving) {
                        return Center(
                          child: CircularProgressIndicator(color: accent),
                        );
                      }

                      if (state is ExerciseSearchSuccess &&
                          _selectedExercise == null) {
                        if (state.results.isEmpty) {
                          return const EmptyResults(
                              message:
                              'No exercises found. Try different words.');
                        }
                        return ListView.separated(
                          itemCount: state.results.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                          itemBuilder: (_, i) => ExerciseResultCard(
                            exercise: state.results[i],
                            accent: accent,
                            onTap: () => setState(
                                    () => _selectedExercise = state.results[i]),
                          ),
                        );
                      }

                      if (_selectedExercise != null) {
                        return SingleChildScrollView(
                          child: SelectedExercisePanel(
                            exercise: _selectedExercise!,
                            sets: _sets,
                            reps: _reps,
                            weightController: _weightController,
                            notesController: _notesController,
                            accent: accent,
                            onSetsChanged: (v) => setState(() => _sets = v),
                            onRepsChanged: (v) => setState(() => _reps = v),
                            onClear: () => setState(() {
                              _selectedExercise = null;
                              _sets = 3;
                              _reps = 10;
                              _weightController.clear();
                              _notesController.clear();
                            }),
                          ),
                        );
                      }

                      return IdleHint(
                        message:
                        'Describe an exercise above or pick a quick suggestion.',
                        icon: Icons.fitness_center_outlined,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Save button ────────────────────────────────────────────
                BlocBuilder<LogBloc, LogState>(
                  builder: (context, state) {
                    final isSaving =
                        state is LogLoading && state.isSaving;
                    return SaveButton(
                      enabled: _selectedExercise != null,
                      isSaving: isSaving,
                      accent: accent,
                      label: _selectedExercise != null
                          ? 'Save — $_sets × $_reps'
                          : 'Select an exercise first',
                      onTap: _onSave,
                    );
                  },
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}