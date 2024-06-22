// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkingManager {
    func getData<T: Decodable>(urlString: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) async throws -> T
}

public extension NetworkingManager {
    func getData<T: Decodable>(urlString: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) async throws -> T {
        return try await getData(urlString: urlString, dateDecodingStrategy: dateDecodingStrategy)
    }
}

public class NetworkingManagerImpl: NetworkingManager {
    
    public init(){}
    
    public enum NetworkingError: LocalizedError {
        case BadURLResponse(url: URL)
        case InvalidURL(urlString: String)
        case DecodeError(urlString: String)
        
        var errorDescription: String {
            switch self {
            case .BadURLResponse(url: let url):
                return "Bad response from URL: \(url)"
            case .InvalidURL(urlString: let url):
                return "Invalid URL: \(url)"
            case .DecodeError(urlString: let url):
                return "Decode error: \(url)"
            }
        }
    }
    
    public func getData<T: Decodable>(
        urlString: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            print("URL error")
            throw NetworkingError.InvalidURL(urlString: urlString)
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch let error {
            print("Decode error \(error.localizedDescription) \(urlString)")
            throw NetworkingError.DecodeError(urlString: urlString)
        }
    }
}
