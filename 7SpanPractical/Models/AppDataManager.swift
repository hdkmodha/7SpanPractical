//
//  AppDataManager.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Dependencies
import Foundation

final class AppDataManager {
    private var networkManager: NetworkManager
    private var persistanceManager: PersistanceManager
    
    init(networkManager: NetworkManager, persistanceManager: PersistanceManager) {
        self.networkManager = networkManager
        self.persistanceManager = persistanceManager
    }
    
    func repositories(currentPage: Int, pageSize: Int, refresh: Bool = false) async throws -> [Repository] {
        let existing = persistanceManager.fetch()
        guard !existing.isEmpty /*|| refresh == false*/ else {
            let repos = try await networkManager.fetch(
                withCurrentPage: currentPage,
                perPage: pageSize,
                type: Repository.self
            )
            persistanceManager.savetoDatabase(withRespositories: repos)
            return repos
        }
        return existing
    }
}

extension AppDataManager: DependencyKey {
    static var liveValue: AppDataManager {
        .init(networkManager: .init(), persistanceManager: .init())
    }
}

extension DependencyValues {
    var appManager: AppDataManager {
        get { self[AppDataManager.self] }
        set { self[AppDataManager.self] = newValue }
    }
}
