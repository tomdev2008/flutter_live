import 'package:flutter/cupertino.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';

class DataEntity {
  /// 消息实体
  final MessageEntity data;

  /// 进度
  final int progress;

  DataEntity({
    this.data,
    this.progress,
  });
}

/// 文本消息节点
class TextMessageNode extends MessageNode {
  /// 文本内容
  String content;

  TextMessageNode({
    @required this.content,
  }) : super(MessageNodeType.Text);

  TextMessageNode.fromJson(Map<String, dynamic> json)
      : super(MessageNodeType.Text) {
    content = json['content'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["content"] = this.content;
    return data;
  }
}
