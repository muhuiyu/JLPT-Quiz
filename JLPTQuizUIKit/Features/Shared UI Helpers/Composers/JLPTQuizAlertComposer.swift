//
//  JLPTQuizAlertComposer.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/11/24.
//

import UIKit
import JLPTQuiz

final class JLPTQuizAlertComposer {
    static func makeMasterQuizConfirmationAlert(with action: @escaping () -> Void) -> UIAlertController {
        let title = Text.QuizSessionViewController.masterQuestionConfirmationTitle
        let message = Text.QuizSessionViewController.masterQuestionConfirmationMessage
        let confirmTitle = Text.QuizSessionViewController.masterQuestionConfirmationConfirmTitle
        let cancelTitle = Text.QuizSessionViewController.masterQuestionConfirmationCancelTitle
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: { _ in
            action()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        return alert
    }
    
    static func makeQuizSessionResultAlert(score: Int, numberOfQuestions: Int, action: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "You scored \(score) out of \(numberOfQuestions)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in action() }))
        return alert
    }
    
    static func makeQuizSessionNoAvailableEntryDetailsAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Oops, no data yet", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
