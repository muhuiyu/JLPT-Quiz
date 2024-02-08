//
//  QuizFlowManager.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/8/24.
//

import Foundation

class QuizFlowManager {
    let service: QuizService
    
    enum State: Equatable {
        case notStarted
        case showingQuiz(Quiz)
        case finished
    }
    
    struct SelectionResult {
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
    
    func didSelectAnswer(at answerIndex: Int) throws -> SelectionResult {
        switch currentState {
        case .showingQuiz(let currentQuiz):
            let isCorrect = currentQuiz.answerIndex == answerIndex
            updateCurrentScore(didUserChooseCorrectAnswer: isCorrect)
            let result = SelectionResult(isCorrect: isCorrect, currentScore: currentScore)
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
