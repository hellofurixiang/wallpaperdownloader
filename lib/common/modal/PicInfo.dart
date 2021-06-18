import 'package:json_annotation/json_annotation.dart';

part 'PicInfo.g.dart';

@JsonSerializable()
class PicInfo {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'remark')
  String remark;
  @JsonKey(name: 'cat')
  String cat;
  @JsonKey(name: 'size')
  double size;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'createTime')
  String createTime;
  @JsonKey(name: 'downloadCount')
  int downloadCount;
  @JsonKey(name: 'advertising')
  bool advertising;
  @JsonKey(name: 'keyword')
  String keyword;
  @JsonKey(name: 'readCount')
  int readCount;
  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'resolution')
  String resolution;

  PicInfo.empty();

  PicInfo(
    this.id,
    this.title,
    this.remark,
    this.cat,
    this.size,
    this.type,
    this.createTime,
    this.downloadCount,
    this.advertising,
    this.keyword,
    this.readCount,
    this.fileName,
    this.resolution,
  );

  factory PicInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$PicInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PicInfoToJson(this);
}
