import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_api/app_widget/wallpaper_bg_widget.dart';
import 'package:wallpaper_api/constants/app_constant.dart';
import 'package:wallpaper_api/data/remote/api_helper.dart';
import 'package:wallpaper_api/data/repository/wallpaper_repo.dart';
import 'package:wallpaper_api/screens/home/cubit/home_cubit.dart';
import 'package:wallpaper_api/screens/home/cubit/home_state.dart';
import 'package:wallpaper_api/screens/search/cubit/search_cubit.dart';
import 'package:wallpaper_api/screens/search/searched_wallpaper_page.dart';
import 'package:wallpaper_api/utils/utils_helper.dart';

class HomePage extends StatefulWidget{

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  var searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeCubit>(context).getTrendingWallpaper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLightColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // 1
          Container(height: 20,),
          // 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: searchController,
              style: mTextStyle12(),
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: (){
                    if(searchController.text.isNotEmpty){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (c) => BlocProvider(create: (c) => SearchCubit(wallpaperRepository: WallpaperRepository(apiHelper: ApiHelper())),
                          child: SearchedWallpaperPage(query: searchController.text,),
                        ))
                      );
                    }
                  },
                  child: Icon(Icons.search, color: Colors.grey.shade400,)
                ),
                hintText: "Find Wallpaper..",
                hintStyle: mTextStyle14(mColor: Colors.grey.shade400),
                filled: true,
                fillColor: AppColors.secondaryLightColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
              ),
            ),
          ),

          // 3
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 10),
            child: Text('Best of the month', style: mTextStyle16(mColor: Colors.black),),
          ),
          SizedBox(height: 5,),
          SizedBox(
            height: 200,
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (_, state){
                if(state is HomeLoadingState){
                    return Center(child: CircularProgressIndicator(),);
                }
                else if(state is HomeErrorState){
                    return Center(child: Text('${state.errorMsg}'),);
                } else if(state is HomeLoadedState) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.listPhotos.length,
                      itemBuilder: (_,index){ 
                          var eachPhotos = state.listPhotos[index];

                          return Padding(
                              padding: EdgeInsets.only(left: 11, right: index == state.listPhotos.length - 1 ? 11 : 0),
                              child: WallpaperBgWidget(imgUrl: eachPhotos.src!.potrait!),
                          );
                          
                    });
                }
                return Container();
              })
          ),

          // 4
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 30),
            child: Text('The color tone', style: mTextStyle16(mColor: Colors.black),),
          ),
          SizedBox(height: 5,),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstant.mColors.length,
              itemBuilder: (_,index){
                return Padding(
                  padding: EdgeInsets.only(left: 11, right: index == AppConstant.mColors.length - 1 ? 11 : 0),
                  child: InkWell(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                        builder: (c) => BlocProvider(create: (c) => SearchCubit(wallpaperRepository: WallpaperRepository(apiHelper: ApiHelper())),
                          child: SearchedWallpaperPage(query: searchController.text.isNotEmpty ? searchController.text : "Nature", color: AppConstant.mColors[index]['code']),
                        ))
                      );
                    },
                    child: getColorToneWidget(AppConstant.mColors[index]['color'])
                  ),
                );
              }
            ),
          ),

          // 5
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 30),
            child: Text('Categories', style: mTextStyle16(mColor: Colors.black),),
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                childAspectRatio: 9/5
              ), 
              itemCount: AppConstant.mCategory.length,
              itemBuilder: (_,index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, 
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SearchCubit(wallpaperRepository: WallpaperRepository(apiHelper: ApiHelper())),
                              child: SearchedWallpaperPage(query: AppConstant.mCategory[index]['title']),
                            )));
                  },
                  child: getCategoryWidget(
                        AppConstant.mCategory[index]['image'], 
                        AppConstant.mCategory[index]['title']
                      ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
  
  Widget getColorToneWidget(Color mColor){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: mColor,
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }

  Widget getCategoryWidget(String imgUrl, String title){
    return Container(
      width: 200,
      height: 100,
      child: Center(child: Text(title, 
        style: mTextStyle14(mColor: Colors.white),),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.fill
        )
      ),
    );
  }
}