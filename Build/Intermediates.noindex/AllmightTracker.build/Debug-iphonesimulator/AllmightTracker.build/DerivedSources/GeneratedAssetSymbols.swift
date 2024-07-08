import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

    /// The "ColorSelection1" asset catalog color resource.
    static let colorSelection1 = ColorResource(name: "ColorSelection1", bundle: resourceBundle)

    /// The "ColorSelection10" asset catalog color resource.
    static let colorSelection10 = ColorResource(name: "ColorSelection10", bundle: resourceBundle)

    /// The "ColorSelection11" asset catalog color resource.
    static let colorSelection11 = ColorResource(name: "ColorSelection11", bundle: resourceBundle)

    /// The "ColorSelection12" asset catalog color resource.
    static let colorSelection12 = ColorResource(name: "ColorSelection12", bundle: resourceBundle)

    /// The "ColorSelection13" asset catalog color resource.
    static let colorSelection13 = ColorResource(name: "ColorSelection13", bundle: resourceBundle)

    /// The "ColorSelection14" asset catalog color resource.
    static let colorSelection14 = ColorResource(name: "ColorSelection14", bundle: resourceBundle)

    /// The "ColorSelection15" asset catalog color resource.
    static let colorSelection15 = ColorResource(name: "ColorSelection15", bundle: resourceBundle)

    /// The "ColorSelection16" asset catalog color resource.
    static let colorSelection16 = ColorResource(name: "ColorSelection16", bundle: resourceBundle)

    /// The "ColorSelection17" asset catalog color resource.
    static let colorSelection17 = ColorResource(name: "ColorSelection17", bundle: resourceBundle)

    /// The "ColorSelection18" asset catalog color resource.
    static let colorSelection18 = ColorResource(name: "ColorSelection18", bundle: resourceBundle)

    /// The "ColorSelection2" asset catalog color resource.
    static let colorSelection2 = ColorResource(name: "ColorSelection2", bundle: resourceBundle)

    /// The "ColorSelection3" asset catalog color resource.
    static let colorSelection3 = ColorResource(name: "ColorSelection3", bundle: resourceBundle)

    /// The "ColorSelection4" asset catalog color resource.
    static let colorSelection4 = ColorResource(name: "ColorSelection4", bundle: resourceBundle)

    /// The "ColorSelection5" asset catalog color resource.
    static let colorSelection5 = ColorResource(name: "ColorSelection5", bundle: resourceBundle)

    /// The "ColorSelection6" asset catalog color resource.
    static let colorSelection6 = ColorResource(name: "ColorSelection6", bundle: resourceBundle)

    /// The "ColorSelection7" asset catalog color resource.
    static let colorSelection7 = ColorResource(name: "ColorSelection7", bundle: resourceBundle)

    /// The "ColorSelection8" asset catalog color resource.
    static let colorSelection8 = ColorResource(name: "ColorSelection8", bundle: resourceBundle)

    /// The "ColorSelection9" asset catalog color resource.
    static let colorSelection9 = ColorResource(name: "ColorSelection9", bundle: resourceBundle)

    /// The "GradientColor1" asset catalog color resource.
    static let gradientColor1 = ColorResource(name: "GradientColor1", bundle: resourceBundle)

    /// The "GradientColor2" asset catalog color resource.
    static let gradientColor2 = ColorResource(name: "GradientColor2", bundle: resourceBundle)

    /// The "GradientColor3" asset catalog color resource.
    static let gradientColor3 = ColorResource(name: "GradientColor3", bundle: resourceBundle)

    /// The "LaunchScreenBackground" asset catalog color resource.
    static let launchScreenBackground = ColorResource(name: "LaunchScreenBackground", bundle: resourceBundle)

    /// The "OnboardingViewGray" asset catalog color resource.
    static let onboardingViewGray = ColorResource(name: "OnboardingViewGray", bundle: resourceBundle)

    /// The "TrackerBackgroundDay" asset catalog color resource.
    static let trackerBackgroundDay = ColorResource(name: "TrackerBackgroundDay", bundle: resourceBundle)

    /// The "TrackerBlack" asset catalog color resource.
    static let trackerBlack = ColorResource(name: "TrackerBlack", bundle: resourceBundle)

    /// The "TrackerBlue" asset catalog color resource.
    static let trackerBlue = ColorResource(name: "TrackerBlue", bundle: resourceBundle)

    /// The "TrackerDateLabelTextColor" asset catalog color resource.
    static let trackerDateLabelText = ColorResource(name: "TrackerDateLabelTextColor", bundle: resourceBundle)

    /// The "TrackerGray" asset catalog color resource.
    static let trackerGray = ColorResource(name: "TrackerGray", bundle: resourceBundle)

    /// The "TrackerLightGray" asset catalog color resource.
    static let trackerLightGray = ColorResource(name: "TrackerLightGray", bundle: resourceBundle)

    /// The "TrackerLightGray12" asset catalog color resource.
    static let trackerLightGray12 = ColorResource(name: "TrackerLightGray12", bundle: resourceBundle)

    /// The "TrackerRed" asset catalog color resource.
    static let trackerRed = ColorResource(name: "TrackerRed", bundle: resourceBundle)

    /// The "TrackerSuperLightGray" asset catalog color resource.
    static let trackerSuperLightGray = ColorResource(name: "TrackerSuperLightGray", bundle: resourceBundle)

    /// The "TrackerWhite" asset catalog color resource.
    static let trackerWhite = ColorResource(name: "TrackerWhite", bundle: resourceBundle)

    /// The "onboardingViewBlack" asset catalog color resource.
    static let onboardingViewBlack = ColorResource(name: "onboardingViewBlack", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "Logo" asset catalog image resource.
    static let logo = ImageResource(name: "Logo", bundle: resourceBundle)

    /// The "OnboardingBackgroundPage1" asset catalog image resource.
    static let onboardingBackgroundPage1 = ImageResource(name: "OnboardingBackgroundPage1", bundle: resourceBundle)

    /// The "OnboardingBackgroundPage2" asset catalog image resource.
    static let onboardingBackgroundPage2 = ImageResource(name: "OnboardingBackgroundPage2", bundle: resourceBundle)

    /// The "StarMainScreen" asset catalog image resource.
    static let starMainScreen = ImageResource(name: "StarMainScreen", bundle: resourceBundle)

    /// The "checkedBlue" asset catalog image resource.
    static let checkedBlue = ImageResource(name: "checkedBlue", bundle: resourceBundle)

    /// The "emptyStatsImage" asset catalog image resource.
    static let emptyStats = ImageResource(name: "emptyStatsImage", bundle: resourceBundle)

    /// The "navBarAddIcon" asset catalog image resource.
    static let navBarAddIcon = ImageResource(name: "navBarAddIcon", bundle: resourceBundle)

    /// The "navigationRight" asset catalog image resource.
    static let navigationRight = ImageResource(name: "navigationRight", bundle: resourceBundle)

    /// The "notFoundImage" asset catalog image resource.
    static let notFound = ImageResource(name: "notFoundImage", bundle: resourceBundle)

    /// The "pinSquare" asset catalog image resource.
    static let pinSquare = ImageResource(name: "pinSquare", bundle: resourceBundle)

    /// The "plus" asset catalog image resource.
    static let plus = ImageResource(name: "plus", bundle: resourceBundle)

    /// The "tabBarStatisticsIcon" asset catalog image resource.
    static let tabBarStatisticsIcon = ImageResource(name: "tabBarStatisticsIcon", bundle: resourceBundle)

    /// The "tabBarTrackersIcon" asset catalog image resource.
    static let tabBarTrackersIcon = ImageResource(name: "tabBarTrackersIcon", bundle: resourceBundle)

    /// The "xmark.circle" asset catalog image resource.
    static let xmarkCircle = ImageResource(name: "xmark.circle", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "ColorSelection1" asset catalog color.
    static var colorSelection1: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection1)
#else
        .init()
#endif
    }

    /// The "ColorSelection10" asset catalog color.
    static var colorSelection10: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection10)
