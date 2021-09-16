# WCAG-Colors

[![Version](https://img.shields.io/cocoapods/v/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![License](https://img.shields.io/cocoapods/l/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![Platform](https://img.shields.io/cocoapods/p/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![Twitter](https://img.shields.io/badge/twitter-%40chr__wendt-58a1f2.svg)](https://twitter.com/chr_wendt)

The *Web Content Accessibility Guidelines* (WCAG) define minimum contrast ratios for a text and its background. The WCAG-Colors framework extends `UIColor` and `NSColor` with functionality to use WCAG conformant colors within your apps to help people with visual disabilities to perceive content. 

It provides APIs for calculating:

* high contrast text color for a given background color
* high contrast background color for a given text color
* high contrast captions colot for a given background image
* WCAG conformance levels
* contrast ratios


Internally, the provided colors will be mapped to an equivalent of the sRGB color space. All functions will return `nil` and log warnings] with further info in case any input color couldn't be converted. Also note that semi-transparent text colors will be blended with its background color. However, the alpha value of semi-transparent background colors will be ignored since the underlying color can't be determined.**

## Documentation

WCAG-Colors offers a whole lot of features along with a bunch of configurations. To find more about how to use them inside the [documentation](Documentation/Reference/README.md) section.

## Installation

There are currently four different ways to integrate WCAG-Colors into your apps.

### CocoaPods

```ruby
use_frameworks!

target 'MyApp' do
  pod 'WCAG-Colors'
end
```

### Swift Package Manager

```ruby
dependencies: [
    .package(url: "https://github.com/chrs1885/WCAG-Colors.git", from: "1.0.0")
]
```

### Manually

Simply drop `WCAG-Colors.xcodeproj` into your project. Also make sure to add
`WCAG-Colors.framework` to your app’s embedded frameworks found in the General tab of your main project.

## Usage

<a id="colors"></a> 

#### Text colors
Get a high contrast text color for a given background color as follows:

```swift
let textColor = UIColor.getTextColor(onBackgroundColor: UIColor.red)!
```

This will return the text color with the highest possible contrast (black/white). Alternatively, you can define a list of possible text colors as well as a required conformance level. Since the WCAG requirements for contrast differ in text size and weight, you also need to provide the font used for the text. The following will return the first text color that satisfies the required conformance level (*AA* by default).

```swift
let textColor = UIColor.getTextColor(
    fromColors: [UIColor.red, UIColor.yellow],
    withFont: myLabel.font,
    onBackgroundColor: view.backgroundColor,
    conformanceLevel: .AA
)!
```

#### Background colors

This will also work the other way round. If you are looking for a high contrast background color:

```swift
let backgroundColor = UIColor.getBackgroundColor(forTextColor: UIColor.red)!

// or

let backgroundColor = UIColor.getBackgroundColor(
    fromColors: [UIColor.red, UIColor.yellow],
    forTextColor: myLabel.textColor,
    withFont: myLabel.font,
    conformanceLevel: .AA
)!
```

<a id="captions"></a> 
#### Image captions (iOS/tvOS/macOS)

Get a high contrast text color for any given background image as follows:

```swift
let textColor = UIColor.getTextColor(onBackgroundImage: myImage imageArea: .full)!
```

This will return the text color with the highest possible contrast (black/white) for a specific image area. 

Alternatively, you can define a list of possible text colors as well as a required conformance level. Since the WCAG requirements for contrast differ in text size and weight, you also need to provide the font used for the text. The following will return the first text color that satisfies the required conformance level (*AA* by default).

```swift
let textColor = UIColor.getTextColor(
    fromColors: [UIColor.red, UIColor.yellow],
    withFont: myLabel.font,
    onBackgroundImage: view.backgroundColor,
    imageArea: topLeft,
    conformanceLevel: .AA
)!
```

You can find an overview of all image areas available in the [documentation](Documentation/Reference/enums/ImageArea.md).

#### Calculating contrast ratios & WCAG conformance levels

The contrast ratio of two opaque colors can be calculated as well:

```swift
let contrastRatio: CGFloat = UIColor.getContrastRatio(forTextColor: UIColor.red, onBackgroundColor: UIColor.yellow)!
```

Once the contrast ratio has been determined, you can check the resulting conformance level specified by WCAG as follows:

```swift
let passedConformanceLevel = ConformanceLevel(contrastRatio: contrastRatio, fontSize: myLabel.font.pointSize, isBoldFont: true)
```

Here's an overview of available conformance levels:

| Level   | Contrast ratio                 | Font size               |
| --------|:-------------------------------|:------------------------|
| .A      | *Not specified for text color* | -                       |
| .AA     | 3.0                            | 18.0 (or 14.0 and bold) |
|         | 4.5                            | 14.0                    |
| .AAA    | 4.5                            | 18.0 (or 14.0 and bold) |
| .AAA    | 7.0                            | 14.0                    |
| .failed | *.AA/.AAA not satisfied*       | -                       |

## Author

chrs1885, chrs1885@gmail.com

## Contributions

We'd love to see you contributing to this project by proposing or adding features, reporting bugs, or spreading the word. Please have a quick look at our [contribution guidelines](./.github/CONTRIBUTING.md).

## License

WCAG-Colors is available under the MIT license. See the LICENSE file for more info.
