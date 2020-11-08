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
            Text(entry.date.toString(withFormat: .short))
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        let entry = Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.3)
        EntryView(entry: entry)
    }
}
