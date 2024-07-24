//
//  LocalVocabMapper.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

final class LocalVocabMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    private struct LocalVocab: Decodable {
        var id: VocabID
        let title: String
        let meaning: String
        
        var vocab: Vocab {
            // title example: "身振り（みぶり）"
            // word should be everything before (, reading should be everything inside ()
            let word = title.components(separatedBy: "（").first ?? ""
            let reading = title.components(separatedBy: "（").last?.components(separatedBy: "）").first ?? ""
            return Vocab(id: id, word: word, reading: reading, meaning: meaning)
        }
    }
    
    static func map(_ data: Data) throws -> [Vocab] {
        guard let vocabs = try? JSONDecoder().decode([LocalVocab].self, from: data).map({ $0.vocab }) else {
            throw Error.invalidData
        }
        return vocabs
    }
}
