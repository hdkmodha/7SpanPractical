//
//  AppViewModel.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation

@MainActor
@Observable
@dynamicMemberLookup
final class AppViewModel {
    
    enum Screen {
        case login
        case repository
    }
    
    struct State {
        var rootScreen: Screen
        
        init() {
            if let _ = UserDefaults.standard.string(forKey: "token") {
                rootScreen = .repository
            } else {
                rootScreen = .login
            }
        }
    }
    
    enum Action {
        case onAppear
        case didUpdateLoginState(String?)
    }
    
    private(set) var state: State = .init()
    
    subscript<T>(dynamicMember keyPath: KeyPath<State, T>) -> T {
        self.state[keyPath: keyPath]
    }
    
    func send(_ action: Action) {
        self.perform(action: action, state: &state)
    }
    
    private func perform(action: Action, state: inout State) {
        switch action {
        case .onAppear:
            Task {
                for await object in NotificationCenter.default.notifications(named: .userLoggedIn) {
                    let token = object.object as? String
                    self.send(.didUpdateLoginState(token))
                }
            }
        case .didUpdateLoginState(let token):
            if token != nil {
                state.rootScreen = .repository
            } else {
                state.rootScreen = .login
            }
        }
    }
}
