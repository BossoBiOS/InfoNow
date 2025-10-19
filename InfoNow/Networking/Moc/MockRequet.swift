//
//  MockRequet.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation
internal import Combine

class MocManager: ObservableObject {
    
    public static var shared = MocManager()
    
    @Published var mocArray: [any APIMiddleware] = []
    
    init() {
    }
    
    public func addMoc(mocScenario: MockRequet.Scenario) {
        self.mocArray = [MockRequet(scenario: mocScenario)]
    }
    
    public func stopMocing() {
        self.mocArray.removeAll()
    }
}


struct MockRequet: APIMiddleware {
    
    enum Scenario: String, CaseIterable, Identifiable {
        case success
        case empty
        case unauthorized
        case serverError
        
        var id: String { rawValue } // For Identifiable
        
        func name() -> String {
            switch self {
            case .success:
                return "succes"
            case .empty:
                return "empty responce"
            case .unauthorized:
                return "unauthorized request"
            case .serverError:
                return "server error"
            }
        }
    }
    
    let scenario: Scenario
    
    func intercept(_ request: URLRequest, route: any APIOperations.Route.Type, next: @Sendable (URLRequest) async throws -> (HTTPURLResponse, Data?)) async throws -> (HTTPURLResponse, Data?) {
        // only intercept certain routes if you want
        
            switch scenario {
            case .success:
                if route == APIOperations.everything.self {
                    let mockResponse = JsonLoader().loadJSON("mockedFetchResponce", as: Articles.self)
                    
                    let data = try JSONEncoder().encode(mockResponse)
                    let response = HTTPURLResponse(
                        url: request.url!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                    return (response, data)
                } else if route == APIOperations.search.self {
                    let mockResponse = JsonLoader().loadJSON("mockedSearchFetchResponce", as: Articles.self)
                    
                    let data = try JSONEncoder().encode(mockResponse)
                    let response = HTTPURLResponse(
                        url: request.url!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                    return (response, data)
                } else {
                    break
                }
            case .empty:
                let mockResponse = Articles(
                    status: "ok",
                    totalResults: 0,
                    articles: [],
                    message: nil
                )
                let data = try JSONEncoder().encode(mockResponse)
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, data)
                
            case .unauthorized:
                let errorJson = """
                { "status": "error", "code": "apiKeyInvalid", "message": "Invalid API key" }
                """
                let data = errorJson.data(using: .utf8)!
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 401,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, data)
                
            case .serverError:
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil
                )!
                return (response, nil)
            }
        
        // fallback: call the real transport
        return try await next(request)
    }
    
    
    
   
    
}

class JsonLoader {
    func loadJSON<T: Decodable>(_ filename: String, as dataType: T.Type) -> T {
        guard let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to locate \(filename) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(filename) from bundle.")
        }

        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(filename) from bundle.")
        }

        return loaded
    }
}
