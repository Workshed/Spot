# Spot

[![Version](https://img.shields.io/cocoapods/v/Spot.svg?style=flat)](http://cocoapods.org/pods/Spot)
[![License](https://img.shields.io/cocoapods/l/Spot.svg?style=flat)](http://cocoapods.org/pods/Spot)
[![Platform](https://img.shields.io/cocoapods/p/Spot.svg?style=flat)](http://cocoapods.org/pods/Spot)

![alt text](https://github.com/Workshed/Spot/blob/master/example.gif "Example usage")

## What's it do

When you spot something in your app that needs reporting just shake your phone/device. A screenshot of the current screen will popup, draw on it to highlight areas and then send it on in an email.  

## Getting started

Once you've installed the pod go to your application delegate and add the following...

Swift:
```
import Spot
```

Then in application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool

```
Spot.start()
```

Objective C:
```
@import Spot;
```

Then in (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions

```
[Spot start];
```


## Example

To run the example project, clone the repo, and open the project file in the "Example" folder

## Requirements

## Installation

Spot is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Spot"
```

## Author

Daniel Leivers, dan@sofaracing.com

## License

Spot is available under the MIT license. See the LICENSE file for more info.
