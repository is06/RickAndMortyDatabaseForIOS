//
//  CharacterService.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

enum ServiceError: Error {
    case urlFormatError
    case transportError
    case decodingError
    case requestError(Int)
}

protocol CharacterServiceProtocol {
    var delegate: CharacterServiceDelegate? { get set }
    func getCharacters()
}

protocol CharacterServiceDelegate: AnyObject {
    func characterService(getCharactersDidFinishWith result: Result<[Character], ServiceError>)
}

final class CharacterService: CharacterServiceProtocol {
    
    weak var delegate: CharacterServiceDelegate?
    
    fileprivate struct CharacterResponse: Codable {
        var results: [Character]
    }
    
    func getCharacters() {
        guard let url = URL(string: "\(MainConfig.apiUrl)/character") else {
            self.delegate?.characterService(getCharactersDidFinishWith: .failure(.urlFormatError))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let response = response as? HTTPURLResponse else {
                self?.delegate?.characterService(getCharactersDidFinishWith: .failure(.transportError))
                return
            }
            switch response.statusCode {
            case 200:
                guard let data = data else { return }
                do {
                    let responseData = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    self?.delegate?.characterService(getCharactersDidFinishWith: .success(responseData.results))
                } catch {
                    self?.delegate?.characterService(getCharactersDidFinishWith: .failure(.decodingError))
                }
            case 400...599:
                self?.delegate?.characterService(getCharactersDidFinishWith: .failure(.requestError(response.statusCode)))
            default:
                // We do nothing for all other codes
                break
            }
        }
        task.resume()
    }
}
