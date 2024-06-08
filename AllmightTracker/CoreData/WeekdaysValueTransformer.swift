//
//  WeekdaysValueTransformer.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 03.06.2024.
//

import Foundation

@objc(WeekdaysValueTransformer)
final class WeekdaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(days) as NSData
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
    
    @objc static func register() {
        ValueTransformer.setValueTransformer(
            WeekdaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: WeekdaysValueTransformer.self))
        )
    }
}
