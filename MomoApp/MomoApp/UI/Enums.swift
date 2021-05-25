//
//  Enums.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-12.
//

import SwiftUI

// MARK: - JournalType

enum JournalType {
    case list
    case chart

    var title: String {
        switch self {
        case .list:
            return "All entries".localized
        case .chart:
            return "Last 7 days".localized
        }
    }
}

// MARK: - ColorWheelSection

enum ColorWheelSection {
    case momo
    case momoPurple
    case momoOrange

    var degrees: Double {
        switch self {
        case .momo:
            return 0
        case .momoPurple:
            return 120
        case .momoOrange:
            return 240
        }
    }
}

// MARK: - Status

enum Status: Equatable {
    case add
    case edit
    case done

    var text: String {
        switch self {
        case .add: return "Add today's emotion".localized
        case .edit: return "Edit today's emotion".localized
        default: return ""
        }
    }
}
