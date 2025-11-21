//
//  APIOperations.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation
import UIKit

fileprivate let apiKey = "0d2bc1697a614fd9a046a4dc1183df12"

enum APIOperations: Sendable {

    protocol Route: Sendable {
        static var domain: AvailableDomaine { get }
        static var methode: APIMethods { get }
    }

    protocol Operations {
        associatedtype Output

        static func buildURLRequest(_ input: String?) throws -> (URLRequest)
        static func decodeResponse(_ data: Data?) async throws -> Output
    }
    
    // Generic URLRequest builder
    static func universalURLRequestBuilder<R: Route>(
        input: String?,
        route: R.Type
    ) throws -> (URLRequest) {
        let fullUrlString: String!
        
        var inputString: String = ""
        if let safeInput = input {
            inputString = safeInput
        }
        
        if route.domain == .image {
            fullUrlString = route.domain.rawValue + inputString
        } else {
            fullUrlString = route.domain.rawValue + inputString + "&apiKey=\(apiKey)"
        }
        
        guard let url = URL(string: fullUrlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = route.methode.rawValue
        return (request)
    }
    
    // Generic response decoder
    static func universalResponseDecoder<T>(
        _ data: Data?,
        type: T.Type
    ) async throws -> T {
        guard let data else {
            throw URLError(.badServerResponse)
        }
        // JSON decode first
        if let decodableType = T.self as? Decodable.Type {
            if let decoded = try? JSONDecoder().decode(decodableType, from: data) as? T {
                return decoded
            }
        }
        
        // If T is UIImage
        if T.self == UIImage.self {
            if let image = UIImage(data: data) as? T {
                return image
            }
            throw URLError(.cannotDecodeContentData)
        }
        
        // No valid decoding
        throw URLError(.cannotDecodeRawData)
    }
    
    
    enum everything: Route, Operations {
        
        static var methode = APIMethods.get
        
        static var domain: AvailableDomaine = .everything_french
        
        typealias Output = Articles
        
        static func buildURLRequest(_ input: String? = nil) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
        
    }
    
    enum search: Route, Operations {
      
        static var domain: AvailableDomaine = .search
        
        static var methode: APIMethods = .get
        
        typealias Output = Articles
    
        static func buildURLRequest(_ input: String?) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
    }
    
    enum top: Route, Operations {
      
        static var domain: AvailableDomaine = .topHeadLine
        
        static var methode: APIMethods = .get
        
        typealias Output = Articles
    
        static func buildURLRequest(_ input: String?) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
    }
    
    enum imageFetch: Route, Operations {
        static var domain: AvailableDomaine = .image
        
        static var methode: APIMethods = .get
        
        typealias Output = UIImage
        
        static func buildURLRequest(_ input: String?) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: UIImage.self)
        }
    }
    
    
}

enum AvailableDomaine: String {
    case topHeadLine = "/v2/top-headlines?country=fr&pageSize=100&page=1"
    case everything_french = "/v2/everything?language=fr&pageSize=100&domains=lemonde.fr,lefigaro.fr,20minutes.fr,leparisien.fr,france24.com&page=1"
    case search = "/v2/everything?pageSize=100&page=1&q="
    case image = ""
}

enum APIMethods: String {
    case get = "GET"
    case post = "POST"
}
