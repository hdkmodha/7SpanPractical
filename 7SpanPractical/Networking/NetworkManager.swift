//
//  NetworkManager.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Dependencies
import Foundation
import UIKit

enum Error: Swift.Error {
    case invalidResponse
    case network(String)
}

final class NetworkManager {
    
    @Dependency(\.githubSecrets) private var secrets
    
    func authenticate() {
        let clientID = secrets.clientId
        guard let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=read:user") else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
    
    func fetch<T: Codable>() async throws -> [T] {
        let url = URL(string: "https://api.github.com/")!
        _ = try await URLSession.shared.data(from: url)
        fatalError()
    }
    
    func handleCallback(url: URL) async throws -> Result<String, Error> {
        guard let code = URLComponents(string: url.absoluteString)?
            .queryItems?
            .first(where: { $0.name == "code" })?.value else {
            return .failure(Error.invalidResponse)
        }
        
        let result = try await exchangeCodeForToken(code: code)
        return result
    }
    
    private func exchangeCodeForToken(code: String) async throws -> Result<String, Error>  {
        
        let clientID = secrets.clientId
        let clientSecret = secrets.clientSecret
        
        guard let url = URL(string: AppConstants.tokenURL) else {
            return .failure(Error.invalidResponse)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Parameters: Codable {
            var client_id: String
            var client_secret: String
            var code: String
            var redirect_uri: String
        }
        
        let parameters = Parameters(
            client_id: clientID,
            client_secret: clientSecret,
            code: code,
            redirect_uri: AppConstants.redirectURI
        )
        let body = try? JSONEncoder().encode(parameters)
        
        request.httpBody = body
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let token = self.parseToken(from: data) {
                return .success(token)
            } else {
                return .failure(.network("Something went wrong parsing the token response."))
            }
        } catch {
            return .failure(Error.invalidResponse)
        }
    }
    
    private func parseToken(from data: Data) -> String? {
        if let responseString = String(data: data, encoding: .utf8) {
            let tokenParam = responseString
                .components(separatedBy: "&")
                .first(where: { $0.starts(with: "access_token=") })
            return tokenParam?.replacingOccurrences(of: "access_token=", with: "")
        }
        return nil
    }
}
