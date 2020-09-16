//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI
import Combine

struct AddMoodView: View {
    //    @ObservedObject private var textLimiter = TextLimiter(limit: 5)
    
    // MARK: - Properties and Variables
    @State private var originalPos = CGPoint(x: UIScreen.screenWidth / 2, y: 0)
    @State private var location = CGPoint(x: UIScreen.screenWidth / 2, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    @State private var text = ""
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    @State private var isDragging: Bool = false
    private var maxDistance: CGFloat = 36
    
    // MARK: - Drag Gestures
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if let startLocation = startLocation {
                    var newLocation = startLocation
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                    
                    let distance = startLocation.distance(to: newLocation)
                    if distance > maxDistance {
                        let k = maxDistance / distance
                        let locationX = ((newLocation.x - originalPos.x) * k) + originalPos.x
                        let locationY = ((newLocation.y - originalPos.y) * k) + originalPos.y
                        self.location = CGPoint(x: locationX, y: locationY)
                    } else {
                        self.location = newLocation
                    }
                }
                self.isDragging = true
                self.degrees = location.angle(to: startLocation ?? location)
                self.pct = degrees / 360
            }.updating($startLocation) { value, startLocation, transaction in
                // Set startLocation to current rectangle position
                // It will reset once the gesture ends
                startLocation = startLocation ?? location
            }.onEnded { _ in
                self.location = self.originalPos
                self.isDragging = false
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($fingerLocation) { value, fingerLocation, transaction in
                fingerLocation = value.location
            }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 64) {
                    ZStack(alignment: .center) {
                        if text.isEmpty {
                            Text("My day in a word")
                                .font(Font.system(size: 28, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.6))
                                .blur(radius: 0.5)
                        }
                        TextField("", text: $text)
                            .textFieldStyle(CustomTextFieldStyle())
                            .onReceive(text.publisher.collect()) { characters in
                                self.text = String(text.prefix(20))
                            }
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 2)
                            .padding(.top, 48)
                    }
                    .frame(width: 230)
                    .padding(.top, 32)
                    
                    ZStack {
                        BlobView(frameSize: geometry.size.width * 0.7, pct: $pct)
                        VStack {
                            Text("Pct: \(pct)")
                            Text("Current Pos: x:\(Int(location.x)), y:\(Int(location.y))")
                            Text("Angle: \(Int(degrees))")
                            Text(isDragging ? "dragging..." : "")
                        }
                    }

                    Spacer()
                    
                    ZStack {
                        CircleButton(isDragging: $isDragging)
                            .position(self.location)
                            .gesture(
                                simpleDrag.simultaneously(with: fingerDrag)
                            )
                            .animation(Animation.interpolatingSpring(stiffness: 120, damping: 12))
                            .onAppear {
                                self.originalPos = CGPoint(x: geometry.size.width / 2, y: 0)
                                self.location = self.originalPos
                            }
                        if let fingerLocation = fingerLocation {
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .position(fingerLocation)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarItems(trailing: NextButton())
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