#else
        .init()
#endif
    }

    /// The "ColorSelection11" asset catalog color.
    static var colorSelection11: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection11)
#else
        .init()
#endif
    }

    /// The "ColorSelection12" asset catalog color.
    static var colorSelection12: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection12)
#else
        .init()
#endif
    }

    /// The "ColorSelection13" asset catalog color.
    static var colorSelection13: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection13)
#else
        .init()
#endif
    }

    /// The "ColorSelection14" asset catalog color.
    static var colorSelection14: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection14)
#else
        .init()
#endif
    }

    /// The "ColorSelection15" asset catalog color.
    static var colorSelection15: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection15)
#else
        .init()
#endif
    }

    /// The "ColorSelection16" asset catalog color.
    static var colorSelection16: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection16)
#else
        .init()
#endif
    }

    /// The "ColorSelection17" asset catalog color.
    static var colorSelection17: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection17)
#else
        .init()
#endif
    }

    /// The "ColorSelection18" asset catalog color.
    static var colorSelection18: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection18)
#else
        .init()
#endif
    }

    /// The "ColorSelection2" asset catalog color.
    static var colorSelection2: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection2)
#else
        .init()
#endif
    }

    /// The "ColorSelection3" asset catalog color.
    static var colorSelection3: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection3)
