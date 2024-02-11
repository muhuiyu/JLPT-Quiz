//
//  JLPTQuizUIComposer.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import JLPTQuiz

final class JLPTQuizUIComposer {
    private init() {}
    
    static func makeStartQuizComposed(with quizService: QuizService,
                                      startQuizHandler: @escaping (QuizConfig) -> Void) -> StartQuizViewController {
        let viewModel = StartQuizViewModel(quizService: quizService)
        let viewController = StartQuizViewController(viewModel: viewModel)
        viewModel.startQuizHandler = startQuizHandler
        return viewController
    }
    
    static func makeQuizSessionComposed(with quizService: QuizService,
                                        _ config: QuizConfig) -> QuizSessionViewController {
        let quizFlowManager = QuizFlowManager(service: quizService)
        let viewModel = QuizSessionViewModel(quizFlowManager: quizFlowManager, config: config)
        let viewController = QuizSessionViewController(viewModel: viewModel)
        viewController.isModalInPresentation = true
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
