import 'package:dio/dio.dart';
import 'package:dreamscope/features/dream/data/datasources/dream_local_data_source.dart';
import 'package:dreamscope/features/dream/data/datasources/dream_remote_data_source.dart';
import 'package:dreamscope/features/dream/data/repositories/dream_repository_impl.dart';
import 'package:dreamscope/features/dream/domain/repositories/dream_repository.dart';
import 'package:dreamscope/features/dream/domain/usecases/analyze_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/delete_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_all_dreams.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/save_dream.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_dream.dart';
import 'package:dreamscope/features/dream/presentation/bloc/dream_form/dream_form_bloc.dart';
import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'package:dreamscope/features/horoscope/data/datasources/saved_horoscope_local_data_source.dart';
import 'package:dreamscope/features/horoscope/data/repositories/horoscope_repository_impl.dart';
import 'package:dreamscope/features/horoscope/data/repositories/saved_horoscope_repository_impl.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/horoscope_repository.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/saved_horoscope_repository.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/get_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/save_horoscope.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/get_all_saved_horoscopes.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/delete_saved_horoscope.dart';
import 'package:dreamscope/features/horoscope/presentation/cubit/horoscope_cubit.dart';
import 'package:dreamscope/features/horoscope/presentation/cubit/saved_horoscope_cubit.dart';
import 'package:dreamscope/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dreamscope/features/settings/data/datasources/theme_local_data_source.dart';
import 'package:dreamscope/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:dreamscope/features/settings/domain/usecases/get_locale.dart';
import 'package:dreamscope/features/settings/domain/usecases/save_locale.dart';
import 'package:dreamscope/features/settings/domain/usecases/get_theme.dart';
import 'package:dreamscope/features/settings/domain/usecases/save_theme.dart';
import 'package:dreamscope/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:dreamscope/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:dreamscope/features/profile/domain/repositories/profile_repository.dart';
import 'package:dreamscope/features/profile/domain/usecases/get_user_profile.dart';
import 'package:dreamscope/features/profile/domain/usecases/save_user_profile.dart';
import 'package:dreamscope/presentation/app_blocs/locale/locale_cubit.dart';
import 'package:dreamscope/presentation/app_blocs/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dreamscope/features/dream/data/datasources/folder_local_data_source.dart';
import 'package:dreamscope/features/dream/data/repositories/folder_repository_impl.dart';
import 'package:dreamscope/features/dream/domain/repositories/folder_repository.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_all_folders.dart';
import 'package:dreamscope/features/dream/domain/usecases/save_folder.dart';
import 'package:dreamscope/features/dream/domain/usecases/delete_folder.dart'
    as folder_usecase;
import 'package:dreamscope/features/dream/domain/usecases/delete_dream.dart'
    as dream_usecase;
import 'package:dreamscope/features/dream/presentation/bloc/folder_list/folder_list_bloc.dart';
import 'package:dreamscope/features/dream/domain/usecases/get_dreams_by_folder.dart';
import 'package:dreamscope/features/dream/domain/usecases/update_folder_dream_count.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Features ---

  // Dream
  _registerDreamFeature();

  // Horoscope
  _registerHoroscopeFeature();

  // Settings / Locale / Theme
  _registerSettingsFeature();

  // Profile
  _registerProfileFeature();

  // --- Core ---

  // App Blocs
  sl.registerFactory(() => LocaleCubit(getLocale: sl(), saveLocale: sl()));
  sl.registerFactory(() => ThemeCubit());

  // External
  final appDir = await getApplicationDocumentsDirectory();
  await appDir.create(recursive: true);
  final dbPath = join(appDir.path, 'dreamscope.db');
  final database = await databaseFactoryIo.openDatabase(dbPath);
  sl.registerSingleton<Database>(database);

  sl.registerLazySingleton(() => Dio());

  // Get API key from .env file
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  if (apiKey.isEmpty) {
    throw Exception(
        'GEMINI_API_KEY not found in .env file. Please add GEMINI_API_KEY=your_api_key to .env file');
  }

  sl.registerLazySingleton(
    () => GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    ),
  );
}

void _registerDreamFeature() {
  // BLoCs
  sl.registerFactory(() => DreamListBloc(
        getAllDreams: sl(),
        getDreamsByFolder: sl(),
        updateDream: sl(),
        deleteDream: sl(),
      ));
  sl.registerFactory(() => DreamFormBloc(
        saveDream: sl(),
        analyzeDream: sl(),
        updateFolderDreamCount: sl(),
      ));
  sl.registerFactory(() => FolderListBloc(
        getAllFolders: sl(),
        saveFolder: sl(),
        deleteFolder: sl(),
        updateFolderDreamCount: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetAllDreams(sl()));
  sl.registerLazySingleton(() => GetDream(sl()));
  sl.registerLazySingleton(() => SaveDream(sl()));
  sl.registerLazySingleton(() => UpdateDream(sl(), sl()));
  sl.registerLazySingleton(() => dream_usecase.DeleteDream(sl(), sl()));
  sl.registerLazySingleton(() => AnalyzeDream(sl()));
  sl.registerLazySingleton(() => GetDreamsByFolder(sl()));
  sl.registerLazySingleton(() => UpdateFolderDreamCount(
        folderRepository: sl(),
        dreamRepository: sl(),
      ));

  // Folder Use cases
  sl.registerLazySingleton(() => GetAllFolders(sl()));
  sl.registerLazySingleton(() => SaveFolder(sl()));
  sl.registerLazySingleton(() => folder_usecase.DeleteFolder(sl()));

  // Repositories
  sl.registerLazySingleton<DreamRepository>(
    () => DreamRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FolderRepository>(
    () => FolderRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DreamLocalDataSource>(
    () => SembastDreamLocalDataSource(sl()),
  );
  sl.registerLazySingleton<DreamRemoteDataSource>(
    () => GeminiDreamRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<FolderLocalDataSource>(
    () => SembastFolderLocalDataSource(sl()),
  );
}

void _registerHoroscopeFeature() {
  // Cubits
  sl.registerFactory(() => HoroscopeCubit(getHoroscope: sl()));
  sl.registerFactory(() => SavedHoroscopeCubit(
        getAllSavedHoroscopes: sl(),
        deleteSavedHoroscope: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetHoroscope(sl()));
  sl.registerLazySingleton(() => SaveHoroscope(sl()));
  sl.registerLazySingleton(() => GetAllSavedHoroscopes(sl()));
  sl.registerLazySingleton(() => DeleteSavedHoroscope(sl()));

  // Repositories
  sl.registerLazySingleton<HoroscopeRepository>(
    () => HoroscopeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SavedHoroscopeRepository>(
    () => SavedHoroscopeRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HoroscopeRemoteDataSource>(
    () => GeminiHoroscopeRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<SavedHoroscopeLocalDataSource>(
    () => SembastSavedHoroscopeLocalDataSource(sl()),
  );
}

void _registerSettingsFeature() {
  // Use cases
  sl.registerLazySingleton(() => GetLocale(sl()));
  sl.registerLazySingleton(() => SaveLocale(sl()));
  sl.registerLazySingleton(() => GetTheme(sl()));
  sl.registerLazySingleton(() => SaveTheme(sl()));

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: sl(),
      themeLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SembastSettingsLocalDataSource(sl()),
  );
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => SembastThemeLocalDataSource(sl()),
  );
}

void _registerProfileFeature() {
  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => SaveUserProfile(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => SembastProfileLocalDataSource(sl()),
  );
}
