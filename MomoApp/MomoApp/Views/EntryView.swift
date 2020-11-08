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
    
    @State var pct: CGFloat = 0.2
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.date, formatter: DateFormatter.shortDate)
                        .dateText(opacity: 0.6)
                    Text(entry.emotion)
                        .momoTextBold()
                }
                Spacer()
                VStack {
                    BlobView(pct: $pct, isAnimating: false, frameSize: 250)
                        .scaleEffect(0.25)
                }
                .frame(width: 0, height: 0)
                .padding([.leading, .trailing], 72)
            }
            .padding(.all, 24)
        }
        .frame(height: 100)
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        let entry = Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.3)
        EntryView(entry: entry)
    }
}
