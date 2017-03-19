//
//  SearchHistoryManager.swift
//  CS193pSmashtag
//
//  Created by zzk on 2017/3/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct SearchTerm {
    var keyword: String
}

class SearchHistoryManager {

    static let shared = SearchHistoryManager()
    
    private var searchTerms: [SearchTerm]
    
    private init() {
        self.searchTerms = (UserDefaults.standard.array(forKey: "Search Terms") as? [String] ?? [String]()).map({SearchTerm(keyword: $0)})
    }
    
    func getRecent(count: Int) -> [SearchTerm] {
        return Array(searchTerms[0..<min(count, searchTerms.count)])
    }
    
    private func save() {
        UserDefaults.standard.set(searchTerms.map({$0.keyword}), forKey: "Search Terms")
    }
    
    func insert(_ term: SearchTerm) {
        if let index = searchTerms.index(where: { $0.keyword.lowercased() == term.keyword.lowercased() }) {
            searchTerms.remove(at: index)
        }
        searchTerms.insert(term, at: 0)
        if searchTerms.count > 100 {
            searchTerms.removeLast()
        }
        save()
    }
    
}
