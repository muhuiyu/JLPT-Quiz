//
//  Grammar.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

typealias GrammarID = String

struct Grammar: Item {
    var id: GrammarID
    let title: String
    let formation: String
    let meaning: String
    let examples: [String]
    let relatedGrammarIDs: [GrammarID]
    let remark: String
}
