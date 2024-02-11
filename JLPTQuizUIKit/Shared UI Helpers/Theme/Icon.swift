//
//  Icon.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import UIKit

final class Icon {
    
    struct QuizTab {
        static var inactive: UIImage? { UIImage(systemName: "bolt") }
        static var active: UIImage? { UIImage(systemName: "bolt.fill") }
    }
    
    struct Shared {
        static var close: UIImage? { UIImage(systemName: "xmark") }
    }
    
}
