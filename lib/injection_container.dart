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
import 'package:dreamscope/features/dream/presentation/bloc/dream_form/dream_form_bloc.dart';
import 'package:dreamscope/features/dream/presentation/bloc/dream_list/dream_list_bloc.dart';
import 'package:dreamscope/features/horoscope/data/datasources/horoscope_remote_data_source.dart';
import 'package:dreamscope/features/horoscope/data/repositories/horoscope_repository_impl.dart';
import 'package:dreamscope/features/horoscope/domain/repositories/horoscope_repository.dart';
import 'package:dreamscope/features/horoscope/domain/usecases/get_horoscope.dart';
import 'package:dreamscope/features/horoscope/presentation/cubit/horoscope_cubit.dart';
import 'package:dreamscope/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:dreamscope/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:dreamscope/features/settings/domain/repositories/settings_repository.dart';
import 'package:dreamscope/features/settings/domain/usecases/get_locale.dart';
import 'package:dreamscope/features/settings/domain/usecases/save_locale.dart';
import 'package:dreamscope/presentation/app_blocs/locale/locale_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Features ---

  // Dream
  _registerDreamFeature();

  // Horoscope
  _registerHoroscopeFeature();

  // Settings / Locale
  _registerSettingsFeature();

  // --- Core ---

  // App Blocs
  sl.registerFactory(() => LocaleCubit(getLocale: sl(), saveLocale: sl()));

  // External
  final appDir = await getApplicationDocumentsDirectory();
  await appDir.create(recursive: true);
  final dbPath = join(appDir.path, 'dreamscope.db');
  final database = await databaseFactoryIo.openDatabase(dbPath);
  sl.registerSingleton<Database>(database);

  sl.registerLazySingleton(() => Dio());

  // IMPORTANT: Add your Gemini API Key via --dart-define
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  if (apiKey.isEmpty) {
    throw Exception('Please provide a GEMINI_API_KEY environment variable.');
  }
  sl.registerLazySingleton(
    () => GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey),
  );
}

void _registerDreamFeature() {
  // BLoCs
  sl.registerFactory(() => DreamListBloc(getAllDreams: sl()));
  sl.registerFactory(() => DreamFormBloc(saveDream: sl(), analyzeDream: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllDreams(sl()));
  sl.registerLazySingleton(() => GetDream(sl()));
  sl.registerLazySingleton(() => SaveDream(sl()));
  sl.registerLazySingleton(() => DeleteDream(sl()));
  sl.registerLazySingleton(() => AnalyzeDream(sl()));

  // Repositories
  sl.registerLazySingleton<DreamRepository>(
    () => DreamRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DreamLocalDataSource>(
    () => SembastDreamLocalDataSource(sl()),
  );
  sl.registerLazySingleton<DreamRemoteDataSource>(
    () => GeminiDreamRemoteDataSource(sl()),
  );
}

void _registerHoroscopeFeature() {
  // Cubits
  sl.registerFactory(() => HoroscopeCubit(getHoroscope: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetHoroscope(sl()));

  // Repositories
  sl.registerLazySingleton<HoroscopeRepository>(
    () => HoroscopeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HoroscopeRemoteDataSource>(
    () => MockHoroscopeRemoteDataSource(sl()),
  );
}

void _registerSettingsFeature() {
  // Use cases
  sl.registerLazySingleton(() => GetLocale(sl()));
  sl.registerLazySingleton(() => SaveLocale(sl()));

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SembastSettingsLocalDataSource(sl()),
  );
}