#else
        .init()
#endif
    }

    /// The "ColorSelection4" asset catalog color.
    static var colorSelection4: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection4)
#else
        .init()
#endif
    }

    /// The "ColorSelection5" asset catalog color.
    static var colorSelection5: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection5)
#else
        .init()
#endif
    }

    /// The "ColorSelection6" asset catalog color.
    static var colorSelection6: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection6)
#else
        .init()
#endif
    }

    /// The "ColorSelection7" asset catalog color.
    static var colorSelection7: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection7)
#else
        .init()
#endif
    }

    /// The "ColorSelection8" asset catalog color.
    static var colorSelection8: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection8)
#else
        .init()
#endif
    }

    /// The "ColorSelection9" asset catalog color.
    static var colorSelection9: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .colorSelection9)
#else
        .init()
#endif
    }

    /// The "GradientColor1" asset catalog color.
    static var gradientColor1: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gradientColor1)
#else
        .init()
#endif
    }

    /// The "GradientColor2" asset catalog color.
    static var gradientColor2: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gradientColor2)
#else
        .init()
#endif
    }

    /// The "GradientColor3" asset catalog color.
    static var gradientColor3: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .gradientColor3)
#else
        .init()
#endif
    }

    /// The "LaunchScreenBackground" asset catalog color.
    static var launchScreenBackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchScreenBackground)
#else
        .init()
#endif
    }

    /// The "OnboardingViewGray" asset catalog color.
    static var onboardingViewGray: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onboardingViewGray)
#else
        .init()
#endif
    }

    /// The "TrackerBackgroundDay" asset catalog color.
    static var trackerBackgroundDay: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerBackgroundDay)
#else
        .init()
#endif
    }

    /// The "TrackerBlack" asset catalog color.
    static var trackerBlack: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerBlack)
#else
        .init()
#endif
    }

    /// The "TrackerBlue" asset catalog color.
    static var trackerBlue: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerBlue)
#else
        .init()
#endif
    }

    /// The "TrackerDateLabelTextColor" asset catalog color.
    static var trackerDateLabelText: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerDateLabelText)
#else
        .init()
#endif
    }

    /// The "TrackerGray" asset catalog color.
    static var trackerGray: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerGray)
#else
        .init()
#endif
    }

    /// The "TrackerLightGray" asset catalog color.
    static var trackerLightGray: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerLightGray)
#else
        .init()
#endif
    }

    /// The "TrackerLightGray12" asset catalog color.
    static var trackerLightGray12: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerLightGray12)
#else
        .init()
#endif
    }

    /// The "TrackerRed" asset catalog color.
    static var trackerRed: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerRed)
#else
        .init()
#endif
    }

    /// The "TrackerSuperLightGray" asset catalog color.
    static var trackerSuperLightGray: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerSuperLightGray)
#else
        .init()
#endif
    }

    /// The "TrackerWhite" asset catalog color.
    static var trackerWhite: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .trackerWhite)
#else
        .init()
#endif
    }

    /// The "onboardingViewBlack" asset catalog color.
    static var onboardingViewBlack: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onboardingViewBlack)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "ColorSelection1" asset catalog color.
    static var colorSelection1: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection1)
#else
        .init()
#endif
    }

    /// The "ColorSelection10" asset catalog color.
    static var colorSelection10: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection10)
#else
        .init()
#endif
    }

    /// The "ColorSelection11" asset catalog color.
    static var colorSelection11: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection11)
#else
        .init()
#endif
    }

    /// The "ColorSelection12" asset catalog color.
    static var colorSelection12: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection12)
#else
        .init()
