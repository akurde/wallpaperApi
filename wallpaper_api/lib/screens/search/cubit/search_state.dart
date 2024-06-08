import 'package:wallpaper_api/model/wallpaper_model.dart';

abstract class SearchState{

}

class SearchInitialState extends SearchState{}

class SearchLoadingState extends SearchState{}

class SearchLoadedState extends SearchState{
  List<Photo> listPhotos;

  int totalWallpapers;
  SearchLoadedState({required this.listPhotos, required this.totalWallpapers});

}

class SearchErrorState extends SearchState{

  String errorMsg;
  SearchErrorState({required this.errorMsg});

}
