//
//  SceneDelegate.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let (coordinator, navigationController) = CoordinatorFactory.makeAppCoordinator()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        coordinator.start()
    }
}
