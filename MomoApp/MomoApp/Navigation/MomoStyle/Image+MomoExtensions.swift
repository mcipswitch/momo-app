//
//  Image+MomoExtensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-05-23.
//

import SwiftUI

struct MomoIcon {
    var image: String
}

extension MomoIcon {
    static var arrowRight: Self {
        return .init(image: "arrow.right")
    }

    static var back: Self {
        return .init(image: "chevron.left")
    }

    static var checkmark: Self {
        return .init(image: "checkmark")
    }

    static var close: Self {
        return .init(image: "chevron.down")
    }

    static var journalGraph: Self {
        return .init(image: "chart.bar.xaxis")
    }

    static var journalList: Self {
        return .init(image: "list.bullet")
    }
}

extension Image {
    static func momo(_ icon: MomoIcon) -> Image {
        Image(systemName: icon.image)
    }
}
