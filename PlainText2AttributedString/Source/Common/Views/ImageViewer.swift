//
//  ImageViewer.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 11/03/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//
//  based on https://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift

import UIKit

final class ImageViewer: UIView {
  var image: UIImage?
  var scrollView: UIScrollView?
  var imageView: UIImageView?
  var closeButton: UIButton?
  
  override var frame: CGRect {
    didSet {
      configureSubviews()
    }
  }
  
  // MARK: Init
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(image aImage: UIImage) {
    super.init(frame: CGRectZero)
    backgroundColor = UIColor.blackColor()
    image = aImage
  }
  
  // MARK: Configuration
  
  private func configureSubviews() {
    rebuildSubViews()
    configureGesture()
    recalculateSizesAndLocation()
  }
  
  private func rebuildSubViews() {
    clearSubViews()
    rebuildScrollView()
    rebuildImageView()
    rebuildCloseButton()
  }
  
  private func clearSubViews() {
    if (scrollView != nil) {
      scrollView?.removeFromSuperview()
      scrollView = nil
      
      imageView?.removeFromSuperview()
      imageView = nil
      
      closeButton?.removeFromSuperview()
      closeButton = nil
    }
  }
  
  private func rebuildScrollView() {
    scrollView = UIScrollView(frame: bounds)
    if let sV = scrollView {
      sV.delegate = self
      addSubview(sV)
    }
  }
  
  private func rebuildImageView() {
    guard let im = image else {
      return
    }
    
    imageView = UIImageView(image: im)
    imageView?.userInteractionEnabled = true
    if let iv = imageView {
      scrollView?.addSubview(iv)
      scrollView?.contentSize = im.size
    }
  }
  
  private func rebuildCloseButton() {
    guard let closeImage = UIImage(named: "close") else {
      return
    }
    let x = CGRectGetWidth(frame) - 50 - 20
    let closeButtonFrame = CGRectMake(x, 20, 50, 50)
    closeButton = UIButton(frame: closeButtonFrame)
    closeButton?.setImage(closeImage, forState: UIControlState.Normal)
    closeButton?.addTarget(self, action: #selector(didTapOnClose(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    if let cb = closeButton {
      addSubview(cb)
    }
  }
  
  private func configureGesture() {
    guard let iv = imageView else {
      return
    }
    if iv.gestureRecognizers?.count > 0 {
      return
    }
    
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(_:)))
    doubleTapRecognizer.numberOfTapsRequired = 2
    doubleTapRecognizer.numberOfTouchesRequired = 1
    imageView?.addGestureRecognizer(doubleTapRecognizer)
  }
  
  private func recalculateSizesAndLocation() {
    guard let iv = imageView else {
      return
    }
    guard let sv = scrollView else {
      return
    }
    
    sv.contentSize = iv.frame.size
    let scrollViewFrame = frame
    let scaleWidth = scrollViewFrame.size.width / sv.contentSize.width
    let scaleHeight = scrollViewFrame.size.height / sv.contentSize.height
    let minScale = min(scaleWidth, scaleHeight);
    sv.minimumZoomScale = minScale;
    
    let maxScale = max(scaleWidth, scaleHeight);
    sv.maximumZoomScale = max(maxScale, 2.0)
    sv.zoomScale = minScale;
    centerScrollViewContents()
  }
  
  // MARK: Actions
  
  func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
    guard let sv = scrollView else {
      return
    }
    
    if (sv.zoomScale > sv.minimumZoomScale) {
      sv.setZoomScale(sv.minimumZoomScale, animated: true)
      return
    }
    sv.setZoomScale(sv.maximumZoomScale, animated: true)
  }
  
  func didTapOnClose(sender: UIButton) {
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.alpha = 0.0
      }) { (success) -> Void in
        self.removeFromSuperview()
    }
  }
  
  // MARK: Tools
  
  private func centerScrollViewContents() {
    guard let iv = imageView else {
      return
    }
    
    let boundsSize = bounds.size
    var contentsFrame = iv.frame
    
    if contentsFrame.size.width < boundsSize.width {
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
    } else {
      contentsFrame.origin.x = 0.0
    }
    
    if contentsFrame.size.height < boundsSize.height {
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
    } else {
      contentsFrame.origin.y = 0.0
    }
    
    iv.frame = contentsFrame
  }
}

// MARK: UIScrollViewDelegate

extension ImageViewer: UIScrollViewDelegate {
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    centerScrollViewContents()
  }
}
