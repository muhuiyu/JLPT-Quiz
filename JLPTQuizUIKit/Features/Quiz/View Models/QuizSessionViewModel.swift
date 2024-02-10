//
//  QuizSessionViewModel.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/9/24.
//

import JLPTQuiz

class QuizSessionViewModel: BaseViewModel {
    let quizFlowManager: QuizFlowManager
    
    private let config: QuizConfig
    
    init(quizFlowManager: QuizFlowManager, config: QuizConfig) {
        self.quizFlowManager = quizFlowManager
        self.config = config
    }
    
    func load() {
        do {
            try quizFlowManager.load()
        } catch {
            
        }
    }
    
    func didAnswerQuestion(with answerIndex: Int) {
        
    }
    
    func masterCurrentQuestion() {
        
    }
    
    func goToNextQuestion() {
        
    }
    
    func endCurrentSession() {
        
    }
}

extension QuizSessionViewModel {
    var currentQuiz: Quiz? {
        switch quizFlowManager.currentState {
        case .showingQuiz(let quiz), .showingAnswer(let quiz):
            return quiz
        default:
            return nil
        }
    }
    func getSoundFileName(when isCorrect: Bool) -> String {
        return isCorrect ? "correct" : "wrong"
    }
    
    func configureHeaderViewTitle() -> String {
        "\(Text.QuizSessionViewController.headerTitlePrefix) \(quizFlowManager.currentIndex + 1) / \(config.numberOfQuestions)"
    }
    var isShowingAnswer: Bool {
        switch quizFlowManager.currentState {
        case .showingAnswer(_):
            return true
        default:
            return false
        }
    }
    
    var isShowingQuiz: Bool {
        switch quizFlowManager.currentState {
        case .showingQuiz(_):
            return true
        default:
            return false
        }
    }
}
