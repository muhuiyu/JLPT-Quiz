//
//  QuizFlowManagerTests.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/7/24.
//

import XCTest
@testable import JLPTQuiz

final class QuizFlowManagerTests: XCTestCase {
    func test_load_emptyListThrowsError() {
        let service = FakeQuizService(quizList: [])
        let flowManager = QuizFlowManager(service: service)
        
        XCTAssertThrowsError(
            try flowManager.load()
        )
    }
    
    func test_load_setsCurrentQuizAsTheFirstQuizInListAfterLoading() {
        let quiz1 = makeQuizItem(id: "id-1")
        let quiz2 = makeQuizItem(id: "id-2")
        let service = FakeQuizService(quizList: [quiz1.model, quiz2.model])
        let flowManager = QuizFlowManager(service: service)
        
        do {
            try flowManager.load()
            XCTAssertEqual(flowManager.currentQuiz, quiz1.model, "Expected current quiz to be the same as the first quiz in list")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
}

class FakeQuizService: QuizService {
    
    private let quizList: [Quiz]
    
    init(quizList: [Quiz]) {
        self.quizList = quizList
    }
    
    func generateSession(filter: JLPTQuiz.QuizFilter?) throws -> JLPTQuiz.Session {
        return Session(quizList: quizList)
    }
}

class QuizFlowManager {
    let service: QuizService
    
    @Published var currentQuiz: Quiz?
    private var quizList = [Quiz]()
    
    init(service: QuizService) {
        self.service = service
    }
    
    enum Error: Swift.Error {
        case emptyQuizList
    }
    
    func load() throws {
        let session = try service.generateSession(filter: nil)
        guard !session.quizList.isEmpty else {
            throw Error.emptyQuizList
        }
        quizList = session.quizList
        currentQuiz = quizList.first
    }
}

