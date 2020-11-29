//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct JournalListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = EntriesViewModel(dataManager: MockDataManager())
    @State var animate: Double = 0

    var layout: [GridItem] { [GridItem(.flexible())] }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(viewModel.entries.indices) { index in
                    EntryView(entry: viewModel.entries[index])
                        .opacity(animate)
                        .onAnimationCompleted(for: animate, completion: {
                            if index == viewModel.entries.count - 2 {

                                // Enable toggle journal button
                                self.viewRouter.toggleHitTesting(true)
                            }
                        })
                        .animation(.cascade(offset: Double(index)))
                }
            }
            .padding()
        }
        .onReceive(self.viewRouter.journalWillChange) {

            // Disable toggle journal button when animating
            self.viewRouter.toggleHitTesting(false)

            // Add delay so we can see the cascading animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Cascades ON and OFF
                self.animate = animate == 1 ? 0 : 1
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
