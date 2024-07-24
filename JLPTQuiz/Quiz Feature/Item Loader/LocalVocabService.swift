//
//  LocalVocabService.swift
//  JLPTQuiz
//
//  Created by Grace, Mu-Hui Yu on 7/24/24.
//

class LocalVocabService: ItemService {
    
    private let fileName = "vocabs"
    private var dictionary = [VocabID: Vocab]()
    
    private init() {
        loadFile()
    }
    
    func getItem<Vocab>(for id: String) -> Vocab? {
        return dictionary[id] as? Vocab
    }
    
    private func loadFile() {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error when loading \(fileName).json")
            return
        }
        
        guard
            let data = try? Data(contentsOf: path),
            let vocabs = try? LocalVocabMapper.map(data)
        else {
            print("Error when decoding \(fileName).json")
            return
        }
        
        vocabs.forEach({ dictionary[$0.id] = $0 })
            
    }
}
