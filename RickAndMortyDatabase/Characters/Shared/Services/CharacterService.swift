//
//  CharacterService.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

protocol CharacterServiceProtocol {
    var delegate: CharacterServiceDelegate? { get set }
    func getCharacters()
}

protocol CharacterServiceDelegate: AnyObject {
    func characterService(getCharactersDidFinishWith characters: [Character])
}

final class CharacterService: CharacterServiceProtocol {
    
    weak var delegate: CharacterServiceDelegate?
    
    fileprivate struct CharacterResponse: Codable {
        var results: [Character]
    }
    
    func getCharacters() {
        guard let url = URL(string: "\(MainConfig.apiUrl)/character") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let response = try? JSONDecoder().decode(CharacterResponse.self, from: data) {   
                self.delegate?.characterService(getCharactersDidFinishWith: response.results)
            }
        }
        task.resume()
    }
}
