//
//  NextButton.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-16.
//

import SwiftUI

struct MomoButton: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                .frame(width: 90, height: 34)
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
            HStack {
                Text("Next")
                    .font(Font.system(size: 15, weight: .bold))
                Image(systemName: "arrow.right")
                    .font(Font.system(size: 14, weight: .heavy))
            }
        }
    }
}



//
//struct MomoButton: View {
//    @State var width: CGFloat = 250
//    @State var height: CGFloat = 60
//    @State var text: String = "Add today's emotion"
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
//                .frame(width: width, height: height)
//                .clipShape(RoundedRectangle(cornerRadius: height / 2, style: .continuous))
//            HStack {
//                Text(text)
//                    .font(Font.system(size: 14, weight: .bold))
//            }
//        }
//    }
//}




// See all entries
// DMSans bold, 16

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        MomoButton()
    }
}
