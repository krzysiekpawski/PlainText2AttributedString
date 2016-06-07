//
//  CustomTextView.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 11/02/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

protocol CustomTextViewDelegate: class {
  func textView(textView: UITextView, didAddTagWithRange: NSRange, tagText: String)
  func textView(textView: UITextView, didAddHighlightWithRange: NSRange)
}

final class CustomTextView: UITextView {
  
  weak var customDelegate: CustomTextViewDelegate?

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    configure()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  private func configure() {
    backgroundColor = Configuration.pagesBackgroundColor
    font = Configuration.font(18)
    textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
    editable = false
    linkTextAttributes = [NSForegroundColorAttributeName: Configuration.linkTextColor, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue]
    
    let menu = UIMenuController.sharedMenuController()
    let highlightItem = UIMenuItem(title: "Highlight", action: #selector(highlightCurrentlySelectedText))
    let taghtItem = UIMenuItem(title: "Tag", action: #selector(tagCurrentlySelectedText))
    menu.menuItems = [highlightItem, taghtItem]
  }
  
  func highlightCurrentlySelectedText() {
    customDelegate?.textView(self, didAddHighlightWithRange: selectedRange)
  }
  
  func tagCurrentlySelectedText() {
    customDelegate?.textView(self, didAddTagWithRange: selectedRange, tagText: textInRange(selectedTextRange!)!)
  }
  
  override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    return Configuration.actionsAllowedInTextMenu.contains(action.description)
  }
  
}
