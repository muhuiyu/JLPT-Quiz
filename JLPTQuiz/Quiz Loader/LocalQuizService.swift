//
//  LocalQuizService.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

final class LocalQuizService: QuizService {
    private let jsonFileName: String
    
    init(jsonFileName: String = "quizzes") {
        self.jsonFileName = jsonFileName
    }
    
    func generateSession(filter: QuizFilter? = nil) throws -> Session {
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
    
    private func filterQuizzes(_ quizzes: [Quiz], with filter: QuizFilter?) -> [Quiz] {
        guard let filter else { return quizzes }
        
        return quizzes.filter {
            $0.type == filter.type && $0.level == filter.level
        }
    }
}
