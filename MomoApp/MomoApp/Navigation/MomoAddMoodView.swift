//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct MomoAddMoodView: View {
    //    @ObservedObject private var textLimiter = TextLimiter(limit: 5)
    @State private var showHome: Bool = true
    @State private var showButtonText: Bool = true
    
    @State private var originalPos = CGPoint.zero
    @State private var location: CGPoint? = nil
//    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var dragState: DragState = .inactive


    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var currentLocation: CGPoint? = nil
    

    
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    
    @State private var isDragging: Bool = false
    @State private var isAnimating: Bool = false
    @State private var isResetting: Bool = false
    
    // Navigation State
    @State private var emotionText = ""
    @State private var textFieldIsFocused: Bool = false
    @State private var emotionTextFieldCompleted: Bool = false



    @State private var blurredColorWheelIsActive: Bool = false
    @State private var blurredColorWheelDegrees: Double = 0
    @State private var buttonSize: CGFloat = 80
    
    @State private var showJournalView: Bool = false

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
                    self.blurredColorWheelIsActive = (distance > maxDistance * 1.2) ? true : false
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
                
            }.updating($startLocation) { value, state, _ in
                // Set startLocation to current button position
                // It will reset once the gesture ends
                state = startLocation ?? location

            }.onEnded(onDragEnded(drag:))
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, fingerLocation, _ in
                fingerLocation = .active(location: value.location, translation: value.translation)
            }
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.location = self.originalPos
        self.isDragging = false
        self.blurredColorWheelIsActive = false
        self.isResetting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isResetting = false
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        //NavigationView {
        ZStack {
            GeometryReader { geometry in
                
                // Top Navigation
                HStack {
                    BackButton(action: self.backButtonPressed)
                    Spacer()
                    NextButton(isActive: $emotionTextFieldCompleted, action: self.nextButtonPressed)
                }
                .modifier(SlideIn(showHome: $showHome, noDelay: .constant(false)))
                .padding()
                .disabled(isResetting)

                // Main View
                VStack(spacing: 48) {
                    
                    // Date + EmotionTextField
                    VStack(spacing: 36) {
                        Text(Date(), formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                            .modifier(SlideOut(showHome: $showHome))
                            .padding(.top, 16)
                        ZStack {
                            Text("Hi, how are you feeling today?")
                                .momoTextBold()
                                .modifier(SlideOut(showHome: $showHome))
                            VStack(spacing: 6) {
                                EmotionTextField(text: $emotionText, textFieldIsFocused: $textFieldIsFocused)
                                    .modifier(SlideIn(showHome: $showHome, noDelay: $textFieldIsFocused))
                                TextFieldBorder(showHome: $showHome, textFieldIsFocused: $textFieldIsFocused)
                            }
                        }
                        .onChange(of: emotionText) { field in
                            self.emotionTextFieldCompleted = field.isEmpty ? false : true
                        }
                        .frame(width: 180, height: 80)
                    }
                    
                    // Blob
                    ZStack {
                        BlobView(pct: $pct, isStatic: false)
                        VStack {
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(originalPos.x)), y:\(Int(originalPos.y))")
                            Text("Starting Location: x:\(Int(startLocation?.x ?? 0)), y:\(Int(startLocation?.y ?? 0))")
                            Text("Current Pos: x:\(Int(location?.x ?? 0)), y:\(Int(location?.y ?? 0))")
                            Text("Angle: \(Int(degrees))")
                            Text(isDragging ? "dragging..." : "")
                            Text(isResetting ? "resetting..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(blurredColorWheelIsActive ? "rainbow..." : "")
                        }
                    }
                    
                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(isActive: $blurredColorWheelIsActive, degrees: $blurredColorWheelDegrees)
                            .position(self.originalPos)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .center) {
                                AddEmotionButton(showHome: $showHome, isAnimating: $isAnimating, buttonSize: $buttonSize, action: self.addEmotionButtonPressed)
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
                                SeeEntriesButton(action: self.seeEntriesButtonPressed)
                                    .offset(y: 60)
                                    .modifier(SlideOut(showHome: $showHome))
                            }
                            .position(self.location ?? CGPoint(x: geometry.size.width / 2, y: buttonSize / 2))
                            .highPriorityGesture(showHome ? nil : simpleDrag.simultaneously(with: fingerDrag))
                            
                            // Temp gesture to show finger location
                            if let fingerLocation = dragState {
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                    .position(fingerLocation.location)
                            }
                        }
                        .onAppear {
                            self.originalPos = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
                            self.location = self.originalPos }
                    }
                    .padding(.top, 64)
                }
                // END: - Main View
                //}
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(Image("background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
            .onChange(of: showHome) { _ in
                self.showButtonText.toggle()
                self.isAnimating.toggle()
                UIApplication.shared.endEditing() }
            .onChange(of: degrees) { value in
                switch value {
                case 0..<120: blurredColorWheelDegrees = 0
                case 120..<240: blurredColorWheelDegrees = 120
                case 240..<360: blurredColorWheelDegrees = 240
                default: blurredColorWheelDegrees = 0 }}
        }
    }
    
    // MARK: - Internal Methods
    
    private func addEmotionButtonPressed() {
        if showHome { showHome.toggle() }
    }
    
    private func seeEntriesButtonPressed() {
        //self.showJournalView.toggle()
    }
    
    // Navigation Buttons
    private func backButtonPressed() {
        self.showHome.toggle()
    }
    
    private func nextButtonPressed() {
        print("Confirmation Page")
    }
    
}

// MARK: - Views

struct EmotionTextField: View {
    @Binding var text: String
    @Binding var textFieldIsFocused: Bool

    var body: some View {
        ZStack(alignment: .center) {
            // Makeshift Placeholder
            Text("My day in a word")
                .momoTextBold(opacity: text.isEmpty ? 0.6 : 0)
            TextField("", text: $text, onEditingChanged: { editingChanged in
                textFieldIsFocused = editingChanged ? true : false
            }, onCommit: {
                // TODO: ???
                print(text)
            })
            .textFieldStyle(EmotionTextFieldStyle())
            .onReceive(text.publisher.collect()) { _ in
                self.text = String(text.prefix(20))
            }
        }
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
            Text("See your past entries").underline()
        }.buttonStyle(MomoTextLinkStyle())
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        MomoAddMoodView()
    }
}
