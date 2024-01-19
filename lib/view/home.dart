import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_gritstone/provider/providers.dart';

import '../provider/font_style_provider.dart';
import '../services/api_services.dart';
import '../widgets/app_drawer_widget.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String imageBaseurl = 'https://image.tmdb.org/t/p/w500';
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool highContrast = MediaQuery.of(context).highContrast;
    var trendingmovies = ref.watch(apiFutureProvider);

    return Semantics(
      explicitChildNodes: true,
      child: Scaffold(
        drawer: const AppDrawerWidget(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Movies',
            style: ref.watch(fontFamilyProvider)[ref.watch(fontIndexProvider)],
          ),
        ),
        body: trendingmovies.when(
          data: (data) => ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Trending Movies",
                  style: ref
                      .watch(fontFamilyProvider)[ref.watch(fontIndexProvider)]
                      .copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              CarouselSlider.builder(
                itemCount: 4,
                itemBuilder: (context, index, realIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Semantics(
                      label: data[index].title,
                      readOnly: true,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)),
                        child: FutureBuilder(
                          future:
                              ref.watch(apiprovider).downloadImage(data[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.file(
                                File(
                                  snapshot.data!,
                                ),
                                fit: BoxFit.cover,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 0.4,
                  height: 220,
                  // enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: search,
                  onSubmitted: (value) async {
                    ref.invalidate(searchResultProvider);

                    if (value.isNotEmpty) {
                      final res =
                          await ref.read(apiprovider).getSearch(search.text);
                      if (res != null) {
                        ref.read(searchResultProvider.notifier).state =
                            List.from(res.results);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (search.text.isNotEmpty) {
                          ref.invalidate(searchResultProvider);

                          final res = await ref
                              .read(apiprovider)
                              .getSearch(search.text);
                          if (res != null) {
                            ref.read(searchResultProvider.notifier).state =
                                List.from(res.results);
                          }
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              ref.watch(searchResultProvider) == null
                  ? Semantics(
                      label: "Search for Movie",
                      readOnly: true,
                      child: Center(
                        child: Text(
                          "Search for Movie",
                          style: ref.watch(
                              fontFamilyProvider)[ref.watch(fontIndexProvider)],
                        ),
                      ),
                    )
                  : ref.watch(searchResultProvider)!.isEmpty
                      ? Semantics(
                          label: "No Result found",
                          readOnly: true,
                          child: Center(
                            child: Text(
                              "No Result found",
                              style: ref.watch(fontFamilyProvider)[
                                  ref.watch(fontIndexProvider)],
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: ref.watch(searchResultProvider)!.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2 / 3,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => ref
                                      .watch(searchResultProvider)![index]
                                      .posterPath ==
                                  null
                              ? Semantics(
                                  label: ref
                                      .watch(searchResultProvider)![index]
                                      .originalTitle,
                                  readOnly: true,
                                  child: Container(
                                    color: Colors.grey[400],
                                  ),
                                )
                              : Semantics(
                                  label: ref
                                      .watch(searchResultProvider)![index]
                                      .originalTitle,
                                  readOnly: true,
                                  child: Image.network(
                                    imageBaseurl +
                                        ref
                                            .watch(searchResultProvider)![index]
                                            .posterPath!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
