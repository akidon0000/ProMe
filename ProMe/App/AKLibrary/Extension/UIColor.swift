//
//  UIColor.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/11.
//

import UIKit.UIColor

extension UIColor {
    // UIColorを16進数で表記可能
    // 例: UIColor(hex: #FFFFFF)
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // 16進数表記をUIColorへ変換
    func toHexString() -> String {
        var red: CGFloat     = 1.0
        var green: CGFloat   = 1.0
        var blue: CGFloat    = 1.0
        var alpha: CGFloat   = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(String(Int(floor(red*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let g = Int(String(Int(floor(green*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let b = Int(String(Int(floor(blue*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        let a = Int(String(Int(floor(alpha*100)/100 * 255)).replacingOccurrences(of: "-", with: ""))!
        
        let result = String(r, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(g, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(b, radix: 16).leftPadding(toLength: 2, withPad: "0") + String(a, radix: 16).leftPadding(toLength: 2, withPad: "0")
        return result
    }
}
