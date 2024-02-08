//
//  LocalQuizService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

public final class LocalQuizService: QuizService {
    private let jsonFileName: String
    
    public init(jsonFileName: String = "quizzes") {
        self.jsonFileName = jsonFileName
    }
    
    public func generateSession(filter: QuizConfig? = nil) throws -> Session {
        guard let url = Bundle(for: type(of: self)).url(forResource: jsonFileName, withExtension: "json") else {
            throw QuizServiceError.missingFile
        }
        
        guard
            let data = try? Data(contentsOf: url),
            let items = try? LocalQuizMapper.map(data)
        else {
            throw QuizServiceError.invalidData
        }
        
        // TODO: fetch user stats
        
        let filteredQuizzes = filterQuizzes(items, with: filter)
        
        return Session(quizList: filteredQuizzes)
    }
    
    private func filterQuizzes(_ quizzes: [Quiz], with config: QuizConfig?) -> [Quiz] {
        guard let config else { return quizzes }
        
        return Array(quizzes
            .filter { $0.type == config.type }
            .filter { $0.level == config.level }
            .prefix(config.numberOfQuestions)
        )
    }
}
