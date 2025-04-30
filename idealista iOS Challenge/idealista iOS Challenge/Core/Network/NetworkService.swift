//
//  NetworkService.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 29/04/2025.
//

import Foundation

enum APIEndpoint {
    static let propertyList = "https://idealista.github.io/ios-challenge/list.json"
    static let propertyDetail = "https://idealista.github.io/ios-challenge/detail.json"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

@MainActor
class NetworkService {
    
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            NetworkLogger.log(message: "Invalid URL: \(urlString)", type: .error)
            throw NetworkError.invalidURL
        }
        
        NetworkLogger.log(message: "Request URL: \(urlString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                NetworkLogger.log(message: "Invalid response with code: \(statusCode)", type: .error)
                throw NetworkError.invalidResponse
            }
            
            NetworkLogger.log(message: "Response Status: \(httpResponse.statusCode)", type: .success)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                NetworkLogger.log(message: "JSON received:\n \(jsonString)", type: .success)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                NetworkLogger.log(message: "Error decoding: \(error)", type: .error)
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            } else {
                NetworkLogger.log(message: "Request error: \(error.localizedDescription)", type: .error)
                throw NetworkError.requestFailed(error)
            }
        }
    }
    
}

class NetworkLogger {
    enum LogType {
        case success
        case error
        case info
        
        var prefix: String {
            switch self {
                case .success: return "🟢"
                case .error: return "🔴"
                case .info: return "🔵"
            }
        }
    }
    
    static func log(message: String, type: LogType = .info) {
        #if DEBUG
        print("\(type.prefix) \(message)")
        #endif
    }
}
