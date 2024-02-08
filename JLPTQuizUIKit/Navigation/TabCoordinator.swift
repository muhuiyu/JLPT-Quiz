//
//  TabCoordinator.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit
import Combine

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
}

class TabCoordinator: NSObject, TabCoordinatorProtocol {
    
    var type: CoordinatorType = .tab
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    
    var childCoordinators: [Coordinator] = []
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    func start() {
        configureTabBarController()
    }
}

extension TabCoordinator {
    private func configureTabBarController() {
        let pages: [TabBarPage] = TabBarPage.allCases
        tabBarController.viewControllers = pages.map { makeViewController(for: $0) }
        tabBarController.selectedIndex = TabBarPage.quiz.order
        navigationController.viewControllers = [ tabBarController ]
        configureTabBarStyle()
    }
    
    private func makeViewController(for tab: TabBarPage) -> UIViewController {
        switch tab {
        case .quiz:
            let (coordinator, navigationController) = CoordinatorFactory.makeQuizCoordinator(tabBarItem: tab.tabBarItem)
            coordinator.finishDelegate = self
            childCoordinators.append(coordinator)
            coordinator.start()
            return navigationController
        }
    }
    
    private func configureTabBarStyle() {
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
}

extension TabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != childCoordinator.type }
    }
}
