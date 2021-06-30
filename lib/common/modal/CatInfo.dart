import 'package:json_annotation/json_annotation.dart';

part 'CatInfo.g.dart';

@JsonSerializable()
class CatInfo {
  @JsonKey(name: 'cat')
  String cat;
  @JsonKey(name: 'count')
  String count;
  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'topId')
  String topId;

  CatInfo.empty();

  CatInfo.nativeAd(this.topId);

  CatInfo(
    this.cat,
    this.count,
    this.fileName,
    this.type,
    this.topId,
  );

  factory CatInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$CatInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CatInfoToJson(this);


}
