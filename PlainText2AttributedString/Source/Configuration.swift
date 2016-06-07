//
//  Configuration.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 30/01/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

struct Configuration {
  
  //MARK: Colors
  
  static let pagesBackgroundColor = UIColor(redI: 212, greenI: 212, blueI: 212)
  static let linkTextColor = UIColor(redI: 27, greenI: 27, blueI: 127)
  
  // MARK: TextMenuActions
  
  static let actionsAllowedInTextMenu = ["copy:", "highlightCurrentlySelectedText", "tagCurrentlySelectedText"]
  
  // MARK: Font
  
  static func font(size: CGFloat) -> UIFont? {
    return UIFont.systemFontOfSize(size)
  }
  
  static func boldFont(size: CGFloat) -> UIFont? {
    return UIFont.boldSystemFontOfSize(size)
  }
}