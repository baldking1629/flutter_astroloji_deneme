part of 'saved_horoscope_cubit.dart';

abstract class SavedHoroscopeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SavedHoroscopeInitial extends SavedHoroscopeState {}

class SavedHoroscopeLoading extends SavedHoroscopeState {}

class SavedHoroscopeLoaded extends SavedHoroscopeState {
  final List<SavedHoroscope> horoscopes;
  SavedHoroscopeLoaded(this.horoscopes);
  @override
  List<Object?> get props => [horoscopes];
}

class SavedHoroscopeError extends SavedHoroscopeState {
  final String message;
  SavedHoroscopeError(this.message);
  @override
  List<Object?> get props => [message];
}
