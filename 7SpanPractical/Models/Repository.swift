//
//  Repository.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation

struct Repository: Identifiable, Codable, Hashable, Sendable {
    var id: Int?
    var name: String?
    var description: String?
    var forksCount: Int?
    var starsCout: Int?
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case forksCount = "forks_count"
        case starsCout = "stargazers_count"
        case updatedAt = "updated_at"
    }
}

extension Repository {
    var lastUpdatedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self.updatedAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return "Unknown"
    }
}
