//
//  CharacterListViewModel.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

enum CharacterListError: Error {
    case noCharacter
    case networkError
}

protocol CharacterListViewModelProtocol {
    var delegate: CharacterListViewModelDelegate? { get set }
    func requestCharacters()
}

protocol CharacterListViewModelDelegate: AnyObject {
    func characterListViewModel(requestCharacterDidFinishWith result: Result<[Character], CharacterListError>)
}

final class CharacterListViewModel: CharacterListViewModelProtocol {
    
    weak var delegate: CharacterListViewModelDelegate?
    
    private var characterService: CharacterServiceProtocol
    
    init(characterService: CharacterServiceProtocol = CharacterService()) {
        self.characterService = characterService
        self.characterService.delegate = self
    }
    
    func requestCharacters() {
        self.characterService.getCharacters()
    }
}

extension CharacterListViewModel: CharacterServiceDelegate {
    
    func characterService(getCharactersDidFinishWith result: Result<[Character], ServiceError>) {
        switch result {
        case .success(let characters):
            if (characters.count == 0) {
                self.delegate?.characterListViewModel(requestCharacterDidFinishWith: .failure(.noCharacter))
            } else {
                self.delegate?.characterListViewModel(requestCharacterDidFinishWith: .success(characters))
            }
        case .failure(_):
            self.delegate?.characterListViewModel(requestCharacterDidFinishWith: .failure(.networkError))
        }
    }
}
