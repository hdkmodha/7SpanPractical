//
//  SevenSpanPracticalApp.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 28/11/24.
//

import SwiftUI

@main
struct SevenSpanPracticalApp: App {
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .onOpenURL { url in
                    print(url)
                }
        }
    }
}
