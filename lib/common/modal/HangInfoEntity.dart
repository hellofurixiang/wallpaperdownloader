import 'package:json_annotation/json_annotation.dart';

part 'HangInfoEntity.g.dart';

@JsonSerializable()
class HangInfoEntity {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'imgId')
  String imgId;

  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'watchAds')
  int watchAds;

  @JsonKey(name: 'favorite')
  int favorite;

  HangInfoEntity.nativeAd(this.imgId);

  HangInfoEntity(
      this.id, this.imgId, this.fileName, this.watchAds, this.favorite);

  factory HangInfoEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$HangInfoEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HangInfoEntityToJson(this);

}
