//
//  Vocab.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

typealias VocabID = String

struct Vocab: Item {
    var id: VocabID
    let word: String
    let reading: String
    let meaning: String
}
