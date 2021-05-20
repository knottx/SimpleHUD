# SimpleHUD
SimpleHUD
<br>
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/activityIndicator.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/circleStroke.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/circleRotateChase.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/circleSpinFade.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/threeDots.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/fiveBars.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/progress.gif" width="150"> 
<img src="https://github.com/knottx/SimpleHUD/blob/main/ReadmeResource/icon.gif" width="150"> 

<br>

## 📲 Installation

`SimpleHUD` is available on [CocoaPods](https://cocoapods.org/pods/SimpleHUD):

```ruby
pod 'SimpleHUD'
```

## 📝 How
### Code Implementation
```swift
import SimpleHUD
```

```swift
var loading:SimpleHUD = SimpleHUD()
```

Show HUD
```swift
self.loading.show(at: self.view)
```

Dismiss HUD
```swift
self.loading.dismiss()
```

Dissmiss all stacked HUD
```swift
self.loading.dissmissAll()
```

### Change Simple HUD Type and Color 
```swift
self.loading.show(at: self.view, type: <SimpleHUDType>, color: <UIColor>)
```
SimpleHUDType
```swift
.activityIndicator
.circleStroke
.circleRotateChase
.circleSpinFade
.threeDots
.fiveBars
.progress(value: CGFloat)
.icon(_ image: UIImage?)
```

## 📋 Requirements

* iOS 10.0+
* Xcode 11+
* Swift 5.1+
