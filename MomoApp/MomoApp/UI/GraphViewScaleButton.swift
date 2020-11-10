//
//  MonthButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct GraphViewScaleButton: View {
    @Binding var isGraphView: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isGraphView {
                    Text("Last 7 days")
                } else {
                    Text("All entries")
                }
//                Image(systemName: "chevron.down")
//                    .calendarMonthText(size: 12.0)
            }
            .calendarMonthText()
        }
    }
}
