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
    @State private var showHome: Bool = true
    @State private var showButtonText: Bool = true
    
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
    @State private var isResetting: Bool = false
    
    @State private var nextButtonIsActive: Bool = false
    
    @State private var rainbowIsActive: Bool = false
    @State private var rainbowDegrees: Double = 0
    @State private var buttonSize: CGFloat = 80
 
    // MARK: - Drag Gestures
    var simpleDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.isDragging = true
                
                guard let startLocation = startLocation else { return }
                let maxDistance: CGFloat = 40
                var newLocation = startLocation
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                let distance = startLocation.distance(to: newLocation)
                if distance > maxDistance {
                    self.rainbowIsActive = (distance > maxDistance * 1.2) ? true : false
                    let k = maxDistance / distance
                    let locationX = ((newLocation.x - startLocation.x) * k) + startLocation.x
                    let locationY = ((newLocation.y - startLocation.y) * k) + startLocation.y
                    self.location = CGPoint(x: locationX, y: locationY)
                } else {
                    self.location = newLocation
                }
                
                guard let location = location else { return }
                self.degrees = location.angle(to: startLocation)
                self.pct = self.degrees / 360
                
            }.updating($startLocation) { value, state, transaction in
                // Set startLocation to current button position
                // It will reset once the gesture ends
                state = startLocation ?? location
            }.onEnded { _ in
                self.location = self.originalPos
                self.isDragging = false
                self.rainbowIsActive = false
                
                self.isResetting = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isResetting = false
                }
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
                
                // START: - Navigation Buttons
                HStack {
                    BackButton(action: self.handleBack)
                    Spacer()
                    NextButton(isActive: $nextButtonIsActive, action: self.handleNext)
                        .animation(.ease())
                }
                .modifier(SlideIn(showHome: $showHome, noDelay: .constant(false)))
                .padding(16)
                .disabled(isResetting)
                
                // START: - Main View
                VStack(spacing: 48) {
                    VStack(spacing: 36) {
                        Text(Date(), formatter: dateFormat)
                            .dateText()
                            .modifier(SlideOut(showHome: $showHome))
                            .padding(.top, 16)
                        ZStack {
                            Text("Hi, how are you feeling today?")
                                .momoText()
                                .modifier(SlideOut(showHome: $showHome))
                            VStack(spacing: 6) {
                                EmotionTextField(text: $text, textFieldIsFocused: $textFieldIsFocused)
                                    .modifier(SlideIn(showHome: $showHome, noDelay: $textFieldIsFocused))
                                TextFieldBorder(showHome: $showHome, textFieldIsFocused: $textFieldIsFocused)
                            }
                        }
                        .onChange(of: text) { _ in
                            self.nextButtonIsActive = text.isEmpty ? false : true
                        }
                        .frame(width: 180, height: 80)
                    }
                    
                    ZStack {
                        BlobView(pct: $pct, frameSize: 250)
                        VStack {
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(originalPos.x)), y:\(Int(originalPos.y))")
                            Text("Starting Location: x:\(Int(startLocation?.x ?? 0)), y:\(Int(startLocation?.y ?? 0))")
                            Text("Current Pos: x:\(Int(location?.x ?? 0)), y:\(Int(location?.y ?? 0))")
                            Text("Angle: \(Int(degrees))")
                            Text(isDragging ? "dragging..." : "")
                            Text(isResetting ? "resetting..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(rainbowIsActive ? "rainbow..." : "")
                        }
                        .font(Font.system(size: 12))
                    }
                    
                    ZStack {
                        RainbowRing(isActive: $rainbowIsActive, degrees: $rainbowDegrees)
                            .position(self.originalPos)
                        GeometryReader { geometry in
                                ZStack(alignment: .center) {
                                    AddEmotionButton(showHome: $showHome, isAnimating: $isAnimating, buttonSize: $buttonSize, action: self.handleAddEmotion)
                                        .animation(isDragging ? .default : Animation
                                                    .bounce()
                                                    .delay(if: isAnimating, (isResetting ? 0 : 0.2))
                                        )
                                    ColorRing(size: $buttonSize, shiftColors: $isAnimating, isDragging: $isDragging)
                                        .blur(radius: isAnimating ? 0 : 2)
                                        .opacity(isAnimating ? 1 : 0)
                                        .scaleEffect(isAnimating ? 1 : 1.1)
                                        .animation(isDragging ? .default : !isAnimating ? .default : Animation
                                                    .bounce()
                                                    .delay(if: isAnimating, (isResetting ? 0 : 0.6))
                                        )
                                    SeeEntriesButton(action: self.handleSeeEntries)
                                        .offset(y: 60)
                                        .modifier(SlideOut(showHome: $showHome))
                                }
                                .position(self.location ?? CGPoint(x: geometry.size.width / 2, y: buttonSize / 2))
                                .highPriorityGesture(showHome ? nil : simpleDrag.simultaneously(with: fingerDrag))
                            if let fingerLocation = fingerLocation {
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                    .position(fingerLocation)
                            }
                        }
                        .onAppear {
                            self.originalPos = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
                            self.location = self.originalPos
                        }
                    }
                    .padding(.top, 64)
                }
                // END: - Main View
            }
        }
        .onChange(of: showHome) { _ in
            self.showButtonText.toggle()
            self.isAnimating.toggle()
            UIApplication.shared.endEditing()
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
        if showHome { showHome.toggle() }
    }
    
    private func handleSeeEntries() {
        print("See all entries...")
    }
    
    // Navigation Buttons
    private func handleBack() {
        showHome.toggle()
        print("Back...")
    }
    
    private func handleNext() {
        print("Next...")
    }
    
}

// MARK: - Views
struct EmotionTextField: View {
    @Binding var text: String
    @Binding var textFieldIsFocused: Bool
    var body: some View {
        ZStack(alignment: .center) {
            Text("My day in a word")
                .momoText(opacity: text.isEmpty ? 0.6 : 0)
            TextField("", text: $text, onEditingChanged: { editingChanged in
                textFieldIsFocused = editingChanged ? true : false
                print(textFieldIsFocused ? "focused" : "not focused")
            }, onCommit: {
                print(text)
            }).textFieldStyle(EmotionTextFieldStyle())
            .onReceive(text.publisher.collect()) { characters in
                self.text = String(text.prefix(20))
            }
        }
    }
}

struct BackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
        }.buttonStyle(ActionButtonStyle())
    }
}

struct NextButton: View {
    @Binding var isActive: Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Next")
                Image(systemName: "arrow.right")
            }
        }.buttonStyle(MomoButtonStyle(w: 90, h: 34, isActive: isActive))
        .disabled(!isActive)
    }
}

struct AddEmotionButton: View {
    @Binding var showHome: Bool
    @Binding var isAnimating: Bool
    @Binding var buttonSize: CGFloat
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Add today's emotion")
                .opacity(isAnimating ? 0 : 1)
                .animation(isAnimating ? .none : Animation
                            .ease().delay(0.5)
                )
        }.buttonStyle(MomoButtonStyle(w: showHome ? 230 : buttonSize, h: showHome ? 60 : buttonSize))
    }
}

struct SeeEntriesButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("See all entries").underline()
        }.buttonStyle(MomoTextLinkStyle())
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
