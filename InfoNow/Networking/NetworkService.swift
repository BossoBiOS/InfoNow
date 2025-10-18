//
//  NetworkService.swift
//  InfoNow
//
//  Created by Stefan kund on 16/10/2025.
//

import SwiftUI

enum NetworkError: Error {
    case invalidServerURL, failedClientResponse
}

class NetworkService {
    
    static var shered = NetworkService()
    
    private let serverUrlString = "https://newsapi.org"
    
    public func fetchAllNews() async throws -> Articles? {
        
        // check server url validity
        guard let serverURL = URL(string: serverUrlString) else {
            throw NetworkError.invalidServerURL
        }
        
        // build Neworking client
        let client = UniversalApiClient(
            serverUrl: serverURL,
            transport: URLSessionTransport(),
            middlewares: MocManager.shared.mocArray
        )
        
        let response: Articles?
        
        // Configure request rout
        let operation = APIOperations.everything.self
        
        do {
            response = try await client.send(
                input: nil,
                route: operation.self,
                urlRequest: operation.buildURLRequest,
                decoder: operation.decodeResponse
            )
        } catch {
            throw NetworkError.failedClientResponse
        }
        return response
    }
    
    public func fetchTopNews() async throws -> Articles? {
        
        // check server url validity
        guard let serverURL = URL(string: serverUrlString) else {
            throw NetworkError.invalidServerURL
        }
        
        // build Neworking client
        let client = UniversalApiClient(
            serverUrl: serverURL,
            transport: URLSessionTransport(),
            middlewares: MocManager.shared.mocArray
        )
        
        let response: Articles?
        
        // Configure request rout
        let operation = APIOperations.top.self
        
        do {
            response = try await client.send(
                input: nil,
                route: operation.self,
                urlRequest: operation.buildURLRequest,
                decoder: operation.decodeResponse
            )
        } catch {
            throw NetworkError.failedClientResponse
        }
        return response
    }
    
    public func fetchNewsWithSearch(scope: String? = nil) async throws -> Articles? {
        
        // check server url validity
        guard let serverURL = URL(string: serverUrlString) else {
            throw NetworkError.invalidServerURL
        }
        
        // build Neworking client
        let client = UniversalApiClient(
            serverUrl: serverURL,
            transport: URLSessionTransport(),
            middlewares: MocManager.shared.mocArray
        )
        
        let response: Articles?
        
        // Configure request rout
        let operation = APIOperations.search.self
        
        do {
            response = try await client.send(
                input: scope,
                route: operation.self,
                urlRequest: operation.buildURLRequest,
                decoder: operation.decodeResponse
            )
        } catch {
            throw NetworkError.failedClientResponse
        }
        return response
    }

   
}
