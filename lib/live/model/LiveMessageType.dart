
///直播间只定义消息类型
class RoomCustomMsgType {
  static const String CMD_ADD_CART = 'CMD_ADD_CART'; // CMD_ADD_CART表示观众加入购物车弹幕消息
  static const String CMD_BUY_GOODS = 'CMD_BUY_GOODS'; // CMD_BUY_GOODS表示观众购买商品弹幕消息
  static const String CMD_GO_BUY_GOODS = 'CMD_GO_BUY_GOODS'; // CMD_GO_BUY_GOODS表示正在去购买
  static const String CMD_LIKE = 'CMD_LIKE'; // CMD_LIKE表示观众点赞消息
  static const String CMD_ADD_GOODS = 'CMD_ADD_GOODS'; // CMD_ADD_GOODS表示主播添加商品到购物袋消息
  static const String CMD_RECOMMEND_GOODS = 'CMD_RECOMMEND_GOODS'; // CMD_RECOMMEND_GOODS表示主播推荐该商品
}