//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct JournalListView: View {

    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var animate: Bool = false

    var layout: [GridItem] {
        [GridItem(.flexible())]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(viewModel.entries.indices) { index in
                    EntryView(entry: viewModel.entries[index])
                        .opacity(animate ? 1 : 0)
                        .animation(Animation
                                    .easeInOut(duration: 0.8)
                                    .delay(Double(index) * 0.05)
                        )
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(Animation.default.delay(1.0)) {
                self.animate.toggle()
            }
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
