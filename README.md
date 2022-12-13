# Catch iOS SDK

![Catch](https://user-images.githubusercontent.com/74115740/207220638-ef31c835-9a06-49d3-a8e5-d4e49acaae10.png)

[![Language](https://img.shields.io/badge/language-swift-green)](https://catch.readme.io/)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen)](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)
[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-brightgreen)](https://guides.cocoapods.org/using/getting-started.html)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-lightgray)](https://github.com/getcatch/catch-ios-sdk/blob/main/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/ios)](https://catch.readme.io/)

The Catch iOS SDK allows you to integrate [Catch](https://www.getcatch.com) as a payment option in your native iOS apps.

Table of contents
=================

<!--ts-->
   * [Documentation](#documentation)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Example](#example)
   * [Licenses](#licenses)

<!--te-->

## Documentation

Read the [full developer documentation here](https://catch.readme.io/reference) to get started with Catch.

## Requirements

- Deployment target of iOS 12.0 or higher
- Swift 5.0.23 or higher

## Installation
### Swift Package Manager

In Xcode, navigate to **File** → **Add Packages**.

In the **Search or Enter Package URL** dialog, enter the repository URL:
```
https://https://github.com/getcatch/catch-ios-sdk
```
In **Dependency Rule**, select **Up to Next Major Version** and leave the default version options. Then choose **Catch** in the **Package Product** column.

### CocoaPods

Add the following to your Podfile.
```
pod 'Catch'
```

Followed by installing the SDK:

```
pod install
```
*If you have not previously set up Cocoapods, follow their instructions [here](https://guides.cocoapods.org/using/getting-started.html).*

### Carthage

Add the following to your Cartfile:
```
github "getcatch/catch-ios-sdk"
```

Then follow the full Carthage installation instructions [here](https://github.com/Carthage/Carthage).

### Manual

Alternatively, if you do not want to use the above installation methods, you may clone our [GitHub repository](https://github.com/getcatch/catch-ios-sdk) and drag the Catch folder into your XCode project.

## Example
A demo app is included in the project. To run it you will need to do the following:
- Clone our [GitHub repository](https://github.com/getcatch/catch-ios-sdk)
- Navigate to the `Example` directory
- Run `pod install`
- Open `Example.xcworkspace` in Xcode.

Xcode 13+ is required to run the demo app.

## Licenses

- [Catch iOS SDK License](LICENSE)
