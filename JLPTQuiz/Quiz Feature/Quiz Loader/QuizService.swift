//
//  QuizService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

public protocol QuizService {
    func generateSession(filter: QuizFilter?) throws -> Session
}

public enum QuizServiceError: Error {
    case missingFile
    case invalidData
}

public struct Session {
    public let quizList: [Quiz]
}

public struct QuizFilter {
    public var level: QuizLevel? = nil
    public var type: QuizType? = nil
}
