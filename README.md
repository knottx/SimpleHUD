# SimpleHUD
SimpleHUD
<br>
<p align="center">
  <img width="200" src="https://github.com/knottx/SimpleHUD/blob/main/readmeResource/activityIndicator.png">
</p>

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


## 📋 Requirements

* iOS 10.0+
* Xcode 11+
* Swift 5.1+
