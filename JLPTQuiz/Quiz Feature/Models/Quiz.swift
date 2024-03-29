//
//  Quiz.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

public typealias QuizID = String

public struct Quiz: Equatable {
    public let id: QuizID
    public let type: QuizType
    public let level: QuizLevel
    public let question: String
    public let options: [QuizOptionEntry]
}

public enum QuizLevel: String {
    case n1
    case n2
    case n3
    case n4
    case n5
}

public enum QuizType: String {
    case kanji
    case grammar
    case vocab
}

public struct QuizOptionEntry: Equatable {
    public let wording: String
    public let linkedEntryID: String
    public let isAnswer: Bool
}
