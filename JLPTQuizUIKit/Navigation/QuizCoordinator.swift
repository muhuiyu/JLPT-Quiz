//
//  QuizCoordinator.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import JLPTQuiz

protocol QuizCoordinatorProtocol: Coordinator {
    func showStartScreen()
    func showQuizSessionScreen(with config: QuizConfig)
}

class QuizCoordinator: QuizCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .quiz
    
    private let tabBarItem: UITabBarItem
    private let quizService = LocalQuizService()
    
    required init(
        _ navigationController: UINavigationController,
        tabBarItem: UITabBarItem
    ) {
        self.navigationController = navigationController
        self.tabBarItem = tabBarItem
    }
    
    func start() {
        showStartScreen()
    }
    
    func showStartScreen() {
        let viewController = JLPTQuizUIComposer.makeStartQuizComposed(with: quizService,
                                                                      startQuizHandler: { [weak self] config in
            self?.showQuizSessionScreen(with: config)
        })
        viewController.tabBarItem = tabBarItem
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showQuizSessionScreen(with config: QuizConfig) {
        let (coordinator, navigationController) = CoordinatorFactory.makeSessionCoordinator(quizService: quizService, quizConfig: config)
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        self.navigationController.present(navigationController, animated: true)
        coordinator.start()
    }
}

extension QuizCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
    }
}
