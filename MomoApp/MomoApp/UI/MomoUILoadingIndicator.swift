//
//  MomoLoadingIndicator.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-12-01.
//

import SwiftUI

extension MomoUI {
    struct LoadingIndicator: View {
        var body: some View {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .momo))
                .scaleEffect(1.5, anchor: .center)
        }
    }
}
