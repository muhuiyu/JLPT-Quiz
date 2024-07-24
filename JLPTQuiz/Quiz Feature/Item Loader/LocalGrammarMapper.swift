//
//  LocalGrammarMapper.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

final class LocalGrammarMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    private struct LocalGrammar: Decodable {
        var id: GrammarID
        let title: String
        let formation: String
        let meaning: String
        let examples: [String]
        let relatedGrammars: [GrammarID]
        let remark: String
        
        var grammar: Grammar {
            return Grammar(id: id, title: title, formation: formation, meaning: meaning, examples: examples, relatedGrammarIDs: relatedGrammars, remark: remark)
        }
    }
    
    static func map(_ data: Data) throws -> [Grammar] {
        guard let grammars = try? JSONDecoder().decode([LocalGrammar].self, from: data).map({ $0.grammar }) else {
            throw Error.invalidData
        }
        return grammars
    }
}
