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
