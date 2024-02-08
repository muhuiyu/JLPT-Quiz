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
    
    static func makeStartQuizComposedWith(startQuizHandler: @escaping (QuizConfig) -> Void) -> StartQuizViewController {
        let quizService = LocalQuizService()
        let viewModel = StartQuizViewModel(quizService: quizService)
        let viewController = StartQuizViewController(viewModel: viewModel)
        viewModel.startQuizHandler = startQuizHandler
        return viewController
    }
}
