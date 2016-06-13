//
//  GraphsExtensions.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/05/31.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

extension SequenceType where Generator.Element: NumericType {
    
    public func barGraph(
        range: GraphRange<Generator.Element>? = nil,
        textDisplayHandler: Graph<String, Generator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Generator.Element> {
        
        return Graph<String, Generator.Element>(type: .Bar, array: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    
    public func lineGraph(
        range: GraphRange<Generator.Element>? = nil,
        textDisplayHandler: Graph<String, Generator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Generator.Element> {
        
        return Graph<String, Generator.Element>(type: .Line, array: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    
    public func pieGraph(
        textDisplayHandler: Graph<String, Generator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Generator.Element> {
        
        return Graph<String, Generator.Element>(type: .Pie, array: self.map{ $0 }, range: nil, textDisplayHandler: textDisplayHandler)
    }
    
}


extension CollectionType where Self: DictionaryLiteralConvertible, Self.Key: Hashable, Self.Value: NumericType, Generator.Element == (Self.Key, Self.Value) {
    
    
    typealias aKey = Self.Key
    typealias aValue = Self.Value
    
    public func barGraph(
        range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
    ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .Bar, dictionary: dict(), range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func lineGraph(
        range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
        ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .Line, dictionary: dict(), range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func pieGraph(
        range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
        ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .Pie, dictionary: dict(), range: nil, textDisplayHandler: textDisplayHandler)
    }
    
    func dict() -> [aKey: aValue] {
        var d = [aKey: aValue]()
        for kv in self {
            d[kv.0] = kv.1
        }
        return d
    }
    
    func touples() -> [(aKey, aValue)] {
        var d = [(aKey, aValue)]()
        for kv in self {
            d.append((kv.0, kv.1))
        }
        return d
    }
    
}

extension Array {
    var match : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0],Array(self[1..<count])) : nil
    }
}

enum DefaultColorType {
    case Bar, Line, BarText, LineText, PieText
    
    func color() -> UIColor {
        switch self {
        case .Bar:      return UIColor(hex: "#4DC2AB")
        case .Line:     return UIColor(hex: "#FF0066")
        case .BarText:  return UIColor(hex: "#333333")
        case .LineText: return UIColor(hex: "#333333")
        case .PieText:  return UIColor(hex: "#333333")
        }
    }
    
    static func pieColors(count: Int) -> [UIColor] {
        return Array(0 ..< count).map({ $0 * 16 }).map({ UIColor(RGBInt: UInt64($0)) })
    }
}

extension UIColor {
    
    convenience init(RGBInt: UInt64, alpha: Float = 1.0) {
        self.init(
            red: (((CGFloat)((RGBInt & 0xFF0000) >> 16)) / 255.0),
            green: (((CGFloat)((RGBInt & 0xFF00) >> 8)) / 255.0),
            blue: (((CGFloat)(RGBInt & 0xFF)) / 255.0),
            alpha: CGFloat(alpha)
        )
    }
    
    convenience init(hex: String) {
        
        let prefixHex = {(str) -> String in
            for prefix in ["0x", "0X", "#"] {
                if str.hasPrefix(prefix) {
                    return str.substringFromIndex(str.startIndex.advancedBy(prefix.characters.count))
                }
            }
            return str
        }(hex)
        
        
        if prefixHex.characters.count != 6 && prefixHex.characters.count != 8 {
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        let scanner = NSScanner(string: prefixHex)
        var hexInt: UInt64 = 0
        if !scanner.scanHexLongLong(&hexInt) {
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        switch prefixHex.characters.count {
        case 6:
            self.init(RGBInt: hexInt)
        case 8:
            self.init(RGBInt: hexInt >> 8, alpha: (((Float)(hexInt & 0xFF)) / 255.0))
        case _:
            self.init(white: 0.0, alpha: 1.0)
        }
    }
    
    
}


