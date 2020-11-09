//
//  GraphViewButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

struct GraphViewButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chart.bar.xaxis")
        }
        .momoTextRegular()
    }
}
