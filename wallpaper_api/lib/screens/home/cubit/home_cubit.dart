import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_api/data/repository/wallpaper_repo.dart';
import 'package:wallpaper_api/model/wallpaper_model.dart';
import 'package:wallpaper_api/screens/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  WallpaperRepository wallpaperRepository;
  HomeCubit({required this.wallpaperRepository}) : super(HomeInitialState());

  void getTrendingWallpaper() async {
    emit(HomeLoadingState());
    try{
      var data = await wallpaperRepository.getTrendingWallpaper();
      print('data: $data');
      var wallpaperModel = WallpaperModel.fromJson(data);
      emit(HomeLoadedState(listPhotos: wallpaperModel.photos!));
    } catch(e){
        emit(HomeErrorState(errorMsg: "${e.toString()}"));
    }
  }
}