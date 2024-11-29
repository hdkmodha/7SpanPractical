//
//  LoginViewModel.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Dependencies
import Foundation
import SwiftUI
import SafariServices

// TEMP:

//
//    private func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
//        
//        let clientID = secrets.clientId
//        let clientSecret = secrets.clientSecret
//        
//        guard let url = URL(string: tokenURL) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        struct Parameters: Codable {
//            var client_id: String
//            var client_secret: String
//            var code: String
//            var redirect_uri: String
//        }
//        
//        let parameters = Parameters(
//            client_id: clientID,
//            client_secret: clientSecret,
//            code: code,
//            redirect_uri: redirectURI
//        )
//        let body = try? JSONEncoder().encode(parameters)
//        
//        request.httpBody = body
//        
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let data = data, error == nil else { return }
//            
//            if let token = self?.parseToken(from: data) {
//                completion(.success(token))
//            } else if let error {
//                print(error)
//                completion(.failure(.network(error.localizedDescription)))
//            } else {
//                completion(.failure(.invalidResponse))
//            }
//        }.resume()
//    }
//    
//    private func parseToken(from data: Data) -> String? {
//        if let responseString = String(data: data, encoding: .utf8) {
//            let tokenParam = responseString
//                .components(separatedBy: "&")
//                .first(where: { $0.starts(with: "access_token=") })
//            return tokenParam?.replacingOccurrences(of: "access_token=", with: "")
//        }
//        return nil
//    }
    
//}

@dynamicMemberLookup
@Observable
@MainActor final class LoginViewModel {
    let loginManager = LoginManager()
    struct State {
        var loginState: FetchingState<String> = .idle
    }
    
    enum Action {
        case loginButtonTapped
        case updateLoginState(FetchingState<String>)
        case registerAuth(url: URL)
    }
    
    private(set) var state = State()
    
    subscript<T>(dynamicMember keypath: KeyPath<State, T>) -> T {
        self.state[keyPath: keypath]
    }
    
    func send(_ action: Action) {
        Task {
            self.perform(action: action, state: &self.state)
        }
    }
    
    private func perform(action: Action, state: inout State) {
        switch action {
        case .loginButtonTapped:
            state.loginState = .fetching
            Task {
                do {
                    let token = try await loginManager.requestAuthencation()
//                    self.send(.updateLoginState(.fetched(token)))
                } catch {
                    self.send(.updateLoginState(.error(error.localizedDescription)))
                }
            }
        case .updateLoginState(let fetchingState):
            state.loginState = fetchingState
            
        case .registerAuth(let url):
            Task {
                do {
                    let result = try await loginManager.handleCallback(url: url)
                    switch result {
                    case .success(let token):
                        print("Token: \(token)")
                        UserDefaults.standard.set(token, forKey: "token")
                    case .failure:
                        print("Failure")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
