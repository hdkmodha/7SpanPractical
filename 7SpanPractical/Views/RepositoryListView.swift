//
//  RepositoryListView.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import SwiftUI

struct RepositoryListView: View {
    
    @State var viewModel = RepositoryViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        Group {
            if viewModel.fetchingState.isFetching {
                VStack {
                    ProgressView()
                    Text("Fetching Your Repositories...")
                }
            } else if let error = viewModel.fetchingState.error {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.secondary)
                        .font(.largeTitle)
                    
                    Text("Oops, We got something here")
                    Text(error)
                }
            } else {
                listing
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        
    }
    
    private var listing: some View {
        List {
            ForEach(viewModel.searchResults, id: \.id) { repo in
                VStack(alignment: .leading, spacing: 8) {
                    if let name = repo.name {
                        Text(name)
                            .font(.headline)
                    }
                    if let desc = repo.description {
                        Text(desc)
                            .multilineTextAlignment(.leading)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("UpdatedAt: \(repo.lastUpdatedDate)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        if let fork = repo.forksCount {
                            Label("\(fork)", systemImage: "tuningfork")
                        }
                        if let stargazers = repo.starsCout {
                            Label("\(stargazers)", systemImage: "star")
                        }
                    }
                }
            }
        }
        .labelStyle(CountingStyle())
        .listStyle(.grouped)
        .searchable(text: $searchText, prompt: "Search repositories...")
        .onChange(of: searchText) { oldValue, newValue in
            viewModel.send(.searchTextChange(newValue))
        }
    }
}

struct CountingStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
                .font(.subheadline)
                .symbolVariant(.fill)
                .foregroundStyle(Color.accentColor)
            configuration.title
                .frame(minWidth: 22)
                .padding(.horizontal, 4)
                .background(.background.secondary, in: .rect(cornerRadius: 4))
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(.background.secondary, in: .rect(cornerRadius: 8))
    }
}

#Preview {
    VStack {
        Label("Title 1", systemImage: "star")
        Label("Title 2", systemImage: "square")
        Label("Title 3", systemImage: "circle")
    }
    .labelStyle(CountingStyle())
}

#Preview {
    RepositoryListView()
}
