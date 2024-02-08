//
//  QuizCoordinator.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

protocol QuizCoordinatorProtocol: Coordinator {
    func showStartScreen()
    func showQuizSessionScreen()
}

class QuizCoordinator: QuizCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .quiz
    
    private let tabBarItem: UITabBarItem
    
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
        let viewController = UIViewController()
        viewController.view.backgroundColor = .orange
        viewController.tabBarItem = tabBarItem
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showQuizSessionScreen() {
        
    }
}

