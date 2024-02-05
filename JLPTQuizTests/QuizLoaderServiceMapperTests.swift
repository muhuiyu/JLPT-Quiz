//
//  QuizLoaderServiceMapperTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/5/24.
//

import XCTest
@testable import JLPTQuiz

class QuizLoaderServiceMapperTests: XCTestCase {
    func test_map_throwsErrorOnInvalidJSONList() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try LocalQuizMapper.map(invalidJSON)
        )
    }
}
