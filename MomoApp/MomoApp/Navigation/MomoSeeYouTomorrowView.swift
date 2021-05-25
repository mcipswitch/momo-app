//
//  MomoSeeYouTomorrowView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-04-25.
//

import ComposableArchitecture
import SwiftUI

struct MomoSeeYouTomorrowView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @State private var showText = false

    var body: some View {
        ZStack {
            if self.showText {
                VStack(spacing: 30) {
                    Image.momo(.checkmark)
                        .foregroundColor(.momo)
                        .font(.mediumFont(size: 56))
                    Text("Thank you!".localized)
                        .foregroundColor(.white)
                        .font(.boldFont(size: 32))
                }
            }

            Rectangle().foregroundColor(.clear)
        }
        .momoBackground()

        // TODO: - move this to appState?
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut) {
                    self.showText.toggle()
                }
            }
        }
    }
}
