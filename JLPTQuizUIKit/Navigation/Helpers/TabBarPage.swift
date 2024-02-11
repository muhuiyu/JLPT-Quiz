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
        return switch self {
        case .quiz: Icon.QuizTab.inactive
        }
    }
    
    var selectedImage: UIImage? {
        return switch self {
        case .quiz: Icon.QuizTab.active
        }
    }
    
    var tabBarItem: UITabBarItem {
        return UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}