#endif
    }

    /// The "ColorSelection13" asset catalog color.
    static var colorSelection13: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection13)
#else
        .init()
#endif
    }

    /// The "ColorSelection14" asset catalog color.
    static var colorSelection14: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection14)
#else
        .init()
#endif
    }

    /// The "ColorSelection15" asset catalog color.
    static var colorSelection15: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection15)
#else
        .init()
#endif
    }

    /// The "ColorSelection16" asset catalog color.
    static var colorSelection16: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection16)
#else
        .init()
#endif
    }

    /// The "ColorSelection17" asset catalog color.
    static var colorSelection17: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection17)
#else
        .init()
#endif
    }

    /// The "ColorSelection18" asset catalog color.
    static var colorSelection18: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection18)
#else
        .init()
#endif
    }

    /// The "ColorSelection2" asset catalog color.
    static var colorSelection2: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection2)
#else
        .init()
#endif
    }

    /// The "ColorSelection3" asset catalog color.
    static var colorSelection3: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection3)
#else
        .init()
#endif
    }

    /// The "ColorSelection4" asset catalog color.
    static var colorSelection4: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection4)
#else
        .init()
#endif
    }

    /// The "ColorSelection5" asset catalog color.
    static var colorSelection5: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection5)
#else
        .init()
#endif
    }

    /// The "ColorSelection6" asset catalog color.
    static var colorSelection6: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection6)
#else
        .init()
#endif
    }

    /// The "ColorSelection7" asset catalog color.
    static var colorSelection7: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection7)
#else
        .init()
#endif
    }

    /// The "ColorSelection8" asset catalog color.
    static var colorSelection8: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection8)
#else
        .init()
#endif
    }

    /// The "ColorSelection9" asset catalog color.
    static var colorSelection9: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .colorSelection9)
#else
        .init()
#endif
    }

    /// The "GradientColor1" asset catalog color.
    static var gradientColor1: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .gradientColor1)
#else
        .init()
#endif
    }

    /// The "GradientColor2" asset catalog color.
    static var gradientColor2: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .gradientColor2)
#else
        .init()
#endif
    }

    /// The "GradientColor3" asset catalog color.
    static var gradientColor3: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .gradientColor3)
#else
        .init()
#endif
    }

    /// The "LaunchScreenBackground" asset catalog color.
    static var launchScreenBackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .launchScreenBackground)
#else
        .init()
#endif
    }

    /// The "OnboardingViewGray" asset catalog color.
    static var onboardingViewGray: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .onboardingViewGray)
#else
        .init()
#endif
    }

    /// The "TrackerBackgroundDay" asset catalog color.
    static var trackerBackgroundDay: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerBackgroundDay)
#else
        .init()
#endif
    }

    /// The "TrackerBlack" asset catalog color.
    static var trackerBlack: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerBlack)
#else
        .init()
#endif
    }

    /// The "TrackerBlue" asset catalog color.
    static var trackerBlue: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerBlue)
#else
        .init()
#endif
    }

    /// The "TrackerDateLabelTextColor" asset catalog color.
    static var trackerDateLabelText: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerDateLabelText)
#else
        .init()
#endif
    }

    /// The "TrackerGray" asset catalog color.
    static var trackerGray: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerGray)
#else
        .init()
#endif
    }

    /// The "TrackerLightGray" asset catalog color.
    static var trackerLightGray: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerLightGray)
#else
        .init()
#endif
    }

    /// The "TrackerLightGray12" asset catalog color.
    static var trackerLightGray12: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerLightGray12)
#else
        .init()
#endif
    }

    /// The "TrackerRed" asset catalog color.
    static var trackerRed: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerRed)
#else
        .init()
#endif
    }

    /// The "TrackerSuperLightGray" asset catalog color.
    static var trackerSuperLightGray: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerSuperLightGray)
#else
        .init()
#endif
    }

    /// The "TrackerWhite" asset catalog color.
    static var trackerWhite: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .trackerWhite)
#else
        .init()
