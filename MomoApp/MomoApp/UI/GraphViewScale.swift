//
//  MonthButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct GraphViewScale: View {
    @Binding var isGraphView: Bool

    var body: some View {
        ZStack {
            if isGraphView {
                Text("Last 7 days")
            } else {
                Text("All entries")
            }
        }
        .calendarMonthText()
    }
}
