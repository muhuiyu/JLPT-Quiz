//
//  ItemService.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

protocol ItemService {
    func getItem<T: Item>(for id: String) -> T?
}
