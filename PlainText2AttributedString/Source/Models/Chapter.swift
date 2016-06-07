//
//  Chapter.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 30/01/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import Foundation

struct Chapter {
  static let rootID: UInt = 0
  
  var id: UInt
  var parentId: UInt
  var title: String
  var tagTitle: String?
  var subtitle: String?
  var chapterDescription: String?
  var colorRedValue: Int?
  var colorGreenValue: Int?
  var colorBlueValue: Int?
  var hasSubchapters: Bool
  var type: UInt

}
