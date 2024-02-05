//
//  QuizLoaderService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

protocol QuizLoaderService {
    func generateSession(filter: QuizFilter?) -> Session
}

enum QuizLoaderServiceError: Error {
    case missingFile
    case invalidData
}

struct Session {
    let quizList: [Quiz]
}

struct QuizFilter {
    let level: QuizLevel
    let type: QuizType
}
