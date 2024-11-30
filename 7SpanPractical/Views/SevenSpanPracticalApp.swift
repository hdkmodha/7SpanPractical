//
//  SevenSpanPracticalApp.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 28/11/24.
//

import SwiftUI
import PersistenceStorage

@main
struct SevenSpanPracticalApp: App {
    
    init () {
        PersistenceStorage.shared.setupDataBase(withName: AppConstants.dbName)
        print("DatabasePath: \(PersistenceStorage.shared.dabasePath)")
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(viewModel: .init())
        }
    }
}
