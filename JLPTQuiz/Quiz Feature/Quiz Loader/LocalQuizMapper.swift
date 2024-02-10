//
//  LocalQuizMapper.swift
//  JLPTQuiz
//
//  Created by Mu Yu on 2/5/24.
//

import Foundation

final class LocalQuizMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    private struct LocalQuizItem: Decodable {
        let id: String
        let type: LocalQuizItemType
        let level: LocalQuizItemLevel
        let question: String
        let options: [LocalOptionEntry]
        
        enum LocalQuizItemType: String, Decodable {
            case kanji
            case grammar
            case vocab
            
            var quizType: QuizType {
                return switch self {
                case .kanji: .kanji
                case .grammar: .grammar
                case .vocab: .vocab
                }
            }
        }
        
        enum LocalQuizItemLevel: String, Decodable {
            case n1
            case n2
            case n3
            case n4
            case n5
            
            var quizLevel: QuizLevel {
                return switch self {
                case .n1: .n1
                case .n2: .n2
                case .n3: .n3
                case .n4: .n4
                case .n5: .n5
                }
            }
        }
        
        struct LocalOptionEntry: Decodable {
            let wording: String
            let linkedEntryID: String
            let isAnswer: Bool
            
            enum CodingKeys: String, CodingKey {
                case wording
                case linkedEntryID = "linkedEntry"
                case isAnswer
            }
            
            var item: QuizOptionEntry {
                QuizOptionEntry(wording: wording, linkedEntryID: linkedEntryID, isAnswer: isAnswer)
            }
        }
        
        var quiz: Quiz {
            Quiz(id: id,
                 type: type.quizType,
                 level: level.quizLevel,
                 question: question,
                 options: options.map { $0.item })
        }
    }
    
    static func map(_ data: Data) throws -> [Quiz] {
        guard let quizzes = try? JSONDecoder().decode([LocalQuizItem].self, from: data) else {
            throw Error.invalidData
        }
        return quizzes.map { $0.quiz }
    }
}
