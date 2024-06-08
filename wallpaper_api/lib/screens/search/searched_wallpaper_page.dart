import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_api/app_widget/wallpaper_bg_widget.dart';
import 'package:wallpaper_api/screens/search/cubit/search_cubit.dart';
import 'package:wallpaper_api/screens/search/cubit/search_state.dart';
import 'package:wallpaper_api/utils/utils_helper.dart';

class SearchedWallpaperPage extends StatefulWidget{
  String query;
  String color;
  SearchedWallpaperPage({required this.query, this.color = ""});

  @override
  State<SearchedWallpaperPage> createState() => _SearchedWallpaperPageState();
}

class _SearchedWallpaperPageState extends State<SearchedWallpaperPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SearchCubit>(context).getSearchWallpaper(query: widget.query, color: widget.color);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (_, state){
          if(state is SearchLoadingState){
              return Center(child: CircularProgressIndicator(),);
          } else if(state is SearchErrorState){
              return Center(child: Text('${state.errorMsg}'),);
          } else if(state is SearchLoadedState){
              return Padding(
                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(widget.query, style: mTextStyle25(mFontWeight: FontWeight.w900),),
                    Text('${state.totalWallpapers} Wallpaper available', style: mTextStyle14(),),
                    Expanded(child: Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 11,
                            crossAxisSpacing: 11,
                            childAspectRatio: 3/4,
                        ), 
                        itemCount: state.listPhotos.length,
                        itemBuilder: (_,index){
                          var eachPhotos = state.listPhotos[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: index == state.listPhotos.length - 1 ? 11 : 0),
                            child: WallpaperBgWidget(imgUrl: eachPhotos.src!.potrait!),
                          );
                        }
                      ),
                    ))
                  ],
                ),
              );
          }
          return Container();
        },
      ),
    );
  }
}