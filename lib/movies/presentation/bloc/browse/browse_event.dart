import 'package:equatable/equatable.dart';

abstract class BrowseEvent extends Equatable {
  const BrowseEvent();

  @override
  List<Object?> get props => [];
}

class LoadBrowseEvent extends BrowseEvent {
  const LoadBrowseEvent();
}

class SelectGenreEvent extends BrowseEvent {
  final String? genre;

  const SelectGenreEvent(this.genre);

  @override
  List<Object?> get props => [genre];
}

class LoadMoreBrowseEvent extends BrowseEvent {
  const LoadMoreBrowseEvent();
}
