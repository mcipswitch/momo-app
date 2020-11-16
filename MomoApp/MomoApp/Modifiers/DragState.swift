//
//  DragState.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-16.
//

import SwiftUI

enum DragState {
    case inactive
    case active(
            location: CGPoint,
            translation: CGSize
         )

    var location: CGPoint {
        switch self {
        case .active(let location, _):
            return location
        default:
            return .zero
        }
    }

    var translation: CGSize {
        switch self {
        case .active(_, let translation):
            return translation
        default:
            return .zero
        }
    }
}
