//
//  iTourApp.swift
//  iTour
//
//  Created by Azoz Salah on 15/02/2024.
//

import SwiftUI
import SwiftData


@main
struct iTourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}
