//
//  CharacterListViewModelTests.swift
//  RickAndMortyDatabaseTests
//
//  Created by Thomas Noury  on 09/11/2022.
//

import XCTest
@testable import RickAndMortyDatabase

final class CharacterListViewModelTest: XCTestCase {
    
    func testGetCharacterShouldCallDelegate() {
        let expectation = XCTestExpectation(description: "getCharacter delegate should be called with expected Characters")
        
        // GIVEN
        let characterServiceMock = CharacterServiceMock(mockedCharacters: [
            Character(name: "Steve"),
            Character(name: "Ronald"),
            Character(name: "Tim"),
        ])
        let viewModel = CharacterListViewModel(characterService: characterServiceMock)
        characterServiceMock.delegate = viewModel
        
        let delegateSpy = DelegateSpy(expectation: expectation, expectedCharacters: [
            Character(name: "Steve"),
            Character(name: "Ronald"),
            Character(name: "Tim"),
        ])
        viewModel.delegate = delegateSpy
        
        // WHEN
        viewModel.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
}

fileprivate final class CharacterServiceMock: CharacterServiceProtocol {
    
    var delegate: CharacterServiceDelegate?
    
    private let mockedCharacters: [Character]
    
    init(mockedCharacters: [Character]) {
        self.mockedCharacters = mockedCharacters
    }
    
    func getCharacters() {
        delegate?.characterService(getCharactersDidFinishWith: self.mockedCharacters)
    }
}

fileprivate final class DelegateSpy: CharacterListViewModelDelegate {
    
    private let expectation: XCTestExpectation
    private let excpectedCharacters: [Character]
    
    init(expectation: XCTestExpectation, expectedCharacters: [Character]) {
        self.expectation = expectation
        self.excpectedCharacters = expectedCharacters
    }
    
    func characterListViewModel(getCharacterDidFinishWith characters: [RickAndMortyDatabase.Character]) {
        if (self.excpectedCharacters == characters) {
            return self.expectation.fulfill()
        }
        XCTFail("Characters from service are different from expected characters")
    }
}
