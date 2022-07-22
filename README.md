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
### CocoaPods
`SimpleHUD` is available on [CocoaPods](https://cocoapods.org/pods/SimpleHUD):

```ruby
pod 'SimpleHUD'
```

### Swift Package Manager
- File > Swift Packages > Add Package Dependency
- Add `https://github.com/knottx/SimpleHUD.git`
- Select "Up to Next Major" with "1.7.2"

## 📝 How
### Code Implementation
```swift
import SimpleHUD
```

```swift
var simpleHUD: SimpleHUD = SimpleHUD()
```

Show HUD
```swift
self.simpleHUD.show(at: self.view)
```

Dismiss HUD
```swift
self.simpleHUD.dismiss()
```

Dissmiss all stacked HUD
```swift
self.simpleHUD.dissmissAll()
```

### Change Simple HUD Type and Color 
```swift
self.simpleHUD.show(at: self.view, type: <SimpleHUDType>, color: <UIColor>)
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
### Simple Toast 
```swift
var simpleToast: SimpleToast = SimpleToast()
```

Show Toast
```swift
self.simpleToast.toast(at: self.view, message: <String?>, image: <UIImage?>)
```

Dismiss Toast
```swift
self.simpleToast.dismiss()
```

## 📋 Requirements

* iOS 10.0+
* Xcode 11+
* Swift 5.1+
