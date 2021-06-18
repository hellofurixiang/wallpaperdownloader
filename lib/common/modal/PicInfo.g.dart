// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PicInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicInfo _$PicInfoFromJson(Map<String, dynamic> json) {
  return PicInfo(
    json['id'] as String,
    json['title'] as String,
    json['remark'] as String,
    json['cat'] as String,
    (json['size'] as num)?.toDouble(),
    json['type'] as String,
    json['createTime'] as String,
    json['downloadCount'] as int,
    json['advertising'] as bool,
    json['keyword'] as String,
    json['readCount'] as int,
    json['fileName'] as String,
    json['resolution'] as String,
  );
}

Map<String, dynamic> _$PicInfoToJson(PicInfo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'remark': instance.remark,
      'cat': instance.cat,
      'size': instance.size,
      'type': instance.type,
      'createTime': instance.createTime,
      'downloadCount': instance.downloadCount,
      'advertising': instance.advertising,
      'keyword': instance.keyword,
      'readCount': instance.readCount,
      'fileName': instance.fileName,
      'resolution': instance.resolution,
    };
