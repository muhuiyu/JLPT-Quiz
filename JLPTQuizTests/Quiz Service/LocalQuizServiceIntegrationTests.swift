//
//  LocalQuizServiceIntegrationTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/5/24.
//

import XCTest
@testable import JLPTQuiz

final class LocalQuizServiceIntegrationTests: XCTestCase {
    
    func test_generateSession_deliversItems() {
        let sut = makeSUT()
        
        do {
            let session = try sut.generateSession()
            XCTAssertEqual(session.quizList.count, 3)
            XCTAssertEqual(session.quizList[0], expectedItem(at: 0))
            XCTAssertEqual(session.quizList[1], expectedItem(at: 1))
            XCTAssertEqual(session.quizList[2], expectedItem(at: 2))
        } catch {
            XCTFail("Expected to load quizzes successfully, received \(error) instead")
        }
    }
    
    func test_generateSession_deliversFilteredItems() {
        let sut = makeSUT()
        
        do {
            let session = try sut.generateSession(filter: QuizFilter(level: .n1, type: .grammar))
            XCTAssertEqual(session.quizList.count, 1)
            XCTAssertEqual(session.quizList[0], expectedItem(at: 0))
        } catch {
            XCTFail("Expected to load filtered quizzes, received \(error) instead")
        }
    }
}

extension LocalQuizServiceIntegrationTests {
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LocalQuizService {
        let sut = LocalQuizService(jsonFileName: "localQuizServiceIntegrationTests-quizzes")
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func expectedItem(at index: Int) -> Quiz {
        return Quiz(
            id: id(at: index),
            type: type(at: index),
            level: level(at: index),
            question: question(at: index),
            options: options(at: index)
        )
    }
    
    private func id(at index: Int) -> String {
        return ["id-1", "id-2", "id-3"][index]
    }
    
    private func type(at index: Int) -> QuizType {
        return [.grammar, .kanji, .vocab][index]
    }
    
    private func level(at index: Int) -> QuizLevel {
        return [.n1, .n3, .n5][index]
    }
    
    private func question(at index: Int) -> String {
        return ["question-1", "question-2", "question-3"][index]
    }
    
    private func options(at index: Int) -> [OptionEntry] {
        return [
            [
                OptionEntry(value: "question-1/option-1", linkedEntryID: "linkedEntry-1", isAnswer: true)
            ],
            [
                OptionEntry(value: "question-2/option-1", linkedEntryID: "linkedEntry-2", isAnswer: true),
                OptionEntry(value: "question-2/option-2", linkedEntryID: "linkedEntry-3", isAnswer: false)
            ],
            [
                OptionEntry(value: "question-3/option-1", linkedEntryID: "linkedEntry-4", isAnswer: true),
                OptionEntry(value: "question-3/option-2", linkedEntryID: "linkedEntry-5", isAnswer: false),
                OptionEntry(value: "question-3/option-3", linkedEntryID: "linkedEntry-6", isAnswer: true)
            ]
        ][index]
    }
}
