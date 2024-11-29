//
//  FetchingState.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation

enum FetchingState<T> {
    case idle
    case fetching
    case fetched(T)
    case error(String)
    
    var isFetching: Bool {
        switch self {
        case .fetching: return true
        default: return false
        }
    }
    
    var error: String? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
    var value: T? {
        if case .fetched(let value) = self {
            return value
        }
        return nil
    }
}
