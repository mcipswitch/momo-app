//
//  MonthButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct GraphViewScaleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Last 7 days")
                    .calendarMonthText()
//                Image(systemName: "chevron.down")
//                    .calendarMonthText(size: 12.0)
            }
        }
    }
}
