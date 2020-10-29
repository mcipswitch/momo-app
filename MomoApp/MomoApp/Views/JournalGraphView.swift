//
//  JournalGraphView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct JournalGraphView: View {
    var numOfLines: Int = 7
    var startDate: Int = 5
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: (geometry.size.width - 20 * 7) / CGFloat(numOfLines - 1)) {
                ForEach(0..<numOfLines) { num in
                    VStack {
                        GraphLine()
                        Text("\(num + startDate)")
                            //.momoTextRegular(size: 14, opacity: 0.6)
                            .font(.custom("DMSans-Medium", size: 14))
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                    .frame(width: 20)
                }
            }
        }
        .padding()
    }
}

// MARK: - Views

struct GraphLine: View {
    var body: some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColor(.gray)
    }
}

// MARK: - Previews

struct JournalGraphView_Previews: PreviewProvider {
    static var previews: some View {
        JournalGraphView()
    }
}
