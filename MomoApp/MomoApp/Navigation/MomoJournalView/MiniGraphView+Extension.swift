//
//  MiniGraphView+Extension.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-22.
//

import SwiftUI

struct MiniGraphViewLogic {

    func lineFrameSpacing(geo: GeometryProxy, numOfLines: Int, lineWidth: CGFloat, completion: @escaping ([GridItem]) -> Void) -> CGFloat {

        let lines = numOfLines.floatValue
        let totalLineWidths = lineWidth * lines
        let lineSpacing = (geo.w - totalLineWidths) / (lines - 1)

        let layout: [GridItem] = Array(
            repeating: .init(.flexible(), spacing: lineSpacing),
            count: numOfLines)

        completion(layout)

        let spacing = lineWidth + lineSpacing
        return spacing
    }
}
