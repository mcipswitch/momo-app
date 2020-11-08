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
        ScrollView {
            LazyVStack {
                ForEach(viewModel.entries, id: \.self) {
                    EntryView(entry: $0)
                }
                .padding(.bottom, 8)
            }
            .padding()
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
            .background(
                Image("background")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
