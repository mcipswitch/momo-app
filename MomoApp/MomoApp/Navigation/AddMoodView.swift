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
    
    @State private var showHome: Bool = true
    
    // MARK: - Properties and Variables
    @State private var originalPos = CGPoint.zero
    @State private var location = CGPoint(x: UIScreen.screenWidth / 2, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    @GestureState private var currentLocation: CGPoint? = nil
    
    @State private var text = ""
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    @State private var isDragging: Bool = false
    
    private var maxDistance: CGFloat = 36
    
    @State private var rainbowIsActive: Bool = false
    @State private var rainbowDegrees: Double = 0
    @State private var counter: Int = 0
    
    // MARK: - Drag Gestures
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.isDragging = true
                self.degrees = location.angle(to: originalPos)
                self.pct = degrees / 360
                
                if let startLocation = startLocation {
                    var newLocation = startLocation
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                    let distance = startLocation.distance(to: newLocation)
                    if distance > maxDistance {
                        
                        if distance > maxDistance * 1.5 {
                            self.rainbowIsActive = true
                        }
                        
                        let k = maxDistance / distance
                        let locationX = ((newLocation.x - originalPos.x) * k) + originalPos.x
                        let locationY = ((newLocation.y - originalPos.y) * k) + originalPos.y
                        self.location = CGPoint(x: locationX, y: locationY)
                    } else {
                        self.location = newLocation
                    }
                }
            }.updating($startLocation) { value, startLocation, transaction in
                // Set startLocation to current rectangle position
                // It will reset once the gesture ends
                startLocation = startLocation ?? location
            }.onEnded { _ in
                self.location = self.originalPos
                self.isDragging = false
                self.rainbowIsActive = false
                self.counter = 0
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

                    VStack(spacing: 16) {
                        Text(Date(), formatter: dateFormat)
                            .font(Font.system(size: 16, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.6))
                            .opacity(showHome ? 1 : 0)
                            .padding(.top, 16)
                            
                            .opacity(showHome ? 1 : 0)
                            .offset(x: showHome ? 0 : -geometry.size.width)
                            .animation(Animation
                                        .easeInOut(duration: 0.5)
                            )
                        
                        // Text Field
                        ZStack(alignment: .center) {
                            
                                Text("Hi, how are you feeling today?")
                                    .momoText()
                                    .opacity(showHome ? 1 : 0)
                                    .offset(x: showHome ? 0 : -geometry.size.width)
                                    .animation(Animation
                                                .easeInOut(duration: 0.5)
                                    )
                            
                            ZStack {
                                
                                if text.isEmpty {
                                    Text("My day in a word")
                                        .momoText(opacity: 0.6)
                                }
                                TextField("", text: $text)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .onReceive(text.publisher.collect()) { characters in
                                        self.text = String(text.prefix(20))
                                    }
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: 2)
                                    .padding(.top, 36)
                                
                            }
                            .opacity(showHome ? 0 : 1)
                            
                            
                            // TEMP BUTTON
                            Button(action: {
                                self.showHome.toggle()
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(Font.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .frame(width: 180, height: 80)
                    }
                        
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    ZStack {
                        BlobView(frameSize: geometry.size.width * 0.7, pct: $pct)
                        VStack {
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(originalPos.x)), y:\(Int(originalPos.y))")
                            Text("Current Pos: x:\(Int(location.x)), y:\(Int(location.y))")
                            Text("Angle: \(Int(degrees))")
                            Text(isDragging ? "dragging..." : "")
                            Text(rainbowIsActive ? "rainbow..." : "")
                            Text("Counter: \(counter)")
                        }
                        .font(Font.system(size: 16))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        GeometryReader { geometry in
                            
                            if self.showHome {
                                VStack(spacing: 30) {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.showHome = false
                                        }) {
                                            Text("Add today's emotion")
                                        }.buttonStyle(MomoButton(width: 250, height: 60))
                                        Spacer()
                                    }
                                    Text("See all entries")
                                        .font(Font.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(#colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1)))
                                        .underline()
                                }
                                
                                
                                
                                
                                

                                
                                
                                
                            
                            } else {
                                
                                RainbowRing(isActive: $rainbowIsActive, degrees: $rainbowDegrees)
                                    .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                                
                                CircleButton(isDragging: $isDragging)
                                    .position(self.location)
                                    .gesture(simpleDrag.simultaneously(with: fingerDrag))
                                    .animation(Animation.interpolatingSpring(stiffness: 120, damping: 12))
                                    .onAppear {
                                        self.originalPos = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                        self.location = self.originalPos
                                    }
                                if let fingerLocation = fingerLocation {
                                    Circle()
                                        .stroke(Color.green, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                        .position(fingerLocation)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: degrees) { value in
            switch value {
            case 0..<120: rainbowDegrees = 0
            case 120..<240: rainbowDegrees = 120
            case 240..<360: rainbowDegrees = 240
            default: rainbowDegrees = 0
            }
        }
//        .navigationBarItems(trailing:
//                                Button(action: {
//                                    print("next pressed...")
//                                }, label: {
//                                    HStack {
//                                        Text("Next")
//                                            //.font(Font.system(size: 15, weight: .bold))
//                                        Image(systemName: "arrow.right")
//                                            //.font(Font.system(size: 14, weight: .heavy))
//                                    }
//                                }).buttonStyle(
//                                    MomoButton(width: 90, height: 34)
//                                )
//        )
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}