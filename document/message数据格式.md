# message数据格式

> 消息数据有三种表现形式：
> 客户端model
> 前端数据库字段设计（如何存储）
> 发送，接收消息报文
> 三种形式的内容，完成的功能是一致的。

## 基本字段

### session_id

> 会话id
> P2P类型时:uid;  
> Team类型:teamId

### session_type

> 会话类型
> P2P（单聊）
> Team(群组)
> Room（聊天室）

### server_id

> message在服务器上的id

### msg_id

> 消息本地id，使用uuid生成

### msg_from_id

> 消息来源。创建消息的用户id

### msg_text

> 消息文本内容。

### msg_content

> 存储各消息类型的消息体。
> json格式

### msg_type

> 消息类型，枚举值

### msg_time

> 消息时间戳， 服务器修正。

### msg_status

> 信息状态

* sending，发送中
* sent,  发送成功
* error  发送失败
* uploading，（附件）上传中

-----

* downloading,    正在下载中
* playing,       正在播放
* played,  播放完成
* cancel,  播放被取消

-----

* mineRevoke,   消息被自己撤销
* otherRevoke,   消息被别人撤销

### msg_received_read_status

> 只针对接收到的消息

* unread
* read

### msg_receipt_status

> 消息回执，只针对发送的消息

* readed
* 已发送，还未读

### msg_io_type

> 是接受的消息还是发送的消息

* send
    > 发送的消息
* receive
    > 接收到的消息根据 msg_from_id判断是否是发送的。
    > 在多端登录，数据同步时使用
    > 使用msg_from_id就可以判断处出来。处于性能考录。

### serail

> 本地数据库自增

## 各消息类型（msg_content）

### 0：普通文本

> 对应字段： msg_text

### 1：图片

````{
    "md5":"67b6e95d9014b09142803239dd773b90",
    "h":620,
    "ext":"jpg",
    "size":246717,
    "w":828,
    "name":"图片发送于2019-08-24 20:42",
    "url":"babababa"
}
````

* url
    > 上传图片后，服务器返回的连接地址，

* md5
    > 图片大小小于10M时，整个求整个
    > 文件md5
    > 图片大于10M时， 前后各取5M, 对着10M求MD5
    > 此MD5值由于缓存的key。
    > 在发送图片时， 将图片保存到cache中。

* size
    > 大小

* h
    > 高度

* w
    > 宽度

* name
    > 图片名

* ext
    > 文件拓展名

### 2：音频

````{
    "size":13526,
    "ext":"aac",
    "dur":3761,
    "url":"kjhkhj",
    "md5":"0d8e201a0c81651491a5fbea3eaa9cce"
}
````

* url
    > 服务器路径

* md5
    >  指纹

* size
    >  大小

* ext
    > 拓展名

* dur
    > 时长

### 3：视频

````{
    "url":"https://nim.nosdn.127.net/MTAxODAwNQ==/bmltYV8zOTM4MTBfMTU2NjY1MDU0ODE0MF81MDIzODQxMi1hNjIzLTQ1NTEtODNjNC02YzU4NWVlZDUzOTM=",
    "md5":"45fbbadaa5755f5969f938d2c212889d",
    "ext":"mp4",
    "h":960,
    "size":5538661,
    "w":544,
    "name":"视频发送于2019-08-31 20:43",
    "dur":35200
}
````

* url
* md5
* size
* h
* w
* ext
* dur
* name

### 4 位置

> 经纬度信息

* lat
* lng

### 5：文件

* displayName
    >  文件名

* url
    >  服务器路径

* md5
    >  指纹

* size
    >  大小

* ext(文件拓展名)

### 6：机器人

* robotId
    > 当该消息为用户上行发送给机器人时，此字段为目标机器人 Id,
    > 当该消息为机器人回复的消息时, 此字段为本消息所属机器人Id
  
### 7：自定义消息

### 100：通知消息

* 0:NotificationTypeUnsupport
    >  由于系统升级，旧版本的 SDK 可能无法解析新版本数据,所有无法解析的新通知显示为未被支持

* 1:NotificationTypeTeam
  * 发起者id  (sourceID)
  * 操作类型（枚举类型）
    > 邀请成员 
    > 高级群接受邀请进群   
    > 移除成员
    > 离开群   
    > 更新群信息  
    > 解散群  
    > 高级群申请加入成功  
    > 高级群群主转移群主身份  
    > 添加管理员  
    > 移除管理员  
    > 群内禁言/解禁    
  * 被操作者ID列表（targetIDs）
  * 群通知下发的自定义扩展信息（notifyExt）
  * 额外信息（两种类型：群信息修改和禁言，根据。）
    * 群内修改的信息键值对（NIMUpdateTeamInfoAttachment）
      * NSDictionary<NSNumber *,NSString *>    *values
        > 群名 
        >群简介    
        >  群公告  
        > 群验证方式   
        > 客户端自定义拓展字段 
        > 服务器自定义拓展字段 
        > @discussion SDK 无法直接修改这个字段, 请调用服务器接口   
        > 头像 
        > 被邀请模式   
        > 邀请权限 
        > 更新群信息权限   
        > 更新群客户端自定义拓展字段权限   
        > 群全体禁言   
    * 禁言通知的额外信息（NIMMuteTeamMemberAttachment）
      * 是否被禁言 (BOOL    flag)

* 2:NotificationTypeNetCall
  * 网络通话类型
    * 视频
    * 语音
  * 操作类型
    * 对方拒接电话
    * 对方无人接听
    * 未接电话
    * 电话回单
  * call id
  * 时长
* 3:NotificationTypeChatroom
  * 聊天室通知事件类型
  * 操作者
  * 被操作者
  * 通知信息
  * 拓展信息

### 200：状态消息
