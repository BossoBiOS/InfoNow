//
//  NetworkService.swift
//  InfoNow
//
//  Created by Stefan kund on 16/10/2025.
//

import SwiftUI

enum NetworkError: Error {
    case invalidServerURL, failedClientResponse, invalidImageURL
}

class NetworkService {
    
    private let serverUrlString = "https://newsapi.org"
    
    private var imageCache: URLCache = URLCache(memoryCapacity: 1024*1024*100, diskCapacity: 1024*1024*100) // 100 Mo
    
    public func fetchImage(imageURL: String) async throws -> (UIImage?, Error?) {
        
        let client = UniversalApiClient(
            serverUrl: nil,
            transport: URLSessionTransport(),
            middlewares: []
        )
       
        let response: UIImage?
        var errorT: Error? = nil
        
        // Configure request rout
        let operation = APIOperations.imageFetch.self
        
        do {
            response = try await client.send(
                cache: imageCache,
                input: imageURL,
                route: operation.self,
                urlRequest: operation.buildURLRequest,
                decoder: operation.decodeResponse
            )
            errorT = nil
        } catch {
            response = nil
            errorT = NetworkError.failedClientResponse
        }
        return (response, errorT)
    }
    
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