#endif
    }

    /// The "onboardingViewBlack" asset catalog color.
    static var onboardingViewBlack: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .onboardingViewBlack)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "ColorSelection1" asset catalog color.
    static var colorSelection1: SwiftUI.Color { .init(.colorSelection1) }

    /// The "ColorSelection10" asset catalog color.
    static var colorSelection10: SwiftUI.Color { .init(.colorSelection10) }

    /// The "ColorSelection11" asset catalog color.
    static var colorSelection11: SwiftUI.Color { .init(.colorSelection11) }

    /// The "ColorSelection12" asset catalog color.
    static var colorSelection12: SwiftUI.Color { .init(.colorSelection12) }

    /// The "ColorSelection13" asset catalog color.
    static var colorSelection13: SwiftUI.Color { .init(.colorSelection13) }

    /// The "ColorSelection14" asset catalog color.
    static var colorSelection14: SwiftUI.Color { .init(.colorSelection14) }

    /// The "ColorSelection15" asset catalog color.
    static var colorSelection15: SwiftUI.Color { .init(.colorSelection15) }

    /// The "ColorSelection16" asset catalog color.
    static var colorSelection16: SwiftUI.Color { .init(.colorSelection16) }

    /// The "ColorSelection17" asset catalog color.
    static var colorSelection17: SwiftUI.Color { .init(.colorSelection17) }

    /// The "ColorSelection18" asset catalog color.
    static var colorSelection18: SwiftUI.Color { .init(.colorSelection18) }

    /// The "ColorSelection2" asset catalog color.
    static var colorSelection2: SwiftUI.Color { .init(.colorSelection2) }

    /// The "ColorSelection3" asset catalog color.
    static var colorSelection3: SwiftUI.Color { .init(.colorSelection3) }

    /// The "ColorSelection4" asset catalog color.
    static var colorSelection4: SwiftUI.Color { .init(.colorSelection4) }

    /// The "ColorSelection5" asset catalog color.
    static var colorSelection5: SwiftUI.Color { .init(.colorSelection5) }

    /// The "ColorSelection6" asset catalog color.
    static var colorSelection6: SwiftUI.Color { .init(.colorSelection6) }

    /// The "ColorSelection7" asset catalog color.
    static var colorSelection7: SwiftUI.Color { .init(.colorSelection7) }

    /// The "ColorSelection8" asset catalog color.
    static var colorSelection8: SwiftUI.Color { .init(.colorSelection8) }

    /// The "ColorSelection9" asset catalog color.
    static var colorSelection9: SwiftUI.Color { .init(.colorSelection9) }

    /// The "GradientColor1" asset catalog color.
    static var gradientColor1: SwiftUI.Color { .init(.gradientColor1) }

    /// The "GradientColor2" asset catalog color.
    static var gradientColor2: SwiftUI.Color { .init(.gradientColor2) }

    /// The "GradientColor3" asset catalog color.
    static var gradientColor3: SwiftUI.Color { .init(.gradientColor3) }

    /// The "LaunchScreenBackground" asset catalog color.
    static var launchScreenBackground: SwiftUI.Color { .init(.launchScreenBackground) }

    /// The "OnboardingViewGray" asset catalog color.
    static var onboardingViewGray: SwiftUI.Color { .init(.onboardingViewGray) }

    /// The "TrackerBackgroundDay" asset catalog color.
    static var trackerBackgroundDay: SwiftUI.Color { .init(.trackerBackgroundDay) }

    /// The "TrackerBlack" asset catalog color.
    static var trackerBlack: SwiftUI.Color { .init(.trackerBlack) }

    /// The "TrackerBlue" asset catalog color.
    static var trackerBlue: SwiftUI.Color { .init(.trackerBlue) }

    /// The "TrackerDateLabelTextColor" asset catalog color.
    static var trackerDateLabelText: SwiftUI.Color { .init(.trackerDateLabelText) }

    /// The "TrackerGray" asset catalog color.
    static var trackerGray: SwiftUI.Color { .init(.trackerGray) }

    /// The "TrackerLightGray" asset catalog color.
    static var trackerLightGray: SwiftUI.Color { .init(.trackerLightGray) }

    /// The "TrackerLightGray12" asset catalog color.
    static var trackerLightGray12: SwiftUI.Color { .init(.trackerLightGray12) }

    /// The "TrackerRed" asset catalog color.
    static var trackerRed: SwiftUI.Color { .init(.trackerRed) }

    /// The "TrackerSuperLightGray" asset catalog color.
    static var trackerSuperLightGray: SwiftUI.Color { .init(.trackerSuperLightGray) }

    /// The "TrackerWhite" asset catalog color.
    static var trackerWhite: SwiftUI.Color { .init(.trackerWhite) }

    /// The "onboardingViewBlack" asset catalog color.
    static var onboardingViewBlack: SwiftUI.Color { .init(.onboardingViewBlack) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "ColorSelection1" asset catalog color.
    static var colorSelection1: SwiftUI.Color { .init(.colorSelection1) }

    /// The "ColorSelection10" asset catalog color.
    static var colorSelection10: SwiftUI.Color { .init(.colorSelection10) }

    /// The "ColorSelection11" asset catalog color.
    static var colorSelection11: SwiftUI.Color { .init(.colorSelection11) }

    /// The "ColorSelection12" asset catalog color.
    static var colorSelection12: SwiftUI.Color { .init(.colorSelection12) }

    /// The "ColorSelection13" asset catalog color.
    static var colorSelection13: SwiftUI.Color { .init(.colorSelection13) }

    /// The "ColorSelection14" asset catalog color.
    static var colorSelection14: SwiftUI.Color { .init(.colorSelection14) }

    /// The "ColorSelection15" asset catalog color.
    static var colorSelection15: SwiftUI.Color { .init(.colorSelection15) }

    /// The "ColorSelection16" asset catalog color.
    static var colorSelection16: SwiftUI.Color { .init(.colorSelection16) }

    /// The "ColorSelection17" asset catalog color.
    static var colorSelection17: SwiftUI.Color { .init(.colorSelection17) }

    /// The "ColorSelection18" asset catalog color.
    static var colorSelection18: SwiftUI.Color { .init(.colorSelection18) }

    /// The "ColorSelection2" asset catalog color.
    static var colorSelection2: SwiftUI.Color { .init(.colorSelection2) }

    /// The "ColorSelection3" asset catalog color.
    static var colorSelection3: SwiftUI.Color { .init(.colorSelection3) }

    /// The "ColorSelection4" asset catalog color.
    static var colorSelection4: SwiftUI.Color { .init(.colorSelection4) }

    /// The "ColorSelection5" asset catalog color.
    static var colorSelection5: SwiftUI.Color { .init(.colorSelection5) }

    /// The "ColorSelection6" asset catalog color.
    static var colorSelection6: SwiftUI.Color { .init(.colorSelection6) }

    /// The "ColorSelection7" asset catalog color.
    static var colorSelection7: SwiftUI.Color { .init(.colorSelection7) }

    /// The "ColorSelection8" asset catalog color.
    static var colorSelection8: SwiftUI.Color { .init(.colorSelection8) }

    /// The "ColorSelection9" asset catalog color.
    static var colorSelection9: SwiftUI.Color { .init(.colorSelection9) }

    /// The "GradientColor1" asset catalog color.
    static var gradientColor1: SwiftUI.Color { .init(.gradientColor1) }

    /// The "GradientColor2" asset catalog color.
    static var gradientColor2: SwiftUI.Color { .init(.gradientColor2) }

    /// The "GradientColor3" asset catalog color.
    static var gradientColor3: SwiftUI.Color { .init(.gradientColor3) }

    /// The "LaunchScreenBackground" asset catalog color.
    static var launchScreenBackground: SwiftUI.Color { .init(.launchScreenBackground) }

    /// The "OnboardingViewGray" asset catalog color.
    static var onboardingViewGray: SwiftUI.Color { .init(.onboardingViewGray) }

    /// The "TrackerBackgroundDay" asset catalog color.
    static var trackerBackgroundDay: SwiftUI.Color { .init(.trackerBackgroundDay) }

    /// The "TrackerBlack" asset catalog color.
    static var trackerBlack: SwiftUI.Color { .init(.trackerBlack) }

    /// The "TrackerBlue" asset catalog color.
    static var trackerBlue: SwiftUI.Color { .init(.trackerBlue) }

    /// The "TrackerDateLabelTextColor" asset catalog color.
    static var trackerDateLabelText: SwiftUI.Color { .init(.trackerDateLabelText) }

    /// The "TrackerGray" asset catalog color.
    static var trackerGray: SwiftUI.Color { .init(.trackerGray) }

    /// The "TrackerLightGray" asset catalog color.
    static var trackerLightGray: SwiftUI.Color { .init(.trackerLightGray) }

    /// The "TrackerLightGray12" asset catalog color.
    static var trackerLightGray12: SwiftUI.Color { .init(.trackerLightGray12) }

    /// The "TrackerRed" asset catalog color.
    static var trackerRed: SwiftUI.Color { .init(.trackerRed) }

    /// The "TrackerSuperLightGray" asset catalog color.
    static var trackerSuperLightGray: SwiftUI.Color { .init(.trackerSuperLightGray) }

    /// The "TrackerWhite" asset catalog color.
    static var trackerWhite: SwiftUI.Color { .init(.trackerWhite) }

    /// The "onboardingViewBlack" asset catalog color.
    static var onboardingViewBlack: SwiftUI.Color { .init(.onboardingViewBlack) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "Logo" asset catalog image.
    static var logo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "OnboardingBackgroundPage1" asset catalog image.
    static var onboardingBackgroundPage1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onboardingBackgroundPage1)
#else
        .init()
#endif
    }

    /// The "OnboardingBackgroundPage2" asset catalog image.
    static var onboardingBackgroundPage2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onboardingBackgroundPage2)
