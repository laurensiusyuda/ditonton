import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/domain/entities/movie_entities/movie.dart';

import 'package:movie/presentation/bloc/movie/now_movie_playing/now_movie_playing_bloc.dart';
import 'package:movie/presentation/bloc/movie/now_movie_playing/now_movie_playing_event.dart';

import 'package:movie/presentation/bloc/movie/popular_movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movie/popular_movie_event.dart';

import 'package:movie/presentation/bloc/movie/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie/top_rated_movie_event.dart';
import 'package:movie/presentation/pages/movie/movie_detail_page.dart';
import 'package:movie/presentation/pages/movie/now_playing_movie.dart';
import 'package:movie/presentation/pages/movie/popular_movies_page.dart';
import 'package:movie/presentation/pages/movie/top_rated_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMoviesBloc>().add(NowPlayingMovies());
      context.read<PopularMoviesBloc>().add(PopularMovies());
      context.read<TopRatedMoviesBloc>().add(TopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Tv'),
              onTap: () {
                Navigator.pushNamed(context, tvRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, watchlistRoute);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchRoute, arguments: true);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing Movie',
                onTap: () =>
                    Navigator.pushNamed(context, NowPlayingMoviePage.routeName),
              ),
              BlocBuilder<NowPlayingMoviesBloc, StateRequest>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HasData) {
                  final result = state.result;
                  return MovieList(result);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMoviesBloc, StateRequest>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HasData) {
                  final result = state.result;
                  return MovieList(result);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMoviesBloc, StateRequest>(
                  builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HasData) {
                  final result = state.result;
                  return MovieList(result);
                } else {
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<MovieEntity> movies;

  const MovieList(this.movies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
