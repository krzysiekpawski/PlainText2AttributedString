//
//  PagesWorker.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 18/02/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import Foundation

class PagesWorker {
  var pagesStore: PagesStoreProtocol
  
  init(pagesStore: PagesStoreProtocol) {
    self.pagesStore = pagesStore
  }
  
  func fetchPages(chapterId: UInt, completionHandler: (pages: [Page]) -> Void) {
    pagesStore.fetchPages(chapterId, completionHandler: { (pages, error) -> Void in
      if (error != nil) {
        completionHandler(pages: [])
        return
      }
      completionHandler(pages: pages)
    })
  }
  
  func fetchAllPages(completionHandler: (pages: [Page]) -> Void) {
    pagesStore.fetchAllPages { (pages, error) -> Void in
      if (error != nil) {
        completionHandler(pages: [])
        return
      }
      completionHandler(pages: pages)
    }
  }
  
  func fetchPage(id: UInt, completionHandler: (page: Page?) -> Void) {
    pagesStore.fetchPage(id) { (page, error) -> Void in
      if (error != nil) {
        completionHandler(page: nil)
        return
      }
      completionHandler(page: page)
    }
  }
  
  func createPage(chapterId: UInt, order: UInt, content: String, completionHandler: ((id: UInt?) -> Void)?) {
    let page = Page(id: 0, chapterId: chapterId, order: order, content: content)
    pagesStore.createPage(page, completionHandler: { (id, error) -> Void in
      if (completionHandler != nil) {
        completionHandler!(id: (error == nil) ? id : nil)
      }
    })
  }
  
  func updatePageContent(id: UInt, contentToSet: String, completionHandler: (success: Bool) -> Void) {
    pagesStore.fetchPage(id) { (page, error) -> Void in
      if (error != nil) {
        completionHandler(success: false)
        return
      }
      guard var pageToUpdate = page else {
        completionHandler(success: false)
        return
      }
      pageToUpdate.content = contentToSet
      self.pagesStore.updatePage(pageToUpdate, completionHandler: { (error) -> Void in
        completionHandler(success: (error == nil))
      })
    }
  }
  
  func pageIndex(id: UInt) -> UInt? {
    guard let pageIndex = pagesStore.page(id)?.order else {
      return nil
    }
    return pageIndex
  }
  
  func pageIndexAndChapterId(id: UInt) -> (UInt, UInt)? {
    guard let page = pagesStore.page(id) else {
      return nil
    }
    return (page.chapterId, page.order)
  }
}

// MARK: - Pages store API

protocol PagesStoreProtocol {
  // MARK: CRUD operations - Optional error
  
  func fetchPages(chapterId: UInt, completionHandler: (pages: [Page], error: PagesStoreError?) -> Void)
  func fetchAllPages(completionHandler: (pages: [Page], error: PagesStoreError?) -> Void)
  func fetchPage(id: UInt, completionHandler: (page: Page?, error: PagesStoreError?) -> Void)
  func createPage(pageToCreate: Page, completionHandler: (id: UInt?, error: PagesStoreError?) -> Void)
  func updatePage(pageToUpdate: Page, completionHandler: (error: PagesStoreError?) -> Void)
  func deletePage(id: UInt, completionHandler: (error: PagesStoreError?) -> Void)
  
  func page(id: UInt) -> Page?
}

// MARK: - Pages store CRUD operation errors

enum PagesStoreError: Equatable, ErrorType
{
  case CannotFetch(String)
  case CannotCreate(String)
  case CannotUpdate(String)
  case CannotDelete(String)
}

func ==(lhs: PagesStoreError, rhs: PagesStoreError) -> Bool
{
  switch (lhs, rhs) {
  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
  case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
  case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
  case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
  default: return false
  }
}
