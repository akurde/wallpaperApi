import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_api/data/repository/wallpaper_repo.dart';
import 'package:wallpaper_api/model/wallpaper_model.dart';
import 'package:wallpaper_api/screens/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState>{
  WallpaperRepository wallpaperRepository;
  SearchCubit({required this.wallpaperRepository}) : super(SearchInitialState());

  void getSearchWallpaper({required String query, String color = ""}) async{
    emit(SearchLoadingState());
    try{
      var mData=  await wallpaperRepository.getSearchWallpaper(query, mColor: color);
      WallpaperModel wallpaperModel = WallpaperModel.fromJson(mData);
      emit(SearchLoadedState(listPhotos: wallpaperModel.photos!, totalWallpapers: wallpaperModel.totalResults!, ));
    } catch(e){
        emit(SearchErrorState(errorMsg: e.toString()));
    }

  }
}