//
//  HTTPClient.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import Foundation

/// HTTP Client protocol
///
/// Handles HTTP requests
protocol HTTPClient {

    /// Makes request based on given endpoint
    func request<T: Endpoint>(endpoint: T) async -> Result<T.Content, Error>

}

extension HTTPClient {

    func request<T: Endpoint>(endpoint: T) async -> Result<T.Content, Error> {
        do {
            let request = try endpoint.request
            let (rawData, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(URLError(URLError.cannotParseResponse))
            }
            
            switch response.statusCode {
            case 200...299:
                return .success(try endpoint.content(from: rawData))
            case 401:
                return .failure(URLError(URLError.userAuthenticationRequired))
            default:
                return .failure(URLError(URLError.unknown))
            }
        } catch {
            return .failure(error)
        }
    }

}

/// Base HTTTP API Client
struct ApiClient: HTTPClient {}
