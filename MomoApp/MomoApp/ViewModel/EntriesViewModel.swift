//
//  EntriesViewModel.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-11-08.
//

import SwiftUI

class EntriesViewModel: ObservableObject {
    
}

// MARK: - Model

struct Entry: Hashable {
    let emotion: String
    let date: Date
    let value: CGFloat
}
