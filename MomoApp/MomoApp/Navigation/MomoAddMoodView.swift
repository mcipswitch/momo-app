//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct MomoAddMoodView: View {
    //    @ObservedObject private var textLimiter = TextLimiter(limit: 5)
    @State private var homeViewActive: Bool = true
    
    // Stored Original Position
    @State private var originalPos = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil
    @GestureState private var dragState: DragState = .inactive
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var currentLocation: CGPoint? = nil
    
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    
    @State private var isDragging: Bool = false
    @State private var isAnimating: Bool = false
    @State private var isResetting: Bool = false
    
    // Emotion Text Field
    @State private var emotionText = ""
    @State private var textFieldIsFocused: Bool = false
    @State private var emotionTextFieldCompleted: Bool = false

    // Blurred Color Wheel
    @State private var blurredColorWheelIsActive: Bool = false
    @State private var blurredColorWheelDegrees: Double = 0

    private var buttonSize: CGFloat = 80

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
                    self.buttonLocation = CGPoint(x: locationX, y: locationY)
                } else {
                    self.buttonLocation = newLocation
                }
                
                guard let location = buttonLocation else { return }
                self.degrees = location.angle(to: startLocation)
                self.pct = self.degrees / 360
                
            }.updating($startLocation) { value, state, _ in
                // Set startLocation to current button position
                // It will reset once the gesture ends
                state = startLocation ?? buttonLocation
            }.onEnded(onDragEnded(drag:))
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, fingerLocation, _ in
                fingerLocation = .active(location: value.location, translation: value.translation)
            }
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.buttonLocation = self.originalPos
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
                .modifier(SlideIn(showHome: $homeViewActive, noDelay: .constant(false)))
                .padding()
                .disabled(isResetting)

                // Main View
                VStack(spacing: 48) {
                    
                    // Date + EmotionTextField
                    VStack(spacing: 36) {
                        Text(Date(), formatter: DateFormatter.shortDate)
                            .dateText(opacity: 0.6)
                            .modifier(SlideOut(showHome: $homeViewActive))
                            .padding(.top, 16)
                        ZStack {
                            Text("Hi, how are you feeling today?")
                                .momoTextBold()
                                .modifier(SlideOut(showHome: $homeViewActive))
                            VStack(spacing: 6) {
                                EmotionTextField(text: $emotionText, textFieldIsFocused: $textFieldIsFocused)
                                    .modifier(SlideIn(showHome: $homeViewActive, noDelay: $textFieldIsFocused))
                                TextFieldBorder(showHome: $homeViewActive, textFieldIsFocused: $textFieldIsFocused)
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
                            Text(self.homeViewActive ? "Home Active" : "")
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(originalPos.x)), y:\(Int(originalPos.y))")
                            Text("Starting Location: x:\(Int(startLocation?.x ?? 0)), y:\(Int(startLocation?.y ?? 0))")
                            Text("Current Pos: x:\(Int(buttonLocation?.x ?? 0)), y:\(Int(buttonLocation?.y ?? 0))")
                            Text("Angle: \(Int(degrees))")
                            //Text(isDragging ? "dragging..." : "")
                            Text(dragState.isActive ? "active drag" : "")

                            Text(isResetting ? "resetting..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(!homeViewActive ? "H.animating..." : "")
                            //Text(blurredColorWheelIsActive ? "rainbow..." : "")
                        }
                    }
                    
                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(isActive: $blurredColorWheelIsActive, degrees: $blurredColorWheelDegrees)
                            .position(self.originalPos)

                        // TODO: CLEAN UP ANIMATION HERE
                        GeometryReader { geometry in
                            ZStack(alignment: .center) {

                                // TODO: Remove $isAnimating
                                AddEmotionButton(homeViewActive: $homeViewActive, isAnimating: $isAnimating, buttonSize: buttonSize, action: self.addEmotionButtonPressed)
                                    /*
                                     Add delay so the 'Color Ring' disappears first.
                                     Remove delay if the button is resetting position.
                                     */
                                    .animation(dragState.isActive ? .default : Animation
                                                .bounce()
                                                .delay(if: self.homeViewActive, (isResetting ? 0 : 0.2))
                                    )

                                // TODO: Remove $isAnimating
                                ColorRing(size: buttonSize, shiftColors: $isAnimating, isDragging: $isDragging)
                                    .blur(radius: isAnimating ? 0 : 2)
                                    .opacity(isAnimating ? 1 : 0)
                                    .scaleEffect(isAnimating ? 1 : 1.1)
                                    /*
                                     Add delay so the 'Color Ring' appears after button morph.
                                     Remove delay if the button is resetting position.
                                     */
                                    .animation(dragState.isActive ? .default :
                                                self.homeViewActive ? .default : Animation
                                                .bounce()
                                                .delay(if: !self.homeViewActive, (isResetting ? 0 : 0.6))
                                    )
                                SeeEntriesButton(action: self.seeEntriesButtonPressed)
                                    .offset(y: 60)
                                    .modifier(SlideOut(showHome: $homeViewActive))
                            }
                            .position(self.buttonLocation ?? CGPoint(x: geometry.size.width / 2,
                                                               y: buttonSize / 2))
                            .highPriorityGesture(self.homeViewActive ? nil : simpleDrag.simultaneously(with: fingerDrag))
                            
                            // Temp gesture to show finger location
                            if let dragState = dragState {
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                    .position(dragState.location)
                                    .opacity(dragState.isActive ? 1 : 0)
                            }
                        }
                        .onAppear {
                            // Set original position to center
                            self.originalPos = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
                            self.buttonLocation = self.originalPos
                        }
                    }
                    .padding(.top, 64)
                }
                // END: - Main View
                //}
            }
            //.navigationBarHidden(true)
            //.navigationBarBackButtonHidden(true)
            .background(Image("background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
            )
            .onChange(of: homeViewActive) { _ in
                self.isAnimating.toggle()
                UIApplication.shared.endEditing()
            }
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
        self.homeViewActive ? self.homeViewActive.toggle() : nil
    }
    
    private func seeEntriesButtonPressed() {
        //self.showJournalView.toggle()
    }
    
    // Navigation Buttons
    private func backButtonPressed() {
        self.homeViewActive = true
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
    @Binding var homeViewActive: Bool
    @Binding var isAnimating: Bool
    @State var buttonSize: CGFloat
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Add today's emotion")
                .opacity(isAnimating ? 0 : 1)
                .animation(isAnimating
                            ? .none
                            : Animation.ease().delay(0.5)
                )
        }.buttonStyle(MomoButtonStyle(w: homeViewActive ? 230 : buttonSize,
                                      h: homeViewActive ? 60 : buttonSize))
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
