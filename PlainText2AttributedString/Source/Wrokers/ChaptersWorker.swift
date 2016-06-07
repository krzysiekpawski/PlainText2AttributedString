//
//  ChaptersWorker
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 19/02/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

class ChaptersWorker: NSObject {
  var chaptersStore: ChaptersStoreProtocol
  
  init(chaptersStore: ChaptersStoreProtocol) {
    self.chaptersStore = chaptersStore
  }
  
  func fetchChapter(id: UInt, completionHandler: (chapter: Chapter?) -> Void) {
    chaptersStore.fetchChapter(id) { (chapter, error) -> Void in
      if (error != nil) {
        completionHandler(chapter: nil)
        return
      }
      completionHandler(chapter: chapter)
    }
  }
  
  func fetchTopChapters(chapterType: UInt, completionHandler: (chapters: [Chapter]) -> Void) {
    chaptersStore.fetchChapters(chapterType) { (chapters, error) -> Void in
      if (error != nil) {
        completionHandler(chapters: [])
        return
      }
      completionHandler(chapters: chapters)
    }
  }
  
  func fetchTagChapters(completionHandler: (chapters: [Chapter]) -> Void) {
    chaptersStore.fetchTagChapters { (chapters, error) -> Void in
      if (error != nil) {
        completionHandler(chapters: [])
        return
      }
      completionHandler(chapters: chapters)
    }
  }
  
  func fetchSubchapters(parentId: UInt, completionHandler: (chapters: [Chapter]) -> Void) {
    chaptersStore.fetchSubchapters(parentId) { (subchapters, error) -> Void in
      if (error != nil) {
        completionHandler(chapters: [])
        return
      }
      completionHandler(chapters: subchapters)
    }
  }
  
  func fetchLinkedChapter(linkId: String, completionHandler: (chapter: Chapter?) -> Void) {
    chaptersStore.fetchLinkedChapter(linkId) { (chapter, error) -> Void in
      if (error != nil) {
        completionHandler(chapter: nil)
        return
      }
      completionHandler(chapter: chapter)
    }
  }
  
  func getLinkedChapterDetails(id: UInt, completionHandler: (depthLevel: UInt?, colors: [Int]?) -> Void) {
    getLinkedChapterDetails(id, depthLevel: 2, completionHandler: completionHandler)
  }
  
  func createChapter(parentId: UInt, title: String, tagTitle: String?, subtitle: String?, chapterDescription: String?, colorRedValue: Int?, colorGreenValue: Int?, colorBlueValue: Int?, hasSubchapters: Bool, type: UInt, linkId: String?, completionHandler: (id: UInt?) -> Void) {
    let chapter = Chapter(id: 0, parentId: parentId, title: title, tagTitle: tagTitle, subtitle: subtitle, chapterDescription: chapterDescription, colorRedValue: colorRedValue, colorGreenValue: colorGreenValue, colorBlueValue: colorBlueValue, hasSubchapters: hasSubchapters, type: type)
    chaptersStore.createChapter(chapter, linkId: linkId) { (id, error) -> Void in
      completionHandler(id: (error == nil) ? id : nil)
    }
  }
  
  func chapterTitle(chapterId chapterId: UInt) -> String {
    return chaptersStore.fetchChapterTitle(chapterId) ?? ""
  }
  
  // MARK: Private functions
  
  private func getLinkedChapterDetails(id: UInt, depthLevel: UInt, completionHandler: (depthLevel: UInt?, colors: [Int]?) -> Void) {
    chaptersStore.fetchChapter(id) { (chapterOpt, error) -> Void in
      guard let chapter = chapterOpt else {
        completionHandler(depthLevel: nil, colors: nil)
        return
      }
      
      if (chapter.parentId > 0) {
        self.getLinkedChapterDetails(chapter.parentId, depthLevel: (depthLevel + 1), completionHandler: completionHandler)
        return
      }
      
      if ((chapter.colorBlueValue == nil) || (chapter.colorGreenValue == nil) || (chapter.colorRedValue == nil)) {
        completionHandler(depthLevel: nil, colors: nil)
        return
      }
      
      let colors = [chapter.colorRedValue!, chapter.colorGreenValue!, chapter.colorBlueValue!]
      completionHandler(depthLevel: depthLevel, colors: colors)
    }
  }
}

// MARK: - Chapters store API

protocol ChaptersStoreProtocol {
  // MARK: CRUD operations - Optional error
  
  func fetchChapters(chapterType: UInt, completionHandler: (chapters: [Chapter], error: ChaptersStoreError?) -> Void)
  func fetchTagChapters(completionHandler: (chapters: [Chapter], error: ChaptersStoreError?) -> Void)
  func fetchSubchapters(parentId: UInt, completionHandler: (subchapters: [Chapter], error: ChaptersStoreError?) -> Void)
  func fetchChapter(id: UInt, completionHandler: (chapter: Chapter?, error: ChaptersStoreError?) -> Void)
  func fetchLinkedChapter(linkId: String, completionHandler: (chapter: Chapter?, error: ChaptersStoreError?) -> Void)
  func createChapter(chapterToCreate: Chapter, linkId: String?, completionHandler: (id: UInt?, error: ChaptersStoreError?) -> Void)
  func updateChapter(chapterToUpdate: Chapter, completionHandler: (error: ChaptersStoreError?) -> Void)
  func deleteChapter(id: UInt, completionHandler: (error: ChaptersStoreError?) -> Void)
  
  func fetchChapterTitle(id: UInt) -> String?
}

// MARK: - Chapters store CRUD operation errors

enum ChaptersStoreError: Equatable, ErrorType
{
  case CannotFetch(String)
  case CannotCreate(String)
  case CannotUpdate(String)
  case CannotDelete(String)
}

func ==(lhs: ChaptersStoreError, rhs: ChaptersStoreError) -> Bool
{
  switch (lhs, rhs) {
  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
  case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
  case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
  case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
  default: return false
  }
}
