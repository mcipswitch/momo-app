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
    @State private var location: CGPoint? = nil
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
    private var buttonSize: CGFloat = 80
    
    @State private var showJoystick: Bool = false
    
    // MARK: - Drag Gestures
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.isDragging = true
                
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
                
                if let location = location {
                    self.degrees = location.angle(to: originalPos)
                    self.pct = self.degrees / 360
                }
                
                
                
            }.updating($startLocation) { value, state, transaction in
                // Set startLocation to current button position
                // It will reset once the gesture ends
                // state = startLocation ?? location
                state = startLocation ?? location
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
        let spectrum = Gradient(colors: [Color(#colorLiteral(red: 0.9843137255, green: 0.8196078431, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.7960784314, green: 0.5411764706, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.431372549, green: 0.4901960784, blue: 0.9843137255, alpha: 1))])
        let conic = LinearGradient(gradient: spectrum,
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
        ZStack {
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all)
                
                // START: Navigation Buttons
                HStack {
                    Button(action: self.handleBack) {
                        Image(systemName: "chevron.backward")
                            .momoText()
                    }
                    
                    Spacer()
                    
                    Button(action: self.handleNext) {
                        HStack {
                            Text("Next")
                            Image(systemName: "arrow.right")
                        }
                    }.buttonStyle(MomoButton(w: 90, h: 34))
                }
                .modifier(SlideIn(showHome: $showHome, noDelay: .constant(false)))
                .padding(16)
                
                // START: Entire View
                VStack(spacing: 48) {
                    VStack(spacing: 36) {
                        Text(Date(), formatter: dateFormat)
                            .dateText()
                            .modifier(SlideOut(showHome: $showHome))
                            .padding(.top, 16)
                        ZStack(alignment: .top) {
                            Text("Hi, how are you feeling today?")
                                .momoText()
                                .modifier(SlideOut(showHome: $showHome))
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
                            .modifier(SlideIn(showHome: $showHome, noDelay: $textFieldIsFocused))
                            TextFieldBorder(showHome: $showHome, textFieldIsFocused: $textFieldIsFocused)
                            // END: Text Field
                        }
                        .frame(width: 180, height: 80)
                    }
                    
                    ZStack {
                        BlobView(frameSize: 250, pct: $pct)
                        VStack {
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(originalPos.x)), y:\(Int(originalPos.y))")
                            Text("Starting Location: x:\(Int(startLocation?.x ?? 0)), y:\(Int(startLocation?.y ?? 0))")
                            //Text("Current Pos: x:\(Int(location.x)), y:\(Int(location.y))")
                            Text("Angle: \(Int(degrees))")
                            Text(isDragging ? "dragging..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(rainbowIsActive ? "rainbow..." : "")
                        }
                        .font(Font.system(size: 12))
                    }
                    
                    ZStack {
                        //                            RainbowRing(isActive: $rainbowIsActive, degrees: $rainbowDegrees)
                        //                                .position(self.originalPos)
                        
                        GeometryReader { geometry in
                                ZStack(alignment: .center) {
                                    Button(action: self.handleAddEmotion) {
                                        Text("Add today's emotion")
                                            .opacity(showButtonText ? 1 : 0)
                                            .animation(!showButtonText ? .none : Animation
                                                        .easeInOut(duration: 0.2)
                                                        .delay(0.5)
                                            )
                                    }.buttonStyle(MomoButton(w: showHome ? 230 : buttonSize, h: showHome ? 60 : buttonSize))
                                    .animation(
                                        Animation
                                            .spring(response: 0.8, dampingFraction: 0.5)
                                            .delay(showHome ? 0.2 : 0)
                                    )
                                    
                                    if !showHome {
                                        Circle()
                                            .stroke(conic, lineWidth: 6)
                                            .frame(width: buttonSize + 16, height: buttonSize + 16)
                                            .mask(Circle().frame(width: buttonSize + 6))
                                            .hueRotation(Angle(degrees: isAnimating ? 360 : 0))
                                            .animation(
                                                Animation
                                                    .easeInOut(duration: 4)
                                                    .repeat(while: isAnimating, autoreverses: false)
                                            )
                                            .blur(radius: isAnimating ? 0 : 2)
                                            .opacity(isAnimating ? 1 : 0)
                                            .scaleEffect(isAnimating ? 1 : 1.1)
                                            .animation(isDragging ? .default :
                                                        Animation
                                                        .spring(response: 0.8, dampingFraction: 0.5)
                                                        .delay(1)
                                            )
                                    }
                                    Button(action: self.handleSeeEntries) {
                                        Text("See all entries")
                                            .underlineText()
                                    }
                                    .offset(y: 60)
                                    .modifier(SlideOut(showHome: $showHome))
                                }
                                .position(self.location ?? CGPoint(x: geometry.size.width / 2, y: buttonSize / 2))
                                .highPriorityGesture(showHome ? nil :
                                        simpleDrag.simultaneously(with: fingerDrag)
                                )
//                            if let fingerLocation = fingerLocation {
//                                Circle()
//                                    .stroke(Color.red, lineWidth: 2)
//                                    .frame(width: 20, height: 20)
//                                    .position(fingerLocation)
//                            }
                                
                                
                                
                                
                                
                                

                        }
                        .background(Color.orange.opacity(0.05))
                        .onAppear {
                            self.originalPos = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
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
            self.isAnimating.toggle()
            
            if value {
                self.showJoystick.toggle()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showJoystick.toggle()
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
    
    
    
    
    
    // MARK: - Internal Methods
    private func handleAddEmotion() {
        if showHome {
            showHome.toggle()
        }
    }
    
    private func handleSeeEntries() {
        print("See all entries...")
    }
    
    // Navigation Buttons
    private func handleBack() {
        self.showHome.toggle()
    }
    
    private func handleNext() {
        print("Next...")
    }
    
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
