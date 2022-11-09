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
    
    func getCharacters() {
        let characters = [
            Character(name: "Steve"),
            Character(name: "Ronald"),
            Character(name: "Tim"),
        ]
        self.delegate?.characterService(getCharactersDidFinishWith: characters)
    }
}
