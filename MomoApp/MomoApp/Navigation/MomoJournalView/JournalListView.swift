//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct JournalListView: View {

    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State private var animateOn: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.entries, id: \.self) { entry in
                    EntryView(entry: entry)
                }
            }
            .padding()
        }
        .onAppear {
            self.viewModel.fetchEntries()
            self.animateOn = true
        }
    }
}

// MARK: - Previews

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        var view = JournalListView()
        view.viewModel = EntriesViewModel(dataManager: MockDataManager())
        return view
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
