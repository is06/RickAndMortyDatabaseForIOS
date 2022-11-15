//
//  CharacterService.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

protocol CharacterServiceProtocol {
    var delegate: CharacterServiceDelegate? { get set }
    func requestCharacters()
}

protocol CharacterServiceDelegate: AnyObject {
    func characterService(requestCharactersDidFinishWith result: Result<[Character], ServiceError>)
}

final class CharacterService: CharacterServiceProtocol {
    
    weak var delegate: CharacterServiceDelegate?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func requestCharacters() {
        self.networkService.makeGetRequest(url: "/character", responseType: CharacterResponse.self) { result in
            switch result {
            case .success(let response):
                self.delegate?.characterService(requestCharactersDidFinishWith: .success(response.results))
            case .failure(let error):
                self.delegate?.characterService(requestCharactersDidFinishWith: .failure(error))
            }
        }
    }
}
