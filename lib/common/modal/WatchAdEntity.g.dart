// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WatchAdEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchAdEntity _$WatchAdEntityFromJson(Map<String, dynamic> json) {
  return WatchAdEntity(
    json['id'] as String,
    json['watchDate'] as String,
    json['watchInterstitialAd'] as int,
    json['watchRewardedAd'] as int,
  );
}

Map<String, dynamic> _$WatchAdEntityToJson(WatchAdEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'watchDate': instance.watchDate,
      'watchInterstitialAd': instance.watchInterstitialAd,
      'watchRewardedAd': instance.watchRewardedAd,
    };
