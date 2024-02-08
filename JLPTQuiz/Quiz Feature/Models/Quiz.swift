//
//  Quiz.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

public struct Quiz: Equatable {
    public let id: String
    public let type: QuizType
    public let level: QuizLevel
    public let question: String
    public let options: [OptionEntry]
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

public struct OptionEntry: Equatable {
    public let value: String
    public let linkedEntryID: String
    public let isAnswer: Bool
}
