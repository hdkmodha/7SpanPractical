//
//  AppDataManager.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation



final class AppDataManager {
    private var networkManager: NetworkManager
    private var persistanceManager: PersistanceManager
    
    init(networkManager: NetworkManager, persistanceManager: PersistanceManager) {
        self.networkManager = networkManager
        self.persistanceManager = persistanceManager
    }
    
    func repositories() async throws -> [Repository] {
        if let repos: [Repository] = persistanceManager.query() {
            return repos
        } else {
            let repos: [Repository] = try await networkManager.fetch()
            try persistanceManager.save(repos)
            return repos
        }
    }
}
