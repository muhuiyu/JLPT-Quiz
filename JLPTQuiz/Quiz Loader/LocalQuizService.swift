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
        // TODO: fetch user stats and apply filters
        guard let url = Bundle(for: type(of: self)).url(forResource: jsonFileName, withExtension: "json") else {
            throw QuizServiceError.missingFile
        }
        
        guard
            let data = try? Data(contentsOf: url),
            let items = try? LocalQuizMapper.map(data)
        else {
            throw QuizServiceError.invalidData
        }
        
        return Session(quizList: items)
    }
}
