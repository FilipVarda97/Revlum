//
//  APIRequest.swift
//  
//
//  Created by Filip Varda on 07.05.2023..
//

import Foundation

/// Request object that is created with Enpoint, Path Components and Query Parametars
final class APIRequest {
    // MARK: - Properties
    /// HttpMethod enum defining possible methods for request
    enum HttpMethod: String {
        case get = "GET"
        case put = "PUT"
        case head = "HEAD"
        case post = "POST"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
    }

    static let baseUrl = "https://revlum.com/sdk/ios.php"

    /// Endpoint returns string to create URL from baseUrl
    /// (Example: "https://revlum.com/sdk/ios.php/search/repositories")
    private let endpoint: APIEndpoint
    
    /// Path components contains strings that will be added to "baseUrl  + enpoint"
    /// Example: "https://revlum.com/sdk/ios.php/users/FilipVarda97"
    private var pathComponents: [String]
    
    /// QueryParams contains name and values of params that will be added to" baseUrl  + enpoint" or "baseUrl + enpoint + pathComponents"
    /// Example: "https://revlum.com/sdk/ios.php/search/repositories?q=tetris&sort=stars&order=desc")
    private var queryParams: [URLQueryItem]
    
    /// Create urlString from all provided parametars (Example: "https://revlum.com/sdk/ios.php/search/repositories?q=tetris")
    private var urlString: String {
        var string = APIRequest.baseUrl + "/" + endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach() {
                string += "/\($0)"
            }
        }
        
        if !queryParams.isEmpty {
            string += "?"
            let argument = queryParams.compactMap { item in
                guard let value = item.value else { return nil }
                return "\(item.name)=\(value)"
            }.joined(separator: "&")
            string += argument
        }
        
        return string
    }
    
    
    public var httpMethod: HttpMethod = .get
    
    /// Computed URL that is needed to perform a URLRequest
    public var url: URL? {
        return URL(string: urlString)
    }
    
    // MARK: - Init
    /// Create APIRequest with provided enpoint. Path Components and Query Parametars are optional.
    public init(httpMethod: HttpMethod = .get,
                enpoint: APIEndpoint = .base,
                pathComponents: [String] = [],
                queryParams: [URLQueryItem] = []) {
        self.endpoint = enpoint
        self.pathComponents = pathComponents
        self.queryParams = queryParams
    }
}

    /// Create APIRequest with provided URL. Provided URL must contain baseUrl
    /// - Parameter url: URL to parse and create path components and query items
//    convenience init?(url: URL) {
//        let string = url.absoluteString
//        if !string.contains(APIRequest.baseUrl) {
//            return nil
//        }
//        /// Create pathComponents from urlString
//        let trimmed = string.replacingOccurrences(of: baseUrl + "/", with: "")
//        if trimmed.contains("/") {
//            let components = trimmed.components(separatedBy: "/")
//            if !components.isEmpty {
//                let endpointString = components[0]
//                var pathComponents: [String] = []
//                if components.count > 1 {
//                    pathComponents = components
//                    pathComponents.removeFirst()
//                }
//                if let endpoint = APIEndpoint(rawValue: endpointString) {
//                    self.init(enpoint: endpoint, pathComponents: pathComponents)
//                    return
//                }                                                                             MARK: PROBLEM HERE - base url not consistent
//            }
//        /// Create queryParams from urlString
//        } else if trimmed.contains("?") {
//            let components = trimmed.components(separatedBy: "?")
//            let endpointString = components[0]
//            if let endpoint = APIEndpoint(rawValue: endpointString) {
//                let queryParamsString = trimmed.replacingOccurrences(of: endpoint.rawValue + "?", with: "")
//                let queryComponents = queryParamsString.components(separatedBy: "&")
//                let queryParams: [URLQueryItem] = queryComponents.compactMap { queryComponent in
//                    guard queryComponent.contains("=") else {
//                        return nil
//                    }
//                    let parts = queryComponent.components(separatedBy: "=")
//                    return URLQueryItem(name: parts[0], value: parts[1])
//                }
//                self.init(enpoint: endpoint, queryParams: queryParams)
//                return
//            }
//        }
//        return nil
//    }
//}
