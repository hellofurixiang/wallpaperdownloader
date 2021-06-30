import 'package:json_annotation/json_annotation.dart';

part 'WatchAdEntity.g.dart';

@JsonSerializable()
class WatchAdEntity {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'watchDate')
  String watchDate;

  @JsonKey(name: 'watchInterstitialAd')
  int watchInterstitialAd;

  @JsonKey(name: 'watchRewardedAd')
  int watchRewardedAd;

  WatchAdEntity(
      this.id,this.watchDate, this.watchInterstitialAd, this.watchRewardedAd);

  factory WatchAdEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$WatchAdEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WatchAdEntityToJson(this);

}
