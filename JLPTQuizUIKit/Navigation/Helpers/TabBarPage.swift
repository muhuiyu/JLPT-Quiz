//
//  TabBarPage.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

enum TabBarPage: Int, CaseIterable {
    case quiz = 0
    
    var order: Int {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .quiz: return Text.TabBarPage.quiz
        }
    }
    
    var image: UIImage? {
        let imageName = switch self {
        case .quiz: Icon.QuizTab.inactive
        }
        return UIImage(systemName: imageName)
    }
    
    var selectedImage: UIImage? {
        let imageName = switch self {
        case .quiz: Icon.QuizTab.active
        }
        return UIImage(systemName: imageName)
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}

