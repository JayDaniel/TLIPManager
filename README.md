## IP动态管理

![Pod Version](https://img.shields.io/cocoapods/v/TLIPManager.svg?style=flat)
![Pod Platform](https://img.shields.io/cocoapods/p/TLIPManager.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/TLIPManager.svg?style=flat)

由于在开发环境中，时长会更换不同的服务器部署，导致APP需要更换新的服务器IP。以往采用重新更改IP打包方式，不仅耽误测试人员时间，同时影响开发者开发思路，给整个过程带来不便利，有了这个库妈妈再也不担心此问题了。

![Screenshots_Row1](Screen%20Shot%202017-03-08%20at%2009.42.00.png)
![Screenshots_Row1](Screen%20Shot%202017-03-08%20at%2009.42.11.png)

---

#### TLIPManager导入
### 从 CocoaPods

[CocoaPods](http://cocoapods.org) 是Objective-C的依赖项管理器，它的自动化简化了`TLIPManager`在项目中使用第三方库的过程。首先，将以下行添加到您的 [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'TLIPManager'
```
接下来, 安装 `TLIPManager` 至你的项目:

```ruby
pod install
```

2.若pod search操作还是搜索失败：
  - 终端输入：pod search TLIPManager<br>
  - 输出：Unable to find a pod with name, author, summary, or descriptionmatching 'TLIPManager' 这时就需要继续下面的步骤了。<br>
  - 删除~/Library/Caches/CocoaPods目录下的search_index.json文件<br>
  - pod setup成功后，依然不能pod search，是因为之前你执行pod search生成了search_index.json，此时需要删掉。<br>
  - 终端输入：rm ~/Library/Caches/CocoaPods/search_index.json<br>
  - 删除成功后，再执行pod search。

3.导入主头文件`#import <TLIPManager/IPManager.h>`

##### 手动导入方式
  - 将`TLIPManager`文件夹中的所有文件拽入项目中<br>
  - 导入主头文件`#import "IPManager.h"`

#### 使用TLIPManager
  - 在`AppDelegate.m`中初始化该框架。

``` Objective-c
    [[IPManager standardManager] managerRegisterFirstResponder:self];
```

  - 在`LoginViewController`或者 `MainViewController`中实现摇一摇协议（这里的ViewController是你工程的基类，或者你想要响应这个框架的类，总之，想在哪儿响应就在哪儿实现协议）。
  - 导入头文件`#import <TLIPManager/IPManager.h>`

``` Objective-c
// 结束摇动代理方法
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
  //振动效果
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  //如果有摇动动作，就做相应操作
  if (event.subtype == UIEventSubtypeMotionShake) {
    // 调用回调，传入当前类，框架会自动跳转
      [IPManager actionManagerPresentVC:self completionBlock:^(IPModel *resultDic) {
          NSLog(@"%@",resultDic.formatIpAddress);
      }];
   }
}
```
