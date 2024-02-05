//
//  Quiz.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

struct Quiz {
    let id: String
    let type: QuizType
    let level: QuizLevel
    let question: String
    let options: [OptionEntry]
}

enum QuizLevel: String {
    case n1
    case n2
    case n3
    case n4
    case n5
}

enum QuizType: String {
    case kanji
    case grammar
    case vocab
}

struct OptionEntry {
    let value: String
    let linkedEntryID: String
    let isAnswer: Bool
}
