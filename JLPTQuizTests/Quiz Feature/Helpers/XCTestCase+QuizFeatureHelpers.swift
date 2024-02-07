//
//  XCTestCase+QuizFeatureHelpers.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/7/24.
//

import XCTest
@testable import JLPTQuiz

extension XCTestCase {
    func makeQuizItem(
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
    
    func makeOptionJSON(_ option: OptionEntry) -> [String: Any] {
        return [
            "value": option.value,
            "linkedEntry": option.linkedEntryID,
            "isAnswer": option.isAnswer
        ]
    }
    
    func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
