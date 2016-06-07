//
//  PagesMemStore.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 18/02/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

final class PagesMemStore: PagesStoreProtocol {
  var pages = [Page]()
  
  init() {
    pages.append(Page(id: 0, chapterId: 34, order: 1, content: "At ##BOLD##vero eos et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum deleniti##BOLD## atque corrupti, quos dolores et quas molestias excepturi\n\n##BULLETLIST##- sint,\n- obcaecati cupiditate \n- non provident##BULLETLIST##\n\n, similique sunt in culpa, qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est ##UNDERLINE##eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae sint et molestiae non recusandae. Itaque##UNDERLINE## earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut ##URL##showChapter/first##perferendis doloribus##URL## asperiores repellat"))
    pages.append(Page(id: 1, chapterId: 40, order: 2, content: "##BOLD##At vero eos et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum deleniti atque corrupti, quos dolores et quas molestias excepturi sint, obcaecati cupiditate non provident, similique sunt in culpa, qui officia deserunt mollitia animi, id est laborum et dolorum fuga. "))
    pages.append(Page(id: 2, chapterId: 18, order: 3, content: "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere ##IMAGE##image##possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat"))
    pages.append(Page(id:3, chapterId: 58, order: 4, content: "Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat"))
  }
  
  // MARK: - CRUD operations - Optional error
  
  func fetchPages(chapterId: UInt, completionHandler: (pages: [Page], error: PagesStoreError?) -> Void) {
    completionHandler(pages: pages, error: nil)
  }
  
  func fetchAllPages(completionHandler: (pages: [Page], error: PagesStoreError?) -> Void) {
    completionHandler(pages: pages, error: nil)
  }
  
  func fetchPage(id: UInt, completionHandler: (page: Page?, error: PagesStoreError?) -> Void) {
    let page = pages.filter { (page: Page) -> Bool in
      return page.id == id
      }.first
    if let _ = page {
      completionHandler(page: page, error: nil)
    } else {
      completionHandler(page: nil, error: PagesStoreError.CannotFetch("Cannot fetch Page with id \(id)"))
    }
  }
  
  func createPage(page: Page, completionHandler: (id: UInt?, error: PagesStoreError?) -> Void) {
    pages.append(page)
    completionHandler(id: page.id, error: nil)
  }
  
  func updatePage(pageToUpdate: Page, completionHandler: (error: PagesStoreError?) -> Void) {
    for var page in pages {
      if page.id == pageToUpdate.id {
        page = pageToUpdate
        completionHandler(error: nil)
        return
      }
    }
    completionHandler(error: PagesStoreError.CannotUpdate("Cannot fetch Page with id \(pageToUpdate.id) to update"))
  }
  
  func deletePage(id: UInt, completionHandler: (error: PagesStoreError?) -> Void) {
    let index = pages.indexOf { (page: Page) -> Bool in
      return page.id == id
    }
    if let index = index {
      pages.removeAtIndex(index)
      completionHandler(error: nil)
      return
    }
    completionHandler(error: PagesStoreError.CannotDelete("Cannot fetch Page with id \(id) to delete"))
  }
  
  func page(id: UInt) -> Page? {
    let page = pages.filter { (page) -> Bool in
      return (page.id == id)
    }.first
    return page
  }
}
