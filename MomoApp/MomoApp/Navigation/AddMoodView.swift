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
    @State private var showButtonText: Bool = true
    
    // MARK: - Properties and Variables
    @State private var originalPos = CGPoint.zero
    @State private var location = CGPoint(x: UIScreen.screenWidth / 2, y: 0)
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var currentLocation: CGPoint? = nil
    
    @State private var text = ""
    @State private var textFieldIsFocused: Bool = false
    
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var isAnimating: Bool = false
    
    @State private var rainbowIsActive: Bool = false
    @State private var rainbowDegrees: Double = 0
    private var maxDistance: CGFloat = 36

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
                        
                        self.rainbowIsActive = (distance > maxDistance * 1.2) ? true : false
                        
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
                
                // START: Navigation Buttons
                HStack {
                    Button(action: {
                        self.showHome.toggle()
                    }) {
                        Image(systemName: "chevron.backward")
                            .momoText()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Next...")
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                    }.buttonStyle(MomoButton(w: 90, h: 34))
                }
                .modifier(SlideIn(showHome: $showHome))
                .animation(Animation
                            .easeInOut(duration: 0.2)
                            .delay(showHome ? 0 : 0.5)
                )
                .padding(16)
                
                // START: Entire View
                VStack(spacing: 48) {
                    VStack(spacing: 36) {
                        Text(Date(), formatter: dateFormat)
                            .dateText()
                            .modifier(SlideOut(showHome: $showHome))
                            .animation(Animation
                                        .easeInOut(duration: 0.2)
                                        .delay(showHome ? 0.5 : 0)
                            )
                            .padding(.top, 16)
                        
                        ZStack(alignment: .top) {
                            Text("Hi, how are you feeling today?")
                                .momoText()
                                .modifier(SlideOut(showHome: $showHome))
                                .animation(Animation
                                            .easeInOut(duration: 0.2)
                                            .delay(showHome ? 0.5 : 0)
                                )
                            // START: Text Field
                            ZStack(alignment: .top) {
                                if text.isEmpty {
                                    Text("My day in a word")
                                        .momoText(opacity: 0.6)
                                }
                                TextField("", text: $text, onEditingChanged: { editingChanged in
                                    textFieldIsFocused = editingChanged ? true : false
                                })
                                .textFieldStyle(CustomTextFieldStyle())
                                .onReceive(text.publisher.collect()) { characters in
                                    self.text = String(text.prefix(20))
                                }
                            }
                            .modifier(SlideIn(showHome: $showHome))
                            .animation(Animation
                                        .easeInOut(duration: 0.2)
                                        .delay(showHome ? 0 : (textFieldIsFocused ? 0 : 0.5))
                            )
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(textFieldIsFocused ? #colorLiteral(red: 0.1215686275, green: 1, blue: 0.7333333333, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .frame(height: 2)
                                .offset(y: 32)
                                .opacity(showHome ? 0 : 1)
                                .frame(maxWidth: showHome ? 0 : .infinity)
                                .animation(Animation
                                            .interpolatingSpring(stiffness: 180, damping: 16)
                                            .delay(showHome ? 0 : 0.6)
                                )
                            // END: Text Field
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
                            Text(isAnimating ? "animating..." : "")
                            Text(rainbowIsActive ? "rainbow..." : "")
                        }
                        .font(Font.system(size: 12))
                    }
                    
                    ZStack {
                        GeometryReader { geometry in
                                VStack(spacing: 30) {
                                    HStack {
                                        Spacer()
                                        
                                        Button(action: {
                                            showHome = false
                                        }) {
                                            Text("Add today's emotion")
                                                    .opacity(showButtonText ? 1 : 0)
                                                    .animation(Animation
                                                                .easeInOut(duration: 0.2)
                                                                .delay(showButtonText ? 0.5 : 0)
                                                    )
                                        }.buttonStyle(MomoButton(w :showHome ? 230 : 84, h: showHome ? 60 : 84))
                                        .animation(.spring(response: 0.7, dampingFraction: 0.5))
                                        
                                        Spacer()
                                    }
                                    .opacity(showHome ? 1 : 0)
                                    .animation(Animation
                                                .linear(duration: 0.001)
                                                .delay(showHome ? 0 : 1.2)
                                    )
                                    Button(action: {
                                        print("See all entries...")
                                    }) {
                                        Text("See all entries")
                                            .underlineText()
                                    }
                                    .opacity(showHome ? 1 : 0)
                                    .animation(Animation
                                                .easeInOut(duration: 0.2)
                                    )
                                }
                            RainbowRing(isActive: $rainbowIsActive, degrees: $rainbowDegrees)
                                .position(self.originalPos)
                            
                            CircleButton(isDragging: $isDragging, isAnimating: $isAnimating)
                                .position(self.location)
                                .opacity(showHome ? 0 : 1)
                                .animation(Animation
                                            .linear(duration: 0.001)
                                            .delay(showHome ? 0 : 1.2)
                                )
                                .gesture(simpleDrag.simultaneously(with: fingerDrag))
                                //.animation(.spring(response: 0.7, dampingFraction: 0.5))

                            
                            
                            
                            
                                
                            if let fingerLocation = fingerLocation {
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                    .position(fingerLocation)
                            }
                        }
                        .onAppear {
                            self.originalPos = CGPoint(x: geometry.size.width / 2, y: 42)
                            self.location = self.originalPos
                        }
                    }
                    .padding(.top, 64)
                }
                // END: Entire View
            }
        }
        .onChange(of: showHome) { value in
            self.showButtonText.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.isAnimating.toggle()
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
