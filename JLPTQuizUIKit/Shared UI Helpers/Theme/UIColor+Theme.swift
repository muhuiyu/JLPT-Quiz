//
//  UIColor+Theme.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/11/24.
//

import UIKit

extension UIColor {
    static let primary = UIColor(hex: "4C8C87")
    
    struct QuizSession {
        static let correct = UIColor.systemGreen.withAlphaComponent(0.8)
        static let wrong = UIColor.systemRed.withAlphaComponent(0.8)
    }
}
