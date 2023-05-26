# ``Catch``

The Catch iOS SDK allows you to integrate Catch as a payment option in your native iOS apps.

## Overview

> ##### 👍 Interested In Integrating With Catch?
> 
> To make use of the tools described in this documentation, you will need a merchant account with Catch. 
Please reach out to our merchant partnerships team ([sales@getcatch.com](mailto:sales@getcatch.com)) for inquiries.

The Catch iOS SDK provides components for developing applications that integrate with [Catch](https://www.getcatch.com) 
on merchant native apps. It's designed to be used in tandem with Catch's [Transaction APIs](https://catch.readme.io/reference/transactions-integration-overview) to implement the frontend portion of 
the overall integration.

The Catch iOS SDK provides the following main categories of functionality:

* **UI widgets**: various prefabricated views which applications can display and control in the user interface.
* **Checkout flow control**: an interface for applications to open Catch checkouts.

## Demo App

The [Example app](https://github.com/getcatch/catch-ios-sdk/tree/main/Example) provides a showcase of Catch's UI widgets 
and other features in isolation. You may clone the repository and run the Example app using Xcode. This may be used as a 
reference companion alongside this documentation.

## Compatibility

The Catch iOS SDK is compatible with the following:
* iOS 12+
* Xcode 13+
* Objective-C
* Swift (UIKit and SwiftUI)

## Installation

#### Swift Package Manager

In Xcode, navigate to **File** → **Add Packages**.

In the **Search or Enter Package URL** dialog, enter the repository URL:
```
https://https://github.com/getcatch/catch-ios-sdk
```
In **Dependency Rule**, select **Up to Next Major Version** and leave the default version options. Then choose **Catch** 
in the **Package Product** column.

#### CocoaPods

Add the following to your Podfile.
```
pod 'Catch'
```

Followed by installing the SDK:

```
pod install
```
*If you have not previously set up Cocoapods, follow their instructions 
[here](https://guides.cocoapods.org/using/getting-started.html).*

#### Carthage

Add the following to your Cartfile:
```
github "getcatch/catch-ios-sdk"
```

Then follow the full Carthage installation instructions [here](https://github.com/Carthage/Carthage).

#### Manual

Alternatively, if you do not want to use the above installation methods, you may clone our [GitHub repository](https://github.com/getcatch/catch-ios-sdk) and drag the Catch folder into your XCode project.

## Initialization

The Catch SDK is initialized as follows:
```
Catch.initialize(publicKey: merchantPublicKey, options: configurationOptions) { result in
    if case let .failure(error) = result {
        // "Initialization failed"
    }
}
```
This should only be called once in the application's lifecycle.

The initialize function accepts three parameters: `publicKey`, `options` and a completion handler.
* `publicKey` is required and should be a string representing the merchant's public API key. 
If the provided publicKey is invalid, initialization will not succeed.
* `options` is a ``CatchOptions`` object which specifies optional configuration settings to control global 
behavior of the SDK. If the options parameter is omitted, the Catch SDK will fallback to default values.
* Applications may optionally handle initialization success or failure using the completion handler.

#### Initialization options

The options object passed as the second argument to `Catch.initalize` may provide any of the following values. 
If an option is not defined, or options is omitted entirely, the SDK will fallback to a default value for the option.
* **theme**: Specifies the default theme which determines the look and feel of widgets,
from a set of available predesigned options. Defaults to the ``Theme/lightColor`` theme.
* **environment**: The live environment should be used in production applications while
the  sandbox environment should be used for development and testing. Defaults to ``Environment/sandbox``.
* **useCatchFonts**: Specifies if custom Catch fonts should be loaded into your application.
Defaults to `true`. If you intend to use your own custom fonts for all widgets, this should be set to `false`.
* **globalStyleOverrides**: Optional ``CatchStyleConfig`` object used to set global style overrides for the UI widgets.

## UI Widgets

#### Overview
The Catch SDK offers a set of preconfigured UI Widgets which can be easily dropped into your applications.
For more information on each of the available UI widgets and their use cases, view the Widgets topic below.

#### Styling Widgets

##### Theme
The first method of styling widgets is by using a ``Theme``. There are four default Catch themes which configure the 
look and feel of widgets. These preconfigured themes can be set on a global level or on an individual widget.

These preconfigured themes can be set on a global level to impact the appearance of all UI widgets:

```
Catch.setTheme(.darkColor)
```

Otherwise, they may be set on an individual widget if you do not wish for all widgets to use the same theme:

```
let callout = Callout(price: 1000, theme: .lightMono)
```

Any widget-level theme will override any theming set on the global level.

##### Style Overrides
For even more customization power, many style elements can be overridden using the Catch style overrides. 

Overrides can be set on a global level when initializing the SDK. 
For example, to update the global text styling, 
set the desired customizations in ``CatchStyleConfig`` within the ``CatchOptions`` that are passed into the
`initialize` function:

```
let customTextStyle = TextStyle(font: customFont,
                                textColor: .blue,
                                textTransform: .uppercase,
                                lineSpacing: 12,
                                letterSpacing: 2)
let overrides = CatchStyleConfig(textStyle: customTextStyle)
let options = CatchOptions(useCatchFonts: false, 
                           globalStyleOverrides: overrides)
```
Overrides can also be set on the widget-level at the time of widget initialization. For example, the following code 
applies the text customizations to an individual callout widget:

```
let customTextStyle = TextStyle(font: customFont,
                                textColor: .red)
let calloutStyleOverrides = InfoWidgetStyle(textStyle: customTextStyle)
let callout = Callout(price: 1000, styleOverrides: calloutStyleOverrides)
```
For more information on the available style overrides, see the Style Overrides topic below.

## Checkout Control Flow

##### Overview

To open a Catch checkout flow, applications should invoke the following function:
```
Catch.openCheckout(checkoutId: checkoutID, options: checkoutOptions)
```

This function accepts two parameters: `checkoutId` and `options`. 
* **checkoutId** is required and should be a string representing the ID of the Checkout being opened. 
* **options** is a ``CheckoutOptions`` object which specifies configuration options that customize certain aspects of 
the checkout flow.

> 🚧 Ahead of using the `openCheckout()` function, applications are responsible for creating a Checkout object using 
Catch's Transaction APIs. A successful call to Catch's POST Checkout endpoint will return a checkout ID in the body of 
its response, which should subsequently be supplied as the first argument to `openCheckout()`.

`openCheckout()` does not return any value or expect to throw any exceptions. 
`checkoutId`s passed to `openCheckout()` are not validated ahead of opening the checkout flow. 
If a given `checkoutId` turns out not to be valid, Catch's checkout UI will display error messaging to the consumer 
indicating that their checkout could not be loaded. If the consumer encounters an error during the checkout flow 
(e.g. they're unable to link a bank account successfully, etc), Catch's checkout UI will be responsible for handling 
such errors and displaying relevant information to the consumer. The call to `openCheckout()`, in other words, is a full 
handoff from the merchant application to Catch's checkout application.

##### Handling Terminations
> ##### 🚧 Enforce defined progression from Checkout to Purchase
> Your application should not attempt to create a new Purchase until the consumer has confirmed their Checkout and 
triggered a successful termination of the Catch checkout flow.

There are two circumstances in which a Catch checkout flow is terminated and control is handed back to the merchant 
application: 
(1) a consumer successfully completes the checkout flow, or (2) a consumer explicitly cancels their checkout flow. 

After (1), the SDK will close the checkout flow and call the `onConfirm` callback that was passed into 
``CheckoutOptions``. The application is then responsible for 
creating a Purchase with Catch using the Transaction APIs 
[POST Purchase endpoint](https://catch.readme.io/reference/post-purchase) and subsequently displaying a confirmation 
page.

After (2), the SDK will close the checkout flow and call the `onCancel` callback that was passed into 
``CheckoutOptions``. The application may then display content as it sees fit.

## Topics

### Widgets

- ``Callout``
- ``ExpressCheckoutCallout``
- ``PaymentMethod``
- ``PurchaseConfirmation``
- ``CampaignLink``
- ``CatchLogo``

### Global Configurations

- ``CatchOptions``
- ``Theme``
- ``Environment``

### Style Overrides

- ``CatchStyleConfig``
- ``ActionWidgetStyle``
- ``InfoWidgetStyle``
- ``TextStyle``
- ``BenefitTextStyle``
- ``TextTransform``
- ``ActionButtonStyle``
- ``BorderStyle``
- ``ShadowStyle``

### Checkout

- ``CheckoutOptions``
- ``CheckoutPrefill``

### Supporting Models

- ``PaymentMethodVariant``
- ``Address``
- ``Amounts``
- ``Price``
- ``Item``
- ``Platform``
- ``VirtualCardDetails``
- ``CreateVirtualCardCheckoutBody``
