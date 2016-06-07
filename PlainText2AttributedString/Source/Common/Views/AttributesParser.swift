//
//  AtributesParser.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 16/03/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

final class AttributesParser: NSObject {
  var content: String
  var textColor: UIColor
  
  init(content: String, textColor: UIColor) {
    self.content = content
    self.textColor = textColor
  }

  func processedContent() -> NSAttributedString {
    let defaultAttrs = [NSFontAttributeName: Configuration.font(16)!, NSForegroundColorAttributeName: textColor]
    let attributedString = NSMutableAttributedString(string: content, attributes: defaultAttrs)
    
    processBoldAttrs(attributedString)
    processUnderlineAttrs(attributedString)
    processBulletsListsAttrs(attributedString)
    processLinks(attributedString)
    processImages(attributedString)
    
    return attributedString
  }
  
  private func processBoldAttrs(attributedString: NSMutableAttributedString) {
    let boldAttrs = [NSFontAttributeName: Configuration.boldFont(16)!]
    replaceTag(attributedString, tag: "##BOLD##", attrs: boldAttrs)
  }
  
  private func processUnderlineAttrs(attributedString: NSMutableAttributedString) {
    let underlineAttrs = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    replaceTag(attributedString, tag: "##UNDERLINE##", attrs: underlineAttrs)
  }
  
  private func processBulletsListsAttrs(attributedString: NSMutableAttributedString) {
    let bulletListParagraphStyle = NSMutableParagraphStyle()
    bulletListParagraphStyle.paragraphSpacing = 4
    bulletListParagraphStyle.paragraphSpacingBefore = 3
    bulletListParagraphStyle.firstLineHeadIndent = 0.0
    bulletListParagraphStyle.headIndent = 19.5
    let bulletListAttrs = [NSParagraphStyleAttributeName: bulletListParagraphStyle]
    replaceTag(attributedString, tag: "##BULLETLIST##", attrs: bulletListAttrs)
  }
  
  private func replaceTag(attributedString: NSMutableAttributedString, tag: String, attrs: [String : AnyObject]) {
    var startRange = attributedString.mutableString.rangeOfString(tag)
    while (startRange.location != NSNotFound) {
      attributedString.mutableString.replaceCharactersInRange(startRange, withString: "")
      let endRange = attributedString.mutableString.rangeOfString(tag)
      if (endRange.location != NSNotFound) {
        let range = NSMakeRange(startRange.location, (endRange.location - startRange.location))
        attributedString.addAttributes(attrs, range: range)
        attributedString.mutableString.replaceCharactersInRange(endRange, withString: "")
      } else {
        return
      }
      startRange = attributedString.mutableString.rangeOfString(tag)
    }
  }
  
  private func processLinks(attributedString: NSMutableAttributedString) {
    var startRange = attributedString.mutableString.rangeOfString("##URL##")
    while (startRange.location != NSNotFound) {
      attributedString.mutableString.replaceCharactersInRange(startRange, withString: "")
      let rangeSearch = NSMakeRange(startRange.location, attributedString.length - startRange.location)
      let endLinkRange = attributedString.mutableString.rangeOfString("##", options: NSStringCompareOptions.LiteralSearch, range: rangeSearch)
      if (endLinkRange.location != NSNotFound) {
        let linkRange = NSMakeRange(startRange.location, endLinkRange.location - startRange.location)
        let link = attributedString.mutableString.substringWithRange(linkRange)
        attributedString.mutableString.replaceCharactersInRange(endLinkRange, withString: "")
        attributedString.mutableString.replaceCharactersInRange(linkRange, withString: "")
        let endRange = attributedString.mutableString.rangeOfString("##URL##")
        if (endRange.location != NSNotFound) {
          let range = NSMakeRange(startRange.location, (endRange.location - startRange.location))
          let attrs = [NSLinkAttributeName: link]
          attributedString.addAttributes(attrs, range: range)
          attributedString.mutableString.replaceCharactersInRange(endRange, withString: "")
        }
      } else {
        return
      }
      startRange = attributedString.mutableString.rangeOfString("##URL##")
    }
  }
  
  private func processImages(attributedString: NSMutableAttributedString) {
    var startRange = attributedString.mutableString.rangeOfString("##IMAGE##")
    while (startRange.location != NSNotFound) {attributedString.mutableString.replaceCharactersInRange(startRange, withString: "")
      let endImageRange = attributedString.mutableString.rangeOfString("##")
      if (endImageRange.location != NSNotFound) {
        let imageRange = NSMakeRange(startRange.location, endImageRange.location - startRange.location)
        let imageName = attributedString.mutableString.substringWithRange(imageRange)
        attributedString.mutableString.replaceCharactersInRange(endImageRange, withString: "")
        
        let imageAttachment: NSTextAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "\(imageName).png")
        let imageString: NSAttributedString = NSAttributedString(attachment: imageAttachment)
        attributedString.replaceCharactersInRange(imageRange, withAttributedString: imageString)
      }
      startRange = attributedString.mutableString.rangeOfString("##IMAGE##")
    }
  }
  
}
