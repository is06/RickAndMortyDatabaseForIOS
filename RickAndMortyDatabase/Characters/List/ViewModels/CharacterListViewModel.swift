//
//  CharacterListViewModel.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

protocol CharacterListViewModelProtocol {
    var delegate: CharacterListViewModelDelegate? { get set }
    func getCharacters()
}

protocol CharacterListViewModelDelegate: AnyObject {
    func characterListViewModel(getCharacterDidFinishWith characters: [Character])
}

final class CharacterListViewModel: CharacterListViewModelProtocol, CharacterServiceDelegate {
    
    weak var delegate: CharacterListViewModelDelegate?
    
    private var characterService: CharacterServiceProtocol
    
    init(characterService: CharacterServiceProtocol = CharacterService()) {
        self.characterService = characterService
        self.characterService.delegate = self
        self.getCharacters()
    }
    
    func getCharacters() {
        self.characterService.getCharacters()
    }
    
    func characterService(getCharactersDidFinishWith characters: [Character]) {
        self.delegate?.characterListViewModel(getCharacterDidFinishWith: characters)
    }
}
