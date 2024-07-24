//
//  LocalVocabMapperTests.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

import XCTest
@testable import JLPTQuiz

class LocalVocabMapperTests: XCTestCase {
    func test_map_throwsErrorOnInvalidJSONList() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try LocalVocabMapper.map(invalidJSON)
        )
    }
    
    func test_map_deliversEmptyListOnEmptyJSONList() {
        let emptyListJSON = makeItemsJSON([])
        
        XCTAssertEqual(try LocalVocabMapper.map(emptyListJSON), [])
    }
    
    func test_map_deliversItemWithJSONItems() {
        let item1 = makeVocabItem(id: "vocab-1", word: "Vocab 1", reading: "reading 1", meaning: "meaning 1")
        let item2 = makeVocabItem(id: "vocab-2", word: "Vocab 2", reading: "reading 2", meaning: "meaning 2")
        let item3 = makeVocabItem(id: "vocab-3", word: "Vocab 3", reading: "reading 3", meaning: "meaning 3")
        
        let json1 = makeItemsJSON([item1.json, item2.json, item3.json])
        XCTAssertEqual(try LocalVocabMapper.map(json1), [item1.model, item2.model, item3.model])
    }
}
