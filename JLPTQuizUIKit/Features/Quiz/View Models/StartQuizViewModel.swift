//
//  StartQuizViewModel.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/8/24.
//

import JLPTQuiz

class StartQuizViewModel: BaseViewModel {
    private let quizService: QuizService
    private(set) var cellConfigs = [CellConfig]()
    @Published private(set) var quizConfig = QuizConfig()
    
    init(coordinator: Coordinator?, quizService: QuizService) {
        self.quizService = quizService
    }
    
    func setup() {
        setupConfigs()
    }
}

extension StartQuizViewModel {
    private func setNumberOfQuestions(to numberOfQuestions: Int) {
        quizConfig.numberOfQuestions = numberOfQuestions
    }
    
    private func setupConfigs() {
        let numberOfQuestionsChoices = setupNumberOfQuestionsConfig()
        let quizLevelChoices = setupLevelConfig()
        let quizTypeChoices = setupTypeChoices()
       
        cellConfigs = [
            CellConfig(type: .numberOfQuestions, choices: numberOfQuestionsChoices),
            CellConfig(type: .level, choices: quizLevelChoices),
            CellConfig(type: .type, choices: quizTypeChoices)
        ]
    }
    
    private func setupNumberOfQuestionsConfig() -> [Choice] {
        let numberOfQuestionsRawValues = [5, 10, 15]
        let numberOfQuestionsChoices = numberOfQuestionsRawValues.map { value in
            Choice(wording: String(value)) { [weak self] in
                self?.quizConfig.numberOfQuestions = value
            }
        }
        return numberOfQuestionsChoices
    }
    
    private func setupLevelConfig() -> [Choice] {
        let quizLevelRawValues: [QuizLevel] = [.n1, .n2]
        let quizLevelChoices = quizLevelRawValues.map { value in
            Choice(wording: value.toText) { [weak self] in
                self?.quizConfig.level = value
            }
        }
        return quizLevelChoices
    }
    
    private func setupTypeChoices() -> [Choice] {
        let quizTypeRawValues: [QuizType] = [.grammar, .kanji, .vocab]
        let quizTypeChoices = quizTypeRawValues.map { value in
            Choice(wording: value.toText) { [weak self] in
                self?.quizConfig.type = value
            }
        }
        return quizTypeChoices
    }
}

extension StartQuizViewModel {
    struct Choice {
        let wording: String
        let didSelect: () -> Void
    }
    
    struct CellConfig {
        let type: CellConfigType
        let choices: [Choice]
        var label: String { type.label }
    }
    
    enum CellConfigType {
        case numberOfQuestions
        case level
        case type
        
        var label: String {
            switch self {
            case .numberOfQuestions: Text.StartQuizViewController.numberOfQuestions
            case .level: Text.StartQuizViewController.level
            case .type: Text.StartQuizViewController.type
            }
        }
        
        var alertTitle: String {
            switch self {
            case .numberOfQuestions: "Choose number of questions"
            case .level: "Choose level"
            case .type: "Choose category"
            }
        }
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

extension QuizConfig {
    init() {
        self.init(numberOfQuestions: 5, level: .n1, type: .grammar)
    }
    
    func getStringValue(for cellConfigType: StartQuizViewModel.CellConfigType) -> String {
        switch cellConfigType {
        case .numberOfQuestions: return String(numberOfQuestions)
        case .level: return level.toText
        case .type: return type.toText
        }
    }
}
