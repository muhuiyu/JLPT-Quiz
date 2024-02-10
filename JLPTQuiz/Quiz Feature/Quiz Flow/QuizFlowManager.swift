//
//  QuizFlowManager.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/8/24.
//

import Foundation

public class QuizFlowManager {
    let service: QuizService
    
    public enum State: Equatable {
        case notStarted
        case showingQuiz(Quiz)
        case showingAnswer(Quiz)
        case ended
    }
    
    public struct SelectionResult {
        let selectedIndex: Int
        let isCorrect: Bool
        let currentScore: Int
        let optionStates: [QuizOptionState]
    }
    
    enum QuizOptionState {
        case notSelected, wronglySelected, correctAnswer
    }
    
    @Published public var currentState: State = .notStarted
    private var currentScore = 0
    public private(set) var currentIndex = 0
    private var quizList = [Quiz]()
    
    public init(service: QuizService) {
        self.service = service
    }
    
    enum Error: Swift.Error {
        case emptyQuizList
        case invalidAction
    }
    
    public func load() throws {
        let session = try service.generateSession(filter: nil)
        guard let firstQuestion = session.quizList.first else {
            throw Error.emptyQuizList
        }
        quizList = session.quizList
        currentState = .showingQuiz(firstQuestion)
    }
    
    public func didSelectOption(at selectedIndex: Int) throws -> SelectionResult {
        switch currentState {
        case .showingQuiz(let currentQuiz):
            let isCorrect = currentQuiz.answerIndex == selectedIndex
            updateCurrentScore(didUserChooseCorrectAnswer: isCorrect)
            let optionStates: [QuizOptionState] = currentQuiz.options.enumerated().map { index, option in
                if option.isAnswer {
                    return .correctAnswer
                } else {
                    return selectedIndex == index ? .wronglySelected : .notSelected
                }
            }
            currentState = .showingAnswer(currentQuiz)
            return SelectionResult(selectedIndex: selectedIndex, isCorrect: isCorrect, currentScore: currentScore, optionStates: optionStates)
        default:
            throw Error.invalidAction
        }
    }
    
    public func didTapNext() throws {
        switch currentState {
        case .showingAnswer(_):
            updateCurrentState()
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
            currentState = .ended
        }
    }
}

extension Quiz {
    var answerIndex: Int? {
        options.firstIndex(where: { $0.isAnswer })
    }
}
