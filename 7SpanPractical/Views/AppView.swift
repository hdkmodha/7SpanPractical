//
//  AppView.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation
import SwiftUI

struct AppView: View {
    
    let viewModel: AppViewModel
    
    var body: some View {
        Group {
            switch viewModel.rootScreen {
            case .login:
                LoginView()
            case .repository:
                NavigationStack {
                    RepositoryListView()
                        .navigationTitle("Repositories")
                }
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
    }
}

#Preview {
    AppView(viewModel: .init())
}
