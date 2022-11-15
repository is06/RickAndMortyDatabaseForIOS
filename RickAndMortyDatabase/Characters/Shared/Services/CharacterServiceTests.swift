//
//  CharacterServiceTests.swift
//  RickAndMortyDatabaseTests
//
//  Created by Thomas Noury  on 15/11/2022.
//

import XCTest
@testable import RickAndMortyDatabase

final class CharacterServiceTests: XCTestCase {
    func testRequestCharactersShouldCallDelegateWithSuccessResultAndExpectedCharacters() {
        // GIVEN
        let networkServiceMock = NetworkServiceMock(mockedResult: .success(CharacterResponse(results: [
            Character(name: "John Doe", imageUrl: "https://john.doe.jpg"),
            Character(name: "Steve Jobs", imageUrl: "https://steve.jobs.jpg"),
        ])))
        let service = CharacterService(networkService: networkServiceMock)
        
        let expectation = XCTestExpectation()
        let delegateObject = DelegateObject(expectation: expectation, expectedResult: .success([
            Character(name: "John Doe", imageUrl: "https://john.doe.jpg"),
            Character(name: "Steve Jobs", imageUrl: "https://steve.jobs.jpg"),
        ]))
        service.delegate = delegateObject
        
        // WHEN
        service.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testRequestCharactersShouldCallDelegateWithFailure() {
        // GIVEN
        let networkServiceMock = NetworkServiceMock<CharacterResponse>(mockedResult: .failure(.requestError(400)))
        let service = CharacterService(networkService: networkServiceMock)
        
        let expectation = XCTestExpectation()
        let delegateObject = DelegateObject(expectation: expectation, expectedResult: .failure(.requestError(400)))
        service.delegate = delegateObject
        
        // WHEN
        service.requestCharacters()
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
}

fileprivate final class NetworkServiceMock<MockedResultType: Decodable>: NetworkServiceProtocol {
    
    typealias MockedServiceResult = Result<MockedResultType, ServiceError> where MockedResultType: Decodable
    
    private let mockedResult: MockedServiceResult
    
    init(mockedResult: MockedServiceResult) {
        self.mockedResult = mockedResult
    }
    
    func makeGetRequest<ActualResultType>(url: String, responseType: ActualResultType.Type, _ completion: @escaping (Result<ActualResultType, ServiceError>) -> Void) where ActualResultType: Decodable {
        
        switch self.mockedResult {
        case .success(let data):
            guard let actualResultData = data as? ActualResultType else { return }
            completion(.success(actualResultData))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

fileprivate final class DelegateObject: CharacterServiceDelegate {
    
    private let expectation: XCTestExpectation
    private let expectedResult: Result<[Character], ServiceError>
    
    init(expectation: XCTestExpectation, expectedResult: Result<[Character], ServiceError>) {
        self.expectation = expectation
        self.expectedResult = expectedResult
    }
    
    func characterService(requestCharactersDidFinishWith result: Result<[Character], ServiceError>) {
        if (result == expectedResult) {
            self.expectation.fulfill()
        }
    }
}
