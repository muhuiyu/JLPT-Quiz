//
//  SessionCoordinator.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/29/24.
//

import UIKit
import JLPTQuiz

protocol EntryDetailCoordinating {
    func showEntryDetailsScreen(for id: String, as type: QuizType)
}

protocol SessionCoordinatorProtocol: Coordinator {
    func showQuizSessionScreen(with config: QuizConfig)
}

class SessionCoordinator: SessionCoordinatorProtocol, EntryDetailCoordinating {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .session
    
    private let quizService: QuizService
    private let config: QuizConfig
    
    required init(_ navigationController: UINavigationController, quizService: QuizService, config: QuizConfig) {
        self.navigationController = navigationController
        self.quizService = quizService
        self.config = config
    }
    
    func start() {
        showQuizSessionScreen(with: config)
    }
    
    func showQuizSessionScreen(with config: QuizConfig) {
        let viewController = JLPTQuizUIComposer.makeQuizSessionComposed(with: self, quizService, config)
        navigationController.viewControllers = [viewController]
    }
    
    func showEntryDetailsScreen(for id: String, as type: QuizType) {
        let viewController = JLPTQuizUIComposer.makeEntryDetailsComposed(with: quizService, for: id, as: type)
        navigationController.pushViewController(viewController, animated: true)
    }
}
