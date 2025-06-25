import 'package:dreamscope/features/dream/presentation/bloc/dream_form/dream_form_bloc.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddDreamPage extends StatelessWidget {
  const AddDreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DreamFormBloc>(),
      child: const AddDreamView(),
    );
  }
}

class AddDreamView extends StatefulWidget {
  const AddDreamView({super.key});

  @override
  State<AddDreamView> createState() => _AddDreamViewState();
}

class _AddDreamViewState extends State<AddDreamView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newDreamTitle),
      ),
      body: BlocConsumer<DreamFormBloc, DreamFormState>(
        listener: (context, state) {
          if (state is DreamFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(l10n.analysisComplete),
                  backgroundColor: Colors.green),
            );
            context.pop(true);
          } else if (state is DreamFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(l10n.errorOccurred),
                  backgroundColor: theme.colorScheme.error),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is DreamFormSubmitting;

          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.dreamTitleLabel,
                        hintText: l10n.dreamTitleHint,
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Title cannot be empty' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: l10n.dreamContentLabel,
                        hintText: l10n.dreamContentHint,
                      ),
                      maxLines: 10,
                      validator: (value) =>
                          value!.isEmpty ? 'Content cannot be empty' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<DreamFormBloc>().add(
                                      SubmitDream(
                                        title: _titleController.text,
                                        content: _contentController.text,
                                      ),
                                    );
                              }
                            },
                      child: Text(l10n.saveAndAnalyzeButton),
                    ),
                  ],
                ),
              ),
              if (isSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l10n.analyzingDream,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
