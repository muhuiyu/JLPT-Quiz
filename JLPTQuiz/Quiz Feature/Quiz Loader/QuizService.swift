//
//  QuizService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

protocol QuizService {
    func generateSession(filter: QuizFilter?) throws -> Session
}

enum QuizServiceError: Error {
    case missingFile
    case invalidData
}

struct Session {
    let quizList: [Quiz]
}

struct QuizFilter {
    var level: QuizLevel? = nil
    var type: QuizType? = nil
}
