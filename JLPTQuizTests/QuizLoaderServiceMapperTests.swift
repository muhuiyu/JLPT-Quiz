//
//  QuizLoaderServiceMapperTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/5/24.
//

import XCTest
@testable import JLPTQuiz

class QuizLoaderServiceMapperTests: XCTestCase {
    func test_load_deliversEmptyResultOnEmptyJSON() {
        let sut = makeSUT()
        let session = sut.generateSession()
        XCTAssertTrue(session.quizList.isEmpty, "")
    }
}

extension QuizLoaderServiceMapperTests {
    private func makeSUT() -> LocalQuizLoaderService {
        return LocalQuizLoaderService()
    }
}
