// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CatInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatInfo _$CatInfoFromJson(Map<String, dynamic> json) {
  return CatInfo(
      json['cat'] as String,
      json['count'] as String,
      json['fileName'] as String,
      json['type'] as String,
      json['topId'] as String,
  );
}

Map<String, dynamic> _$CatInfoToJson(CatInfo instance) => <String, dynamic>{
      'cat': instance.cat,
      'count': instance.count,
      'fileName': instance.fileName,
      'type': instance.type,
      'topId': instance.topId,
    };
