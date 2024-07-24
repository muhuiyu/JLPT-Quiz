//
//  LocalGrammarService.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

class LocalGrammarService: ItemService {
    
    private let fileName = "grammars"
    private var dictionary = [GrammarID: Grammar]()
    
    private init() {
        loadFile()
    }
    
    func getItem<Grammar>(for id: String) -> Grammar? {
        return dictionary[id] as? Grammar
    }
    
    private func loadFile() {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error when loading \(fileName).json")
            return
        }
        
        guard
            let data = try? Data(contentsOf: path),
            let grammars = try? LocalGrammarMapper.map(data)
        else {
            print("Error when decoding \(fileName).json")
            return
        }
        
        grammars.forEach({ dictionary[$0.id] = $0 })
            
    }
}
