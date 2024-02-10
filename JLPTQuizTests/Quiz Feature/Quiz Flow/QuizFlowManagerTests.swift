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
    
    func test_selectAnswer_showAnswer_afterSelectingAnswer() {
        let (sut, quiz) = makeSUTSetupWithOneQuestionTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            _ = try sut.didSelectOption(at: 0)
            switch sut.currentState {
            case .showingAnswer(let receivedQuiz):
                XCTAssertEqual(receivedQuiz, quiz)
            default:
                XCTFail("Expected showing answer for quiz1, received \(sut.currentState) instead")
            }
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_returnCorrectResult_whenSelectingCorrectAnswer() {
        let (sut, _, _) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let result = try sut.didSelectOption(at: 0)
            XCTAssertTrue(result.isCorrect, "Expected to receive correct when selecting correct answer")
            XCTAssertEqual(result.currentScore, 1, "Expected score to be 1, received \(result.currentScore) instead")
            XCTAssertEqual(result.optionStates, [.correctAnswer, .notSelected], "Expected given option results, received \(result.optionStates) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_returnWrongResult_whenSelectingWrongAnswer() {
        let (sut, _, _) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let result = try sut.didSelectOption(at: 1)
            XCTAssertFalse(result.isCorrect, "Expected to receive wrong when selecting wrong answer")
            XCTAssertEqual(result.currentScore, 0, "Expected score to be 0, received \(result.currentScore) instead")
            XCTAssertEqual(result.optionStates, [.correctAnswer, .wronglySelected], "Expected given option results, received \(result.optionStates) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
    
    func test_selectAnswer_shouldMoveToNextQuestionAfterAnswering_whenItIsNotTheLastQuiz() {
        let (sut, _, quiz2) = makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect()
        
        do {
            try sut.load()
            let _ = try sut.didSelectOption(at: 0)
            try sut.didTapNext()
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
            let _ = try sut.didSelectOption(at: 0)
            try sut.didTapNext()
            XCTAssertEqual(sut.currentState, .ended, "Expected to finish quiz, received \(sut.currentState) instead")
        } catch {
            XCTFail("Expected success, received \(error) instead")
        }
    }
}