#else
        .init()
#endif
    }

    /// The "StarMainScreen" asset catalog image.
    static var starMainScreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .starMainScreen)
#else
        .init()
#endif
    }

    /// The "checkedBlue" asset catalog image.
    static var checkedBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .checkedBlue)
#else
        .init()
#endif
    }

    /// The "emptyStatsImage" asset catalog image.
    static var emptyStats: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .emptyStats)
#else
        .init()
#endif
    }

    /// The "navBarAddIcon" asset catalog image.
    static var navBarAddIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .navBarAddIcon)
#else
        .init()
#endif
    }

    /// The "navigationRight" asset catalog image.
    static var navigationRight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .navigationRight)
#else
        .init()
#endif
    }

    /// The "notFoundImage" asset catalog image.
    static var notFound: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .notFound)
#else
        .init()
#endif
    }

    /// The "pinSquare" asset catalog image.
    static var pinSquare: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pinSquare)
#else
        .init()
#endif
    }

    /// The "plus" asset catalog image.
    static var plus: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .plus)
#else
        .init()
#endif
    }

    /// The "tabBarStatisticsIcon" asset catalog image.
    static var tabBarStatisticsIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabBarStatisticsIcon)
#else
        .init()
#endif
    }

    /// The "tabBarTrackersIcon" asset catalog image.
    static var tabBarTrackersIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabBarTrackersIcon)
