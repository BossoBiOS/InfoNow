//
//  UniversalApiClient.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation

struct UniversalApiClient: Sendable {
    
    let serverUrl: URL
    
    var transport: any APITransport
    
    var middlewares: [any APIMiddleware]
    
    init(serverUrl: URL,
         transport: any APITransport,
         middlewares: [any APIMiddleware])
    {
        self.serverUrl = serverUrl
        self.transport = transport
        self.middlewares = middlewares
    }
    
    func send<OperationInput, OperationOutput>(
        input: OperationInput,
        route: APIOperations.Route.Type,
        urlRequest: (OperationInput) throws -> (URLRequest),
        decoder: @Sendable (Data?) async throws -> OperationOutput
    ) async throws -> OperationOutput where OperationInput: Sendable, OperationOutput: Sendable {
        
        let (request): (URLRequest) = try urlRequest(input)
        
        var next: @Sendable (URLRequest) async throws -> (HTTPURLResponse, Data?) = { (_request) in
            try await transport.send(_request, serverUrl: serverUrl)
        }
        
        for middleware in middlewares {
            let current = next
            next = { _request in
                try await middleware.intercept(_request, route: route.self, next: current)
            }
        }
        
        let (_, fethedData) = try await next(request)
        
        return try await decoder(fethedData)
    }
}


protocol APIMiddleware: Sendable {
    func intercept(
        _ request: URLRequest,
        route: APIOperations.Route.Type,
        next: @Sendable (URLRequest) async throws -> (HTTPURLResponse, Data?)
        
    ) async throws -> (HTTPURLResponse, Data?)
}


