import 'package:dreamscope/features/dream/domain/entities/folder.dart';
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:dreamscope/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderSelector extends StatelessWidget {
  final String? selectedFolderId;
  final ValueChanged<String?> onFolderSelected;

  const FolderSelector({
    super.key,
    required this.selectedFolderId,
    required this.onFolderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FolderListBloc>()..add(LoadFolders()),
      child: BlocBuilder<FolderListBloc, FolderListState>(
        builder: (context, state) {
          if (state is FolderListLoading) {
            return const CircularProgressIndicator();
          }
          if (state is FolderListLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Klasör Seçin (İsteğe bağlı)',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String?>(
                    value: selectedFolderId,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      hintText: 'Klasör seçin veya boş bırakın',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Klasör Yok'),
                      ),
                      ...state.folders
                          .map((folder) => DropdownMenuItem<String?>(
                                value: folder.id,
                                child: Text(folder.name),
                              )),
                    ],
                    onChanged: onFolderSelected,
                  ),
                ),
              ],
            );
          }
          return const Text('Klasörler yüklenemedi');
        },
      ),
    );
  }
}
