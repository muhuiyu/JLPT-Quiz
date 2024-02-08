//
//  QuizService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

public protocol QuizService {
    func generateSession(filter: QuizConfig?) throws -> Session
}

public enum QuizServiceError: Error {
    case missingFile
    case invalidData
}

public struct Session {
    public let quizList: [Quiz]
}

public struct QuizConfig {
    public var numberOfQuestions: Int
    public var level: QuizLevel
    public var type: QuizType
}
