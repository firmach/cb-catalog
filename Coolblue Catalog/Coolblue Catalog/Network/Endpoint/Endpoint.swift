//
//  Endpoint.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import Foundation

/// HTTP endpoint object
///
/// Encapsulates information for HTTP request
protocol Endpoint where Content: Decodable {

    associatedtype Content

    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String] { get }
    var request: URLRequest { get throws }

    /// Decode data from response
    func content(from body: Data) throws -> Content

}

extension Endpoint {

    var request: URLRequest {
        get throws {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }

            guard let url = urlComponents.url else { throw URLError(URLError.badURL) }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

            return request
        }
    }

    func content(from body: Data) throws -> Content {
        return try JSONDecoder().decode(Content.self, from: body)
    }

}

