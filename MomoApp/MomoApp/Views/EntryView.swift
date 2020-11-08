//
//  EntryView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct EntryView: View {
    private let entry: Entry
    init(entry: Entry) {
        self.entry = entry
    }
    
    var body: some View {
        HStack {
            Text(entry.emotion)
            //Text(entry.date)
            Text(entry.emotion)
        }
    }
}
