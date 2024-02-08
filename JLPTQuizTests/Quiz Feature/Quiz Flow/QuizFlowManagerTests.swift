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
        let (sut, _, _) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let result = try sut.didSelectAnswer(at: 0)
            XCTAssertTrue(result.isCorrect, "Expected to receive correct when selecting correct answer")
            XCTAssertEqual(result.currentScore, 1, "Expected score to be 1, received \(result.currentScore) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_returnWrongResult_whenSelectingWrongAnswer() {
        let (sut, _, _) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let result = try sut.didSelectAnswer(at: 1)
            XCTAssertFalse(result.isCorrect, "Expected to receive wrong when selecting wrong answer")
            XCTAssertEqual(result.currentScore, 0, "Expected score to be 0, received \(result.currentScore) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_shouldMoveToNextQuestionAfterAnswering_whenItIsNotTheLastQuiz() {
        let (sut, _, quiz2) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let _ = try sut.didSelectAnswer(at: 0)
            switch sut.currentState {
            case .showingQuiz(let receivedQuiz):
                XCTAssertEqual(receivedQuiz, quiz2, "Expected current quiz to be the second quiz")
            default:
                XCTFail("Expected showing quiz, received \(sut.currentState) instead")
            }
            
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_shouldEndSession_whenItIsTheLastQuiz() {
        let (sut, _) = makeSUTSetupWithOneQuestionTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let _ = try sut.didSelectAnswer(at: 0)
            XCTAssertEqual(sut.currentState, .finished, "Expected to finish quiz, received \(sut.currentState) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
}

extension QuizFlowManagerTests {
    private func makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect() -> (sut: QuizFlowManager, quiz1: Quiz, quiz2: Quiz) {
        let correctOption = OptionEntry(value: "correct option", linkedEntryID: "id-1", isAnswer: true)
        let wrongOption = OptionEntry(value: "wrong option", linkedEntryID: "id-2", isAnswer: false)
        let quiz1 = makeQuizItem(id: "id-1", options: [correctOption, wrongOption])
        let quiz2 = makeQuizItem(id: "id-2", options: [correctOption, wrongOption])
        let service = FakeQuizService(quizList: [quiz1.model, quiz2.model])
        let flowManager = QuizFlowManager(service: service)
        return (flowManager, quiz1.model, quiz2.model)
    }
    
    private func makeSUTSetupWithOneQuestionTwoOptionsAndFirstOptionIsCorrect() -> (sut: QuizFlowManager, quiz: Quiz) {
        let correctOption = OptionEntry(value: "correct option", linkedEntryID: "id-1", isAnswer: true)
        let wrongOption = OptionEntry(value: "wrong option", linkedEntryID: "id-2", isAnswer: false)
        let quiz = makeQuizItem(id: "id-1", options: [correctOption, wrongOption])
        let service = FakeQuizService(quizList: [quiz.model])
        let flowManager = QuizFlowManager(service: service)
        return (flowManager, quiz.model)
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
    
    enum State: Equatable {
        case notStarted
        case showingQuiz(Quiz)
        case finished
    }
    
    struct AnswerResult {
        let isCorrect: Bool
        let currentScore: Int
    }
    
    @Published var currentState: State = .notStarted
    private var currentScore = 0
    private(set) var currentIndex = 0
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
            let isCorrect = currentQuiz.answerIndex == answerIndex
            updateCurrentScore(didUserChooseCorrectAnswer: isCorrect)
            let result = AnswerResult(isCorrect: isCorrect, currentScore: currentScore)
            updateCurrentState()
            return result
        default:
            throw Error.invalidAction
        }
    }
    
    private func updateCurrentScore(didUserChooseCorrectAnswer isCorrect: Bool) {
        if isCorrect {
            currentScore += 1
        }
    }
    
    private func updateCurrentState() {
        if currentIndex < quizList.count - 1 {
            currentIndex += 1
            currentState = .showingQuiz(quizList[currentIndex])
        } else {
            currentState = .finished
        }
    }
}

extension Quiz {
    var answerIndex: Int? {
        options.firstIndex(where: { $0.isAnswer })
    }
}
