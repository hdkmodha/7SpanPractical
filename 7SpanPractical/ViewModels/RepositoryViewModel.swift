//
//  RepositoryViewModel.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Dependencies
import Foundation

@Observable
@MainActor
@dynamicMemberLookup
final class RepositoryViewModel {
    
    @ObservationIgnored
    @Dependency(\.appManager) private var manager

    struct State {
        var repositories: [Repository] = []
        var fetchingState: FetchingState<[Repository]> = .idle
        var currentPage = 1
        let pageSize = 20
        var searchText: String = ""
        
        var searchResults: [Repository] {
            if searchText.isEmpty {
                repositories
            } else {
                repositories.filter {
                    ($0.name ?? "").localizedCaseInsensitiveContains(searchText)
                    || $0.starsCout == Int(searchText)
                }
            }
        }
    }
    
    enum Action {
        case onAppear
        case updateFetchingState(FetchingState<[Repository]>)
        case searchTextChange(String)
        case fetchNextPage
        case fetchNextIfLast(for: Int?)
    }
    
    private(set) var state: State = .init()
    
    subscript<T>(dynamicMember keypath: KeyPath<State, T>) -> T {
        self.state[keyPath: keypath]
    }
    
    func send(_ action: Action) {
        self.perform(action: action, state: &state)
    }
    
    private func perform(action: Action, state: inout State) {
        switch action {
        case .onAppear:
            guard !state.fetchingState.isFetching else { return }
            let currentPage = state.currentPage
            let pageSize = state.pageSize
            state.fetchingState = .fetching
            Task {
                do {
                    let repositories = try await manager.repositories(
                        currentPage: currentPage,
                        pageSize: pageSize
                    )
                    self.send(.updateFetchingState(.fetched(repositories)))
                } catch {
                    self.send(.updateFetchingState(.error(error.localizedDescription)))
                }
            }
            break
        case .updateFetchingState(let fetchingState):
            
            state.fetchingState = fetchingState
            if let value = fetchingState.value {
                if state.repositories.isEmpty {
                    state.repositories = value
                } else {
                    state.repositories.append(contentsOf: value)
                }
                state.currentPage += 1
            }
        case .searchTextChange(let searchText):
            state.searchText = searchText
            
        case .fetchNextPage:
            self.send(.onAppear)
            
        case .fetchNextIfLast(let repoId):
            if state.repositories.last?.id == repoId {
                self.send(.fetchNextPage)
            }
        }
    }
}
