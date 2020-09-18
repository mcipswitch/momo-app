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
    
    @State private var textFieldIsFocused: Bool = false
    
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
                
                
                HStack {
                    // Back Button
                    Button(action: {
                        self.showHome.toggle()
                    }) {Image(systemName: "arrow.left")
                        .momoText()
                    }
                    
                    Spacer()
                    
                    // Next Button
                    Button(action: {
                        print("Next...")
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                    }.buttonStyle(MomoButton(width: 90, height: 34))
                }
                .offset(x: showHome ? 24 : 0)
                .opacity(showHome ? 0 : 1)
                .animation(Animation
                            .easeInOut(duration: 0.5)
                            //.delay(showHome ? 0 : 0.2)
                )
                .padding(16)
                
                
                

                
                
                
                
                
                
                
                
                VStack(spacing: 64) {

                    VStack(spacing: 32) {
                        Text(Date(), formatter: dateFormat)
                            .dateText()
                            .opacity(showHome ? 1 : 0)
                            .offset(x: showHome ? 0 : -geometry.size.width)
                            .animation(.easeInOut(duration: 0.5))
                            .padding(.top, 16)
                        
                        // Text Field
                        ZStack(alignment: .top) {
                                Text("Hi, how are you feeling today?")
                                    .momoText()
                                    .opacity(showHome ? 1 : 0)
                                    .offset(x: showHome ? 0 : -geometry.size.width)
                                    .animation(.easeInOut(duration: 0.5))
                            ZStack(alignment: .top) {
                                if text.isEmpty {
                                    Text("My day in a word")
                                        .momoText(opacity: 0.6)
//                                        .opacity(showHome ? 0 : 1)
//                                        .animation(Animation.easeInOut(duration: 0.5).delay(0.5))
                                }
                                TextField("", text: $text, onEditingChanged: { editingChanged in
                                    textFieldIsFocused = editingChanged ? true : false
                                })
                                .textFieldStyle(CustomTextFieldStyle())
                                .onReceive(text.publisher.collect()) { characters in
                                    self.text = String(text.prefix(20))
                                }
                            }
                            .offset(x: showHome ? geometry.size.width : 0)
                            .animation(.easeInOut(duration: 0.5))
                            
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color(textFieldIsFocused ? #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(height: 2)
                                .offset(y: 32)
                                .frame(width: showHome ? 0 : 180)
                                .animation(showHome ? .default : Animation
                                            .interpolatingSpring(stiffness: 180, damping: 12)
                                            .delay(showHome ? 0 : 0.2)
                                )
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
                                        }.buttonStyle(MomoButton(width: 230, height: 60))
                                        Spacer()
                                    }
                                    Text("See all entries")
                                        .underlineText()
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
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
