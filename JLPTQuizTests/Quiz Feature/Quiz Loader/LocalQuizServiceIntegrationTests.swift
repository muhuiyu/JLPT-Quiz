//
//  LocalQuizServiceIntegrationTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/5/24.
//

import XCTest
@testable import JLPTQuiz

final class LocalQuizServiceIntegrationTests: XCTestCase {
    
    func test_generateSession_deliversAllItems() {
        let sut = makeSUT()
        
        do {
            let session = try sut.generateSession()
            XCTAssertEqual(session.quizList.count, 30)
            for i in 0..<30 {
                XCTAssertEqual(session.quizList[i], expectedItem(at: i))
            }
        } catch {
            XCTFail("Expected to load quizzes successfully, received \(error) instead")
        }
    }
    
    func test_generateSession_deliversFilteredItemsWhenFiltering() {
        let sut = makeSUT()
        let filter = QuizConfig(numberOfQuestions: 2, level: .n1, type: .grammar)
        
        do {
            let session = try sut.generateSession(filteredBy: filter)
            let sortedResult = session.quizList.sorted { $0.id < $1.id }
            XCTAssertEqual(session.quizList.count, 2)
            XCTAssertEqual(sortedResult[0], expectedItem(at: 0))
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
        return "id-\(index + 1)"
    }
    
    private func type(at index: Int) -> QuizType {
        if index < 10 {
            return .grammar
        } else if index < 20 {
            return .kanji
        } else {
            return .vocab
        }
    }
    
    private func level(at index: Int) -> QuizLevel {
        switch index % 10 {
        case 0, 1: return .n1
        case 2, 3: return .n2
        case 4, 5: return .n3
        case 6, 7: return .n4
        case 8, 9: return .n5
        default:
            fatalError("Invalid result: index % 10 should be in the range 0..<10")
        }
    }
    
    private func question(at index: Int) -> String {
        return "question-\(index + 1)"
    }
    
    private func options(at index: Int) -> [QuizOptionEntry] {
        return [
            QuizOptionEntry(wording: "question-\(index + 1)/option-1", linkedEntryID: "linkedEntry-1", isAnswer: true),
            QuizOptionEntry(wording: "question-\(index + 1)/option-2", linkedEntryID: "linkedEntry-2", isAnswer: false),
        ]
    }
}
