import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/usecases_movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation_movie/recomendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation_movie/recomendation_movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/recomendation_movie/recomendation_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_movie_bloc_test.mocks.dart';

@GenerateMocks([RecommendationMovieBloc, GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendation;
  late RecommendationMovieBloc recommendationMovieBloc;

  setUp(() {
    mockGetMovieRecommendation = MockGetMovieRecommendations();
    recommendationMovieBloc =
        RecommendationMovieBloc(mockGetMovieRecommendation);
  });

  test("initial state should be empty", () {
    expect(recommendationMovieBloc.state, RecommendationMovieEmpty());
  });

  const movieId = 1;
  final movieList = <Movie>[];

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendation.execute(movieId)).thenAnswer(
        (_) async => Right(movieList),
      );
      return recommendationMovieBloc;
    },
    act: (bloc) => bloc.add(FetchRecommendationMovieEvent(movieId)),
    expect: () => [
      RecommendationMovieLoading(),
      RecommendationMovieLoaded(movieList),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendation.execute(movieId));
    },
  );

  group('Recommendation Movies BLoC Test', () {
    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
      'Should emit [Loading, Error] when get recommendation is unsuccessful',
      build: () {
        when(mockGetMovieRecommendation.execute(movieId)).thenAnswer(
          (_) async => Left(ServerFailure('Server Failure')),
        );
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(FetchRecommendationMovieEvent(movieId)),
      expect: () => [
        RecommendationMovieLoading(),
        RecommendationMovieError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieRecommendation.execute(movieId));
      },
    );
  });
}
