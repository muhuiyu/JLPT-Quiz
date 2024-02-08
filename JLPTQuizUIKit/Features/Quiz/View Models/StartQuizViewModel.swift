//
//  StartQuizViewModel.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import JLPTQuiz

class StartQuizViewModel: BaseViewModel {
    private let quizService: QuizService
    @Published private(set) var config = QuizConfig()
    
    struct QuizConfig {
        var numberOfQuestions: Int
        var level: QuizLevel
        var type: QuizType
        
        init() {
            self.numberOfQuestions = 5
            self.level = .n1
            self.type = .grammar
        }
    }
    
    init(coordinator: Coordinator?, quizService: QuizService) {
        self.quizService = quizService
    }
}

extension QuizLevel {
    var toText: String {
        switch self {
        case .n1: "N1"
        case .n2: "N2"
        case .n3: "N3"
        case .n4: "N4"
        case .n5: "N5"
        }
    }
}

extension QuizType {
    var toText: String {
        switch self {
        case .kanji: "kanji"
        case .grammar: "grammar"
        case .vocab: "vocabulary"
        }
    }
}
