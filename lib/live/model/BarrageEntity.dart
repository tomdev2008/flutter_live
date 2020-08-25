class BarrageEntity {
  ///id
  int id;

  /// 发送人
  String userName;

  /// 内容
  String message;

  BarrageEntity({
    this.id,
    this.userName,
    this.message,
  });

  BarrageEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['message'] = this.message;
    return data;
  }

}