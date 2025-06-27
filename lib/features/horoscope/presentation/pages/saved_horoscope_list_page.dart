import 'package:dreamscope/features/horoscope/presentation/cubit/saved_horoscope_cubit.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedHoroscopeListPage extends StatelessWidget {
  const SavedHoroscopeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SavedHoroscopeCubit>()..loadSavedHoroscopes(),
      child: const SavedHoroscopeListView(),
    );
  }
}

class SavedHoroscopeListView extends StatelessWidget {
  const SavedHoroscopeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kaydedilen Burç Yorumları')),
      body: BlocBuilder<SavedHoroscopeCubit, SavedHoroscopeState>(
        builder: (context, state) {
          if (state is SavedHoroscopeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SavedHoroscopeLoaded) {
            if (state.horoscopes.isEmpty) {
              return const Center(
                  child: Text('Henüz kaydedilmiş burç yorumu yok.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.horoscopes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final h = state.horoscopes[index];
                return Card(
                  child: ListTile(
                    title: Text('${h.zodiacSign.toUpperCase()} - ${h.period}'),
                    subtitle: Text(h.content,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Yorumu Sil'),
                            content: const Text(
                                'Bu yorumu silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sil'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          context
                              .read<SavedHoroscopeCubit>()
                              .deleteHoroscope(h.id);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
          if (state is SavedHoroscopeError) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
