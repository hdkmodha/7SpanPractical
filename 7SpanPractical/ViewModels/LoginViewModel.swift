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
            loginManager.requestAuthencation()
            
        case .updateLoginState(let fetchingState):
            state.loginState = fetchingState
            
        case .registerAuth(let url):
            Task {
                do {
                    let result = try await loginManager.handleCallback(url: url)
                    switch result {
                    case .success(let token):
                        debugPrint("Token: \(token)")
                        UserDefaults.standard.set(token, forKey: "token")
                        NotificationCenter.default.post(name: .userLoggedIn, object: token)
                    case .failure(let error):
                        self.send(.updateLoginState(.error(error.localizedDescription)))
                    }
                } catch {
                    self.send(.updateLoginState(.error(error.localizedDescription)))
                }
            }
        }
    }
}


