import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/movies/domain/entities/movie_entity.dart';

class MovieCastTile extends StatelessWidget {
  const MovieCastTile({super.key, required this.member});

  final CastEntity member;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 50.w,
      height: 50.w,
      color: Colors.black26,
      child: const Icon(Icons.person, color: Colors.white38),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child:
                member.imageUrl == null
                    ? placeholder
                    : CachedNetworkImage(
                      imageUrl: member.imageUrl!,
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => placeholder,
                    ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name : ${member.name}',
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Character : ${member.characterName}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
