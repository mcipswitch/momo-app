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
            if isExpanded {
                //                ZStack {
                //                    RoundedRectangle(cornerRadius: 8)
                //                        .fill(Color.black.opacity(0.3))
                //                    VStack {
                //                        HStack {
                //                            VStack(alignment: .leading, spacing: 8) {
                //                                Text(entry.date, formatter: DateFormatter.shortDate)
                //                                    .dateText(opacity: 0.6)
                //                                Text(entry.emotion)
                //                                    .momoTextBold()
                //                            }
                //                            .matchedGeometryEffect(id: "\(entry) text", in: animation)
                //                            Spacer()
                //                        }
                //                        BlobView(pct: $pct, isStatic: true, scale: 0.5)
                //                            .matchedGeometryEffect(id: "\(entry) blob", in: animation)
                //                    }
                //                    .padding(24)
                //                }
                //                .frame(height: 200)
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.date, formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                        Text(entry.emotion)
                            .momoTextBold()
                    }
                    .matchedGeometryEffect(id: "text\(entry.id)", in: animation)
                    Spacer()
                    BlobView(pct: $pct, isStatic: true, scale: 0.25)
                        .padding(.trailing, 16)
                        .matchedGeometryEffect(id: "blob\(entry.id)", in: animation)
                }
                .frame(width: .infinity, height: 60)
                .padding(24)
                .background(VisualEffectBlur(blurStyle: .dark))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
        .onTapGesture {
            withAnimation(.ease()) {
                self.isExpanded.toggle()
            }
        }
        .onAppear {
            //self.isExpanded = true
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
