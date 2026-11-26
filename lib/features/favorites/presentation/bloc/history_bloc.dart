import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_history.dart';
import '../../domain/usecases/clear_history.dart';
import '../../domain/usecases/get_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;
  final AddToHistory addToHistory;
  final ClearHistory clearHistory;
  final Stream<String?> userStream;
  StreamSubscription<String?>? _userSub;

  HistoryBloc({
    required this.getHistory,
    required this.addToHistory,
    required this.clearHistory,
    required this.userStream,
  }) : super(const HistoryInitial()) {
    on<LoadHistory>(_onLoad);
    on<AddMovieToHistory>(_onAdd);
    on<ClearAllHistory>(_onClear);
    on<ClearHistoryState>((event, emit) => emit(const HistoryInitial()));

    _userSub = userStream.listen((uid) {
      add(uid == null ? const ClearHistoryState() : const LoadHistory());
    });
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }

  Future<void> _onLoad(LoadHistory event, Emitter<HistoryState> emit) async {
    emit(const HistoryLoading());
    final result = await getHistory(const NoParams());
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (movies) => emit(HistoryLoaded(movies)),
    );
  }

  /// تسجيل المشاهدة عملية خلفية: لو فشلت ما نعرضش error في تاب الـ History.
  /// ولو نجحت بنحدّث القائمة محلياً (الفيلم يطلع فوق من غير تكرار)
  /// بدل ما نعمل fetch للقائمة كلها في كل مرة.
  Future<void> _onAdd(
    AddMovieToHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final result = await addToHistory(event.movie);
    result.fold(
      (_) {},
      (_) {
        final current = state;
        if (current is HistoryLoaded) {
          emit(
            HistoryLoaded([
              event.movie,
              ...current.movies.where((m) => m.movieId != event.movie.movieId),
            ]),
          );
        } else {
          // القائمة لسه ما اتحمّلتش، فنحمّلها كاملة بدل ما نعرض فيلم واحد بس.
          add(const LoadHistory());
        }
      },
    );
  }

  Future<void> _onClear(
    ClearAllHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final result = await clearHistory(const NoParams());
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (_) => emit(const HistoryLoaded([])),
    );
  }
}