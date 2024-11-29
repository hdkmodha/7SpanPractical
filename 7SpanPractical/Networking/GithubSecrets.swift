//
//  ProcessEnv.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Dependencies
import Foundation

struct GithubSecrets {
    let clientId: String
    let clientSecret: String
    
    init() {
        guard let clientID = ProcessInfo.processInfo.environment["clientID"] else {
            fatalError("Please make sure you have proper clientID setup in your environment.    ")
        }
        guard let clientSecret = ProcessInfo.processInfo.environment["clientSecret"] else {
            fatalError("Please make sure you have proper clientSecret setup in your environment.")
        }
        self.clientId = clientID
        self.clientSecret = clientSecret
    }
}

extension GithubSecrets: DependencyKey {
    static var liveValue: GithubSecrets {
        GithubSecrets()
    }
}

extension DependencyValues {
    var githubSecrets: GithubSecrets {
        get { self[GithubSecrets.self] }
        set { self[GithubSecrets.self] = newValue }
    }
}
