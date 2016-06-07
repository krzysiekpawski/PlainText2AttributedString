//
//  ChaptersMemStore.swift
//  PlainText2AttributedString
//
//  Created by Krzysztof Pawski on 19/02/16.
//  Copyright © 2016 Krzysztof Pawski. All rights reserved.
//

import UIKit

final class ChaptersMemStore: ChaptersStoreProtocol {
  var chapters = [Chapter]()
  
  init() {
    chapters.append(Chapter(id: 1, parentId: Chapter.rootID, title: "RIBA STAGES", tagTitle: "TAG TITLE", subtitle: "Subtitle 0", chapterDescription: "Gives a broad overview of the key tasks an Architect is expected to undertake through the course of the project", colorRedValue: 253, colorGreenValue: 110, colorBlueValue: 110, hasSubchapters: true, type: 0))
  }
  
  // MARK: - CRUD operations - Optional error
  
  func fetchChapters(chapterType: UInt, completionHandler: (chapters: [Chapter], error: ChaptersStoreError?) -> Void) {
    var chs: [Chapter] = []
    for ch in chapters {
      if ch.parentId != Chapter.rootID {
        continue
      }
      
      if ch.type == chapterType {
        chs.append(ch)
      }
    }
    completionHandler(chapters: chs, error: nil)
  }
  
  func fetchTagChapters(completionHandler: (chapters: [Chapter], error: ChaptersStoreError?) -> Void) {
    var chs: [Chapter] = []
    for ch in chapters {
      if ch.parentId != Chapter.rootID {
        continue
      }
      
      chs.append(ch)
    }
    completionHandler(chapters: chs, error: nil)
  }
  
  func fetchSubchapters(parentId: UInt, completionHandler: (subchapters: [Chapter], error: ChaptersStoreError?) -> Void) {
    var subchapters: [Chapter] = []
    for ch in chapters {
      if ch.parentId == parentId {
        subchapters.append(ch)
      }
    }
    completionHandler(subchapters: subchapters, error: nil)
  }
  
  func fetchChapter(id: UInt, completionHandler: (chapter: Chapter?, error: ChaptersStoreError?) -> Void) {
    let chapter = chapters.filter { (chapter: Chapter) -> Bool in
      return chapter.id == id
      }.first
    if let _ = chapter {
      completionHandler(chapter: chapter, error: nil)
    } else {
      completionHandler(chapter: nil, error: ChaptersStoreError.CannotFetch("Cannot fetch Chapter with id \(id)"))
    }
  }
  
  func fetchLinkedChapter(linkId: String, completionHandler: (chapter: Chapter?, error: ChaptersStoreError?) -> Void) {
    completionHandler(chapter: chapters.first, error: nil)
  }
  
  func createChapter(chapter: Chapter, linkId: String?, completionHandler: (id: UInt?, error: ChaptersStoreError?) -> Void) {
    chapters.append(chapter)
    completionHandler(id: chapter.id, error: nil)
  }
  
  func updateChapter(chapterToUpdate: Chapter, completionHandler: (error: ChaptersStoreError?) -> Void) {
    for var chapter in chapters {
      if chapter.id == chapterToUpdate.id {
        chapter = chapterToUpdate
        completionHandler(error: nil)
        return
      }
    }
    completionHandler(error: ChaptersStoreError.CannotUpdate("Cannot fetch Chapter with id \(chapterToUpdate.id) to update"))
  }
  
  func deleteChapter(id: UInt, completionHandler: (error: ChaptersStoreError?) -> Void) {
    let index = chapters.indexOf { (chapter: Chapter) -> Bool in
      return chapter.id == id
    }
    if let index = index {
      chapters.removeAtIndex(index)
      completionHandler(error: nil)
      return
    }
    completionHandler(error: ChaptersStoreError.CannotDelete("Cannot fetch Chapter with id \(id) to delete"))
  }
  
  func fetchChapterTitle(id: UInt) -> String? {
    return chapters.filter { (chapter: Chapter) -> Bool in
      return chapter.id == id
      }.first?.title
  }
}
