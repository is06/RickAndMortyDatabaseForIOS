//
//  CharacterListViewModelTests.swift
//  RickAndMortyDatabaseTests
//
//  Created by Thomas Noury on 09/11/2022.
//

import XCTest
@testable import RickAndMortyDatabase

final class CharacterListViewModelTest: XCTestCase {
    
    func testRequestCharactersShouldCallDelegateWithSuccess() {
        // GIVEN
        let characterServiceMock = CharacterServiceMock(mockedResult: .success([
            Character(name: "Steve", imageUrl: "https://test.img"),
            Character(name: "Ronald", imageUrl: "https://test.img"),
            Character(name: "Tim", imageUrl: "https://test.img"),
        ]))
        let viewModel = CharacterListViewModel(characterService: characterServiceMock)
        characterServiceMock.delegate = viewModel
        
        let expectation = XCTestExpectation(description: "requestCharacters delegate should be called with success and expected characters")
        let delegateObject = DelegateObject(expectation: expectation, expectedResult: .success([
            Character(name: "Steve", imageUrl: "https://test.img"),
            Character(name: "Ronald", imageUrl: "https://test.img"),
            Character(name: "Tim", imageUrl: "https://test.img"),
        ]))
        viewModel.delegate = delegateObject
        
        // WHEN
        viewModel.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testRequestCharactersShouldCallDelegateWithFailureNoCharacter() {
        // GIVEN
        let characterServiceMock = CharacterServiceMock(mockedResult: .success([]))
        let viewModel = CharacterListViewModel(characterService: characterServiceMock)
        characterServiceMock.delegate = viewModel
        
        let expectation = XCTestExpectation(description: "requestCharacters delegate should be called with failure result noCharacter")
        let delegateObject = DelegateObject(expectation: expectation, expectedResult: .failure(.noCharacter))
        viewModel.delegate = delegateObject
        
        // WHEN
        viewModel.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testRequestCharactersShouldCallDelegateWithFailureServiceError() {
        // GIVEN
        let characterServiceMock = CharacterServiceMock(mockedResult: .failure(.decodingError))
        let viewModel = CharacterListViewModel(characterService: characterServiceMock)
        characterServiceMock.delegate = viewModel
        
        let expectation = XCTestExpectation(description: "requestCharacters delegate should be called with failure result noCharacter")
        let delegateObject = DelegateObject(expectation: expectation, expectedResult: .failure(.serviceError))
        viewModel.delegate = delegateObject
        
        // WHEN
        viewModel.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
}

fileprivate final class CharacterServiceMock: CharacterServiceProtocol {
    
    var delegate: CharacterServiceDelegate?
    
    private let mockedResult: Result<[Character], ServiceError>
    
    init(mockedResult: Result<[Character], ServiceError>) {
        self.mockedResult = mockedResult
    }
    
    func requestCharacters() {
        delegate?.characterService(requestCharactersDidFinishWith: mockedResult)
    }
}

fileprivate final class DelegateObject: CharacterListViewModelDelegate {
    
    private let expectation: XCTestExpectation
    private let expectedResult: Result<[Character], CharacterListError>
    
    init(expectation: XCTestExpectation, expectedResult: Result<[Character], CharacterListError>) {
        self.expectation = expectation
        self.expectedResult = expectedResult
    }
    
    func characterListViewModel(requestCharacterDidFinishWith result: Result<[Character], CharacterListError>) {
        
        if result == self.expectedResult {
            return self.expectation.fulfill()
        }
        XCTFail("Characters from service are different from expected characters")
    }
}
