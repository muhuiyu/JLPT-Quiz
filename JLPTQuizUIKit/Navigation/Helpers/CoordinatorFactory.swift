//
//  CoordinatorFactory.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

class CoordinatorFactory {
    static func makeAppCoordinator() -> (coordinator: AppCoordinator, navigationController: UINavigationController) {
        let navigationController = UINavigationController()
        let tabCoordinator = TabCoordinator(navigationController)
        return (AppCoordinator(navigationController, tabCoordinator: tabCoordinator), navigationController)
    }
    
    static func makeQuizCoordinator(tabBarItem: UITabBarItem) -> (coordinator: QuizCoordinator, navigationController: UINavigationController) {
        let navigationController = UINavigationController()
        let coordinator = QuizCoordinator(navigationController, tabBarItem: tabBarItem)
        return (coordinator, navigationController)
    }
}
