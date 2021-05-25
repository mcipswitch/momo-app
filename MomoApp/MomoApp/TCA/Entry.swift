//
//  Entry.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-02-13.
//

import SwiftUI

struct Entry: Identifiable, Hashable, Equatable {
    var id = UUID()
    var emotion: String
    var date: Date
    var value: CGFloat
    var isSelected = false
}

extension Entry {
    static let `default` = Entry(emotion: "Default", date: Date(), value: 0.34)
}
