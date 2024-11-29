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
        VStack {
            Button {
                viewModel.send(.loginButtonTapped)
            } label: {
                HStack {
                    if viewModel.loginState.isFetching {
                        ProgressView()
                    }
                    Label {
                        Text("Login with Github")
                    } icon: {
                        Image(.github)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: imageSize)
                    }
                    .font(.title2)
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
