// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HangInfoEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HangInfoEntity _$HangInfoEntityFromJson(Map<String, dynamic> json) {
  return HangInfoEntity(
    json['id'] as String,
    json['imgId'] as String,
    json['fileName'] as String,
    json['watchAds'] as int,
    json['favorite'] as int,
  );
}

Map<String, dynamic> _$HangInfoEntityToJson(HangInfoEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imgId': instance.imgId,
      'fileName': instance.fileName,
      'watchAds': instance.watchAds,
      'favorite': instance.favorite,
    };
