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
            switch flowManager.currentState {
            case .showingQuiz(let receivedQuiz):
                XCTAssertEqual(receivedQuiz, quiz1.model, "Expected current quiz to be the same as the first quiz in list")
            default:
                XCTFail("Expected showing quiz, received \(flowManager.currentState) instead")
            }
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_returnCorrectResult_whenSelectingCorrectAnswer() {
        let flowManager = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try flowManager.load()
            let result = try flowManager.didSelectAnswer(at: 0)
            XCTAssertTrue(result.isCorrect, "Expected to received correct when selecting correct answer")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_returnWrongResult_whenSelectingWrongAnswer() {
        let flowManager = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try flowManager.load()
            let result = try flowManager.didSelectAnswer(at: 1)
            XCTAssertFalse(result.isCorrect, "Expected to received wrong when selecting wrong answer")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
}

extension QuizFlowManagerTests {
    private func makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect() -> QuizFlowManager {
        let correctOption = OptionEntry(value: "correct option", linkedEntryID: "id-1", isAnswer: true)
        let wrongOption = OptionEntry(value: "wrong option", linkedEntryID: "id-2", isAnswer: false)
        let quiz1 = makeQuizItem(id: "id-1", options: [correctOption, wrongOption])
        let quiz2 = makeQuizItem(id: "id-2", options: [correctOption, wrongOption])
        let service = FakeQuizService(quizList: [quiz1.model, quiz2.model])
        let flowManager = QuizFlowManager(service: service)
        return flowManager
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
    
    enum State {
        case notStarted
        case showingQuiz(Quiz)
        case finished
    }
    
    struct AnswerResult {
        let isCorrect: Bool
    }
    
    @Published var currentState: State = .notStarted
    private var currentIndex = 0
    private var quizList = [Quiz]()
    
    init(service: QuizService) {
        self.service = service
    }
    
    enum Error: Swift.Error {
        case emptyQuizList
        case invalidAction
    }
    
    func load() throws {
        let session = try service.generateSession(filter: nil)
        guard let firstQuestion = session.quizList.first else {
            throw Error.emptyQuizList
        }
        quizList = session.quizList
        currentState = .showingQuiz(firstQuestion)
    }
    
    func didSelectAnswer(at answerIndex: Int) throws -> AnswerResult {
        switch currentState {
        case .showingQuiz(let currentQuiz):
            let correctIndex = currentQuiz.options.firstIndex(where: { $0.isAnswer })
            let result = AnswerResult(isCorrect: correctIndex == answerIndex)
            if currentIndex < quizList.count - 1 {
                currentIndex += 1
                currentState = .showingQuiz(quizList[currentIndex])
            } else {
                currentState = .finished
            }
            return result
        default:
            throw Error.invalidAction
        }
    }
}

