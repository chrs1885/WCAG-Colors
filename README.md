![logo](https://user-images.githubusercontent.com/1390908/133853563-3daef365-e890-41d2-ba6e-68cc9f17cd90.png)

[![Version](https://img.shields.io/cocoapods/v/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![License](https://img.shields.io/cocoapods/l/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![Platform](https://img.shields.io/cocoapods/p/WCAG-Colors.svg?style=flat)](https://cocoapods.org/pods/WCAG-Colors)
[![Twitter](https://img.shields.io/badge/twitter-%40chr__wendt-58a1f2.svg)](https://twitter.com/chr_wendt)

## Version 2.0.0 🥳

### Features
* Supports SwiftUI Color (iOS 17 & macOS 14)
* Supports contrast calculation for UI components

### Breaking Changes
* Updated function names and parameter labels
* FontProps got replaced with `ElementType`

# WCAG-Colors for Swift

The *Web Content Accessibility Guidelines* (WCAG) define minimum contrast ratios for a foreground color and its background. The WCAG-Colors framework extends `Color`, `UIColor`, and `NSColor` with functionality to use WCAG conformant colors within your apps to help people with visual disabilities to perceive content. 

It provides APIs for calculating:

* high contrast foreground color for a given background color
* high contrast background color for a given foreground color
* high contrast captions color for a given background image
* WCAG conformance levels
* contrast ratios


Internally, the provided colors will be mapped to an equivalent of the sRGB color space. All functions will return `nil` and log warnings] with further info in case any input color couldn't be converted. Also note that semi-transparent text colors will be blended with its background color. However, the alpha value of semi-transparent background colors will be ignored since the underlying color can't be determined.**

## Documentation

WCAG-Colors offers a whole lot of features along with a bunch of configurations. To find more about how to use them inside the [documentation](Documentation/) section.

## Installation

There are currently three different ways to integrate WCAG-Colors into your apps.

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
    .package(url: "https://github.com/chrs1885/WCAG-Colors.git", from: "2.0.0")
]
```

### Manually

Simply drop the extension files into your project.

## Usage

<a id="colors"></a> 

#### Foreground colors
Get a high contrast foreground color for a given background color as follows:

```swift
let foregroundColor = Color.getForegroundColor(backgroundColor: Color.red)!
```

This will return the foreground color with the highest possible contrast (black/white). Alternatively, you can define a list of possible foreground colors as well as a required conformance level. Since the WCAG requirements are different for texts and UI components, you also need to provide the specific application. The following will return the first text color that satisfies the required conformance level (*AA* by default).

```swift
let foregroundColor = Color.getForegroundColor(
    colors: [Color.red, Color.yellow],
    elementType: .smallFont,
    backgroundColor: Color.purple,
    conformanceLevel: .AA
)!
```

#### Background colors

This will also work the other way round. If you are looking for a high contrast background color:

```swift
let backgroundColor = Color.getBackgroundColor(foregroundColor: UIColor.red)!

// or

let backgroundColor = Color.getBackgroundColor(
    colors: [Color.red, Color.yellow],
    foregroundColor: Color.purple,
    elementType: .smallFont,
    conformanceLevel: .AA
)!
```

<a id="captions"></a> 
#### Image captions (UIKit/AppKit)

Get a high contrast foreground color for any given background image as follows:

```swift
let foregroundColor = UIColor.getForegroundColor(backgroundImage: myImage imageArea: .full)!
```

This will return the foreground color with the highest possible contrast (black/white) for a specific image area. 

Alternatively, you can define a list of possible foreground colors as well as a required conformance level. Since the WCAG requirements are different for texts and UI components, you also need to provide the specific application. The following will return the first foreground color that satisfies the required conformance level (*AA* by default).

```swift
let foreground = UIColor.getForegroundColor(
    colors: [UIColor.red, UIColor.yellow],
    elementType: .smallFont,
    backgroundImage: UIColor.purple,
    imageArea: topLeft,
    conformanceLevel: .AA
)!
```

You can find an overview of all image areas available in the [documentation](Documentation/).

#### Calculating contrast ratios & WCAG conformance levels

The contrast ratio of two opaque colors can be calculated as well:

```swift
let contrastRatio: CGFloat = UIColor.getContrastRatio(foregroundColor: UIColor.red, backgroundColor: UIColor.yellow)!
```

Once the contrast ratio has been determined, you can check the resulting conformance level specified by WCAG as follows:

```swift
let passedConformanceLevel = ConformanceLevel(contrastRatio: contrastRatio, elementType: .largeFont)
```

Here's an overview of available conformance levels:

| Level   | Contrast ratio                 | ElementType             | Description             |
| --------|:-------------------------------|:------------------------|:------------------------|
| .A      | *Not specified for contrast*   | -                       | -                       |
| .AA     | 3.0                            | .uiComponent            | UI component            |
|         | 3.0                            | .largeFont              | 18.0 (or 14.0 and bold) |
|         | 4.5                            | .smallFont              | 14.0                    |
| .AAA    | 4.5                            | .largeFont              | 18.0 (or 14.0 and bold) |
|         | 7.0                            | .smallFont              | 14.0                    |
| .failed | *.AA/.AAA not satisfied*       | -                       |

## Author

chrs1885, chrs1885@gmail.com

## Contributions

We'd love to see you contributing to this project by proposing or adding features, reporting bugs, or spreading the word. Please have a quick look at our [contribution guidelines](./.github/CONTRIBUTING.md).

## License

WCAG-Colors is available under the MIT license. See the LICENSE file for more info.
