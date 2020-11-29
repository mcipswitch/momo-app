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
                            print("Finished animation.")
                            // TODO: - Fix only print once
                            // Disable the toggle journal button until this is completed
                        })
                        .animation(.cascade(offset: Double(index)))
                }
            }
            .padding()
        }
        .onReceive(self.viewRouter.journalWillChange) {

            // Add delay so we can see the cascading animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
