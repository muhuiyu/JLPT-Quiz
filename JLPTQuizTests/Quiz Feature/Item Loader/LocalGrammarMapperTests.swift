//
//  LocalGrammarMapperTests.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

import XCTest
@testable import JLPTQuiz

class LocalGrammarMapperTests: XCTestCase {
    func test_map_throwsErrorOnInvalidJSONList() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try LocalGrammarMapper.map(invalidJSON)
        )
    }
    
    func test_map_deliversEmptyListOnEmptyJSONList() {
        let emptyListJSON = makeItemsJSON([])
        
        XCTAssertEqual(try LocalGrammarMapper.map(emptyListJSON), [])
    }
    
    func test_map_deliversItemWithJSONItems() {
        let item1 = makeGrammarItem(id: "grammar-1",
                                    title: "Grammar 1",
                                    formation: "formation 1",
                                    meaning: "meaning 1",
                                    examples: [
                                        "grammar 1 example 1",
                                        "grammar 1 example 2",
                                        "grammar 1 example 3"
                                    ], 
                                    relatedGrammarIDs: [
                                        "grammar 2"
                                    ],
                                    remark: "remark 1")
        
        let item2 = makeGrammarItem(id: "grammar-2",
                                    title: "Grammar 2",
                                    formation: "formation 2",
                                    meaning: "meaning 2",
                                    examples: [
                                        "grammar 2 example 1",
                                        "grammar 2 example 2"
                                    ],
                                    relatedGrammarIDs: [],
                                    remark: "remark 2")
        
        let item3 = makeGrammarItem(id: "grammar-3",
                                    title: "Grammar 3",
                                    formation: "formation 3",
                                    meaning: "meaning 3",
                                    examples: [
                                        "grammar 3 example 1",
                                        "grammar 3 example 2",
                                        "grammar 3 example 3"
                                    ], 
                                    relatedGrammarIDs: [
                                        "grammar 4",
                                        "grammar 5"
                                    ],
                                    remark: "remark 3")
        
        let json1 = makeItemsJSON([item1.json, item2.json, item3.json])
        XCTAssertEqual(try LocalGrammarMapper.map(json1), [item1.model, item2.model, item3.model])
    }
}