#else
        .init()
#endif
    }

    /// The "xmark.circle" asset catalog image.
    static var xmarkCircle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .xmarkCircle)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "Logo" asset catalog image.
    static var logo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logo)
#else
        .init()
#endif
    }

    /// The "OnboardingBackgroundPage1" asset catalog image.
    static var onboardingBackgroundPage1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .onboardingBackgroundPage1)
#else
        .init()
#endif
    }

    /// The "OnboardingBackgroundPage2" asset catalog image.
    static var onboardingBackgroundPage2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .onboardingBackgroundPage2)
#else
        .init()
#endif
    }

    /// The "StarMainScreen" asset catalog image.
    static var starMainScreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .starMainScreen)
#else
        .init()
#endif
    }

    /// The "checkedBlue" asset catalog image.
    static var checkedBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .checkedBlue)
#else
        .init()
#endif
    }

    /// The "emptyStatsImage" asset catalog image.
    static var emptyStats: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .emptyStats)
#else
        .init()
#endif
    }

    /// The "navBarAddIcon" asset catalog image.
    static var navBarAddIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .navBarAddIcon)
#else
        .init()
#endif
    }

    /// The "navigationRight" asset catalog image.
    static var navigationRight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .navigationRight)
#else
        .init()
#endif
    }

    /// The "notFoundImage" asset catalog image.
    static var notFound: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .notFound)
#else
        .init()
#endif
    }

    /// The "pinSquare" asset catalog image.
    static var pinSquare: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pinSquare)
#else
        .init()
#endif
    }

    /// The "plus" asset catalog image.
    static var plus: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .plus)
#else
        .init()
#endif
    }

    /// The "tabBarStatisticsIcon" asset catalog image.
    static var tabBarStatisticsIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabBarStatisticsIcon)
#else
        .init()
#endif
    }

    /// The "tabBarTrackersIcon" asset catalog image.
    static var tabBarTrackersIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabBarTrackersIcon)
#else
        .init()
#endif
    }

    /// The "xmark.circle" asset catalog image.
    static var xmarkCircle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .xmarkCircle)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif