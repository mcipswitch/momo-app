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
    
    @State var pct: CGFloat = 0
    @State private var isExpanded: Bool = false
    @Namespace private var animation
    
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
                        if !isExpanded {
                            BlobView(pct: $pct, isStatic: true, scale: isExpanded ? 0.6 : 0.2)
                                .padding(.trailing, 16)
                        }
                    }
                    if isExpanded {
                        //BlobView(pct: $pct, isStatic: true, scale: isExpanded ? 0.6 : 0.25)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 16)
                .background(VisualEffectBlur(blurStyle: .dark))
                .clipShape(
                    RoundedRectangle(cornerRadius: 8, style: .continuous))
//
//
//                HStack {
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text(entry.date, formatter: DateFormatter.shortDate)
//                            .dateText(opacity: 0.6)
//                        Text(entry.emotion)
//                            .momoTextBold()
//                    }
//                    //.matchedGeometryEffect(id: "text\(entry.id)", in: animation)
//                    Spacer()
//                    BlobView(pct: $pct, isStatic: true, scale: 0.25)
//                        .padding(.trailing, 16)
//                        .matchedGeometryEffect(id: "blob\(entry.id)", in: animation)
//                }
//                .frame(minWidth: 0, maxWidth: .infinity)
//                .padding(24)
//                .background(VisualEffectBlur(blurStyle: .dark))
//                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
//
        }
        .onTapGesture {
            withAnimation(.spring()) {
                self.isExpanded.toggle()
            }
        }
        .onAppear {
            self.isExpanded = false
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
