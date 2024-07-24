//
//  EntryDetailsViewModel.swift
//  JLPTQuizUIKit
//
//  Created by Mu Yu on 2/29/24.
//

import UIKit
import Combine
import JLPTQuiz

class EntryDetailsViewModel: BaseViewModel {
//    @Published private(set) var entry: Entry?
//    @Published private(set) var bookmarkID: String?
    
    private let id: String
    private let type: QuizType
    
    init(for id: String, as type: QuizType) {
        self.id = id
        self.type = type
    }
    
    func fetchItem() {
        
    }
}
