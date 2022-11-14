//
//  NetworkServiceTests.swift
//  RickAndMortyDatabaseTests
//
//  Created by Thomas Noury  on 14/11/2022.
//

import XCTest
@testable import RickAndMortyDatabase

fileprivate enum NetworkServiceTestError: Error {
    case truc
}

final class NetworkServiceTests: XCTestCase {
    
    private var networkService: NetworkServiceProtocol?
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSessionMock = URLSession.init(configuration: configuration)
        
        self.networkService = NetworkService(urlSession: urlSessionMock)
    }
    
    func testMakeGetRequestShouldCompleteWithSuccessfulEntityDataResult() {
        // GIVEN
        let urlString = "https://api.test.com/endpoint"
        guard let url = URL(string: urlString) else { return }
        
        let jsonString = """
            {
                "id": 1,
                "name": "MyEntity"
            }
        """
        let data = jsonString.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = response else { throw NetworkServiceTestError.truc }
            return (response, data)
        }
        
        let expectation = XCTestExpectation(description: "Should be called when entity data is equal to what expected")
        
        // WHEN
        self.networkService?.makeGetRequest(url: "/endpoint", responseType: EntityMock.self, { result in
            switch result {
            case .success(let entity):
                let expectedEntity = EntityMock(id: 1, name: "MyEntity")
                if (entity == expectedEntity) {
                    expectation.fulfill()
                }
                break
            case .failure(_):
                XCTFail("Result for makeGetRequest should be successful")
            }
        })
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testMakeGetRequestShouldCompleteWithFailureWhenServerRespondsWithFailureStatusCode() {
        // GIVEN
        let urlString = "https://api.test.com/endpoint"
        guard let url = URL(string: urlString) else { return }
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
            guard let response = response else { throw NetworkServiceTestError.truc }
            return (response, nil)
        }
        
        let expectation = XCTestExpectation(description: "Should be called when entity data is equal to what expected")
        
        // WHEN
        self.networkService?.makeGetRequest(url: "/endpoint", responseType: EntityMock.self, { result in
            switch result {
            case .success(_):
                XCTFail("Result for makeGetRequest should not be successful")
                break
            case .failure(let error):
                switch error {
                case .requestError(let statusCode):
                    if (statusCode == 400) {
                        expectation.fulfill()
                    }
                default:
                    XCTFail("Result for makeGetRequest should contain a requestError failure")
                    break
                }
            }
        })
        
        // THEN
        wait(for: [expectation], timeout: 0.5)
    }
    
}

fileprivate struct EntityMock: Decodable, Equatable {
    var id: Int
    var name: String
}

fileprivate final class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = URLProtocolMock.requestHandler else {
            XCTFail("URLProtocolMock handler is unavailable.")
            return
        }
        do {
            let (response, data) = try handler(request)
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
