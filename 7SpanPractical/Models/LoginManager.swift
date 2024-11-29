//
//  LoginManager.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation

final class LoginManager {
    
    private let networkManager: NetworkManager = .init()
    
    func requestAuthencation() {
        self.startLogin()
    }
    
    private func startLogin() {
        self.networkManager.authenticate()
    }
    
    func handleCallback(url: URL) async throws -> Result<String, Error> {
        let value = try await self.networkManager.handleCallback(url: url)
        return value
    }
}
