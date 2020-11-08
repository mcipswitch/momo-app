//
//  JournalListView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct JournalListView {
    let entries = [Entry]()
    
    var body: some View {
        List(entries, id: \.self) {
            EntryView(entry: $0)
        }
    }
}
