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
    
    public func generateSession(filter: QuizFilter? = nil) throws -> Session {
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
        
        return quizzes
            .filter { item in
                guard let type = filter.type else {
                    return true
                }
                return item.type == type
            }
            .filter { item in
                guard let level = filter.level else {
                    return true
                }
                return item.level == level
            }
    }
}
