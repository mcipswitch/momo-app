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
    
    @State var blobValue: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.date, formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                        Text(entry.emotion)
                            .momoTextBold()
                    }
                    Spacer()
                    BlobView(blobValue: $blobValue, isStatic: true, scale: 0.2)
                        .padding(.trailing, 16)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding([.leading, .trailing], 24)
            .padding([.top, .bottom], 16)
            .background(VisualEffectBlur(blurStyle: .dark))
            .clipShape(
                RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

// MARK: - Previews

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        let entry = Entry(id: UUID(), emotion: "Ocean", date: date.createDate(year: 2020, month: 11, day: 08), value: 0.3)
        EntryView(entry: entry)
    }
}
