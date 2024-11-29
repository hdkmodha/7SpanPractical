//
//  PersistanceManager.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import CoreData
import Foundation
import PersistenceStorage

final class PersistanceManager {

    func setup() {
        PersistenceStorage.shared.setupDataBase(withName: AppConstants.dbName)
        print("open \(PersistenceStorage.shared.dabasePath)")
    }
    
    func savetoDatabase(withRespositories repos: [Repository]) {
        repos.forEach { repo in
            let cdRepo = CDRepository(context: PersistenceStorage.shared.context)
            cdRepo.id = Int64(repo.id ?? 0)
            cdRepo.name = repo.name ?? ""
            cdRepo.desc = repo.description
            cdRepo.forks = Int64(repo.forksCount ?? 0)
            cdRepo.stars = Int64(repo.starsCout ?? 0)
            cdRepo.updatedAt = ISO8601DateFormatter().date(from: repo.updatedAt) ?? Date()
        }
        PersistenceStorage.shared.saveContext()
    }
    
    func fetch() -> [Repository] {
        guard let cdRepos = PersistenceStorage.shared.fetchManagedObject(managedObject: CDRepository.self) else { return [] }
        var respos: [Repository] = []
        cdRepos.forEach { cdRepo in
            let repo = cdRepo.convertoRepository()
            respos.append(repo)
        }
        return respos
    }
}
