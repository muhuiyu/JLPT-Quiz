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
    
    func didSelectOption(at answerIndex: Int) {
        do {
            _ = try quizFlowManager.didSelectOption(at: answerIndex)
        } catch {
            
        }
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
        case .showingQuiz(let quiz), .showingAnswer(let quiz, _):
            return quiz
        default:
            return nil
        }
    }
    
    var currentProgress: Double {
        return Double(quizFlowManager.currentIndex + 1) / Double(config.numberOfQuestions)
    }
    
    func getOptionCellState(at index: Int) -> OptionCell.State {
        switch quizFlowManager.currentState {
        case .showingAnswer(let quiz, let selectionResult):
            if index == quiz.answerIndex {
                return .correctAnswer
            } else if index == selectionResult.selectedIndex {
                return .selectedWrongly
            } else {
                return .unselected
            }
        default:
            return .unanswered
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
        case .showingAnswer:
            return true
        default:
            return false
        }
    }
    
    var isShowingQuiz: Bool {
        switch quizFlowManager.currentState {
        case .showingQuiz:
            return true
        default:
            return false
        }
    }
}

extension QuizFlowManager.QuizOptionState {
    func toOptionCellState() -> OptionCell.State {
        switch self {
        case .notSelected: return .unselected
        case .wronglySelected: return .selectedWrongly
        case .correctAnswer: return .correctAnswer
        }
    }
}
