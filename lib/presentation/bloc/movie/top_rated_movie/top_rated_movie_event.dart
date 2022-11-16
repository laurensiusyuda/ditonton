import 'package:equatable/equatable.dart';

abstract class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovieEvent extends TopRatedMovieEvent {}