import 'package:wallpaper_api/model/wallpaper_model.dart';

abstract class HomeState {

}

class HomeInitialState extends HomeState{}

class HomeLoadingState extends HomeState{}

class HomeLoadedState extends HomeState{
  List<Photo> listPhotos;
  HomeLoadedState({required this.listPhotos});
}

class HomeErrorState extends HomeState{

  String errorMsg;
  HomeErrorState({required this.errorMsg});


}
