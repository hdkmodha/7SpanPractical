//
//  LoginView.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import SwiftUI

struct LoginView: View {
    let viewModel = LoginViewModel()
    @ScaledMetric(relativeTo: .title2) var imageSize = 24
    
    var body: some View {
        VStack(spacing: 16) {
            
            Image(.github)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.purple)
            
            Button {
                viewModel.send(.loginButtonTapped)
            } label: {
                HStack {
                    Text("Login with Github")
                    if viewModel.loginState.isFetching {
                        ProgressView()
                    }
                    if viewModel.loginState.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .disabled(viewModel.loginState.isFetching)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .onOpenURL { url in
            viewModel.send(.registerAuth(url: url))
        }
    }
}

#Preview {
    LoginView()
}
