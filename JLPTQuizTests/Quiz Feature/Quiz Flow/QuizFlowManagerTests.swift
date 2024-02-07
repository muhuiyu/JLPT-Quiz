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

