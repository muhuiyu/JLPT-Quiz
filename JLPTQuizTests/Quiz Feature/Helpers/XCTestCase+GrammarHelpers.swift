//
//  XCTestCase+GrammarHelpers.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

import XCTest
@testable import JLPTQuiz

extension XCTestCase {
    func makeGrammarItem(
        id: GrammarID,
        title: String,
        formation: String,
        meaning: String,
        examples: [String],
        relatedGrammarIDs: [GrammarID],
        remark: String
    ) -> (model: Grammar, json: [String: Any]) {
        let model = Grammar(
            id: id,
            title: title,
            formation: formation,
            meaning: meaning,
            examples: examples,
            relatedGrammarIDs: relatedGrammarIDs,
            remark: remark
        )
        let json = [
            "id": id,
            "title": title,
            "formation": formation,
            "meaning": meaning,
            "examples": examples,
            "relatedGrammars": relatedGrammarIDs,
            "remark": remark
        ].compactMapValues { $0 }
        
        return (model, json)
    }
}
