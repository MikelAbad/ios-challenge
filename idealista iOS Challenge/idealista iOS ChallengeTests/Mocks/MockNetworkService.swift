//
//  MockNetworkService.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 10/05/2025.
//

import Foundation
@testable import idealista_iOS_Challenge

class MockNetworkService: NetworkService {
    override func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        throw NSError(domain: "Mock", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
    }
}
