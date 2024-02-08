//
//  AppCoordinator.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import Combine

protocol AppCoordinatorProtocol: Coordinator {
    func showLoadingScreen()
    func showWelcomeScreen()
    func showTabBarScreen()
}

class AppCoordinator: AppCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType = .app
    
    private var tabBarController: UITabBarController?
    private var tabCoordinator: TabCoordinator
    
    required init(_ navigationController: UINavigationController, tabCoordinator: TabCoordinator) {
        self.navigationController = navigationController
        self.tabCoordinator = tabCoordinator
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        showTabBarScreen()
    }
    
    func showLoadingScreen() {
        // TODO: -
    }
    
    func showWelcomeScreen() {
        // TODO: - Show welcome flow
    }
    
    func showTabBarScreen() {
        let tabCoordinator = tabCoordinator
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
