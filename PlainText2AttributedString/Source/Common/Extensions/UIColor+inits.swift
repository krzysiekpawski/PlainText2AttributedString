//
//  UIColor+HexString.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 30/01/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

extension UIColor {
  
  // https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
  convenience init(hexString:String) {
    let hexString:NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    let scanner            = NSScanner(string: hexString as String)
    
    if (hexString.hasPrefix("#")) {
      scanner.scanLocation = 1
    }
    
    var color:UInt32 = 0
    scanner.scanHexInt(&color)
    
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    
    self.init(red:red, green:green, blue:blue, alpha:1)
  }
  
  convenience init(redI: NSInteger, greenI: NSInteger, blueI: NSInteger) {
    self.init(red:CGFloat(redI)/255.0, green:CGFloat(greenI)/255.0, blue:CGFloat(blueI)/255.0, alpha:1)
  }
}