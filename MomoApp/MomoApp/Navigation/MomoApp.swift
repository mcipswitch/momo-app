//
//  MomoAppApp.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-15.
//

import SwiftUI

@main
struct MomoApp: App {
    @StateObject var viewRouter = ViewRouter()
    @StateObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
                .environmentObject(viewModel)
        }
    }
}
