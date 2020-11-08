//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct JournalListView: View {
    @ObservedObject var viewModel = EntriesViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.entries, id: \.self) {
                EntryView(entry: $0)
            }
            .navigationBarTitle(Text("Journal List"))
        }
        .onAppear {
            self.viewModel.fetchEntries()
        }
    }
}

struct JournalListView_Previews: PreviewProvider {
    static var previews: some View {
        var view = JournalListView()
        view.viewModel = EntriesViewModel(dataManager: MockDataManager())
        return view
    }
}
