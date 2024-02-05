//
//  LocalQuizMapperTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/5/24.
//

import XCTest
@testable import JLPTQuiz

class LocalQuizMapperTests: XCTestCase {
    func test_map_throwsErrorOnInvalidJSONList() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try LocalQuizMapper.map(invalidJSON)
        )
    }
    
    func test_map_deliversEmptyListOnEmptyJSONList() {
        let emptyListJSON = makeItemsJSON([])
        
        XCTAssertEqual(try LocalQuizMapper.map(emptyListJSON), [])
    }
    
    func test_map_deliversItemWithJSONItems() {
        let item1 = makeItem(id: "id-1", 
                             type: .grammar,
                             level: .n1,
                             question: "question-1",
                             options: [
                                OptionEntry(value: "question-1/option-1", linkedEntryID: "linkedEntryID-1", isAnswer: true)
                             ])
        
        let item2 = makeItem(id: "id-2",
                             type: .kanji,
                             level: .n2,
                             question: "question-2",
                             options: [
                                OptionEntry(value: "question-2/option-1", linkedEntryID: "linkedEntryID-2", isAnswer: true),
                                OptionEntry(value: "question-2/option-3", linkedEntryID: "linkedEntryID-3", isAnswer: false)
                             ])
        
        let item3 = makeItem(id: "id-3",
                             type: .vocab,
                             level: .n5,
                             question: "question-4",
                             options: [
                                OptionEntry(value: "question-3/option-1", linkedEntryID: "linkedEntryID-4", isAnswer: true),
                                OptionEntry(value: "question-3/option-2", linkedEntryID: "linkedEntryID-5", isAnswer: false),
                                OptionEntry(value: "question-3/option-3", linkedEntryID: "linkedEntryID-6", isAnswer: true)
                             ])
        
        let json1 = makeItemsJSON([item1.json, item2.json, item3.json])
        XCTAssertEqual(try LocalQuizMapper.map(json1), [item1.model, item2.model, item3.model])
    }
}

extension LocalQuizMapperTests {
    private func makeItem(
        id: String = "any id",
        type: QuizType = .grammar,
        level: QuizLevel = .n1,
        question: String = "any question",
        options: [OptionEntry] = []
    ) -> (model: Quiz, json: [String: Any]) {
        let model = Quiz(
            id: id,
            type: type,
            level: level,
            question: question,
            options: options
        )
        let json = [
            "id": id,
            "type": type.rawValue,
            "level": level.rawValue,
            "question": question,
            "options": options.map { makeOptionJSON($0) }
        ].compactMapValues { $0 }
        
        return (model, json)
    }
    
    private func makeOptionJSON(_ option: OptionEntry) -> [String: Any] {
        return [
            "value": option.value,
            "linkedEntryId": option.linkedEntryID,
            "isAnswer": option.isAnswer
        ]
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
