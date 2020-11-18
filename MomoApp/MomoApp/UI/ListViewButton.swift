//
//  ListViewButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-10-28.
//

import SwiftUI

struct ListViewButton: View {
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {} ) {
            Image(systemName: "list.bullet")
        }
        .momoTextRegular()
    }
}



struct JournalViewTypeButton: View {

    var action: (() -> Void)?

    var body: some View {
        Button(action: action ?? {} ) {
            Image(systemName: "list.bullet") // "chart.bar.xaxis"
        }.momoTextRegular()
    }
}

struct ListViewButton_Previews: PreviewProvider {
    static var previews: some View {
        JournalViewTypeButton()
    }
}
