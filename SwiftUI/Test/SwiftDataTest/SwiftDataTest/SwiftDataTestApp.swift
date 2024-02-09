//
//  SwiftDataTestApp.swift
//  SwiftDataTest
//
//  Created by Erkebulan Massainov on 06.02.2024.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataTestApp: App {
    
//    let container: ModelContainer = 
//    {
//        let schema = Schema([Expense.self])
//        let container = try! ModelContainer(for: schema, configurations: [])
//        
//        return container
//    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(container)
        .modelContainer(for: [Expense.self])
    }
}
