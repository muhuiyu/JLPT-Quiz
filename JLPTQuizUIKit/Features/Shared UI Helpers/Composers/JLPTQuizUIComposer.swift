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
    
    static func makeStartQuizComposedWith(coordinator: Coordinator) -> StartQuizViewController {
        let quizService = LocalQuizService()
        let viewModel = StartQuizViewModel(coordinator: coordinator, quizService: quizService)
        let viewController = StartQuizViewController(viewModel: viewModel)
        return viewController
    }
}
