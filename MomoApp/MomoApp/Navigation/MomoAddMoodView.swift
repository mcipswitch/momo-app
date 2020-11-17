//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct MomoAddMoodView: View {

    @State private var homeViewActive: Bool = true
    
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

    // Add Emotion Button
    @GestureState private var dragState: DragState = .inactive
    @State private var dragValue = CGSize.zero
    @State private var dragStart = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil

    // MARK: - Drag Gestures
    // https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged

    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.isDragging = true

                // The lower the limit, the tighter the resistance
                let limit: CGFloat = 200
                let xOff = value.translation.width
                let yOff = value.translation.height
                let dist = sqrt(xOff*xOff + yOff*yOff);
                let factor = 1 / (dist / limit + 1)
                self.dragValue = CGSize(width: value.translation.width * factor,
                                        height: value.translation.height * factor)

                // Calculate distance to activate 'BlurredColorWheel'
                let maxDistance: CGFloat = 40
                var newLocation = self.dragStart
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                let distance = dragStart.distance(to: newLocation)
                self.blurredColorWheelIsActive = distance > maxDistance ? true : false

                // Calculate the degrees to activate correct part of 'BlurredColorWheel'
                self.degrees = newLocation.angle(to: dragStart)
                self.pct = self.degrees / 360

            }.updating($dragState) { value, state, transaction in
                state = .active(location: value.location, translation: value.translation)
                //transaction.animation = Animation.resist()
            }.onEnded { value in
                self.isDragging = false
                self.dragValue = .zero
                self.blurredColorWheelIsActive = false
                self.isResetting = true


                // https://swiftui.diegolavalle.com/posts/animation-ended/
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.isResetting = false
                }
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, fingerLocation, _ in
                fingerLocation = .active(location: value.location, translation: value.translation)
            }
    }
    
    // MARK: - Body
    
    var body: some View {
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
                            Text("Original Pos: x:\(Int(dragStart.x)), y:\(Int(dragStart.y))")
                            Text("Button Pos: x:\(Int(buttonLocation?.x ?? 0)), y:\(Int(buttonLocation?.y ?? 0))")
                            Text("Angle: \(Int(degrees))")
                            //Text(isDragging ? "dragging..." : "")
                            Text(dragState.isActive ? "active drag" : "")

                            Text(isResetting ? "resetting..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(!homeViewActive ? "H.animating..." : "")

                            Text("\(dragValue.width), \(dragValue.height)")

                        }
                    }

                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(isActive: $blurredColorWheelIsActive, degrees: $blurredColorWheelDegrees)
                            .position(self.dragStart)

                        // TODO: CLEAN UP ANIMATION HERE
                        GeometryReader { geometry in
                            ZStack(alignment: .center) {

                                // TODO: Remove $isAnimating
                                AddEmotionButton(homeViewActive: $homeViewActive, isAnimating: $isAnimating, buttonSize: buttonSize, action: self.addEmotionButtonPressed)
                                    /*
                                     Add delay so the 'Color Ring' disappears first.
                                     Remove delay if the button is resetting position.
                                     */
                                    .animation(dragState.isActive ? .resist() : Animation
                                                .bounce()
                                                .delay(if: self.homeViewActive, (isResetting ? 0 : 0.2))
                                    )

                                // TODO: Remove $isAnimating
//                                ColorRing(size: buttonSize, shiftColors: $isAnimating, isDragging: $isDragging)
//                                    .blur(radius: isAnimating ? 0 : 2)
//                                    .opacity(isAnimating ? 1 : 0)
//                                    .scaleEffect(isAnimating ? 1 : 1.1)
//                                    /*
//                                     Add delay so the 'Color Ring' appears after button morph.
//                                     Remove delay if the button is resetting position.
//                                     */
//                                    .animation(dragState.isActive ? .resist() :
//                                                self.homeViewActive ? .resist() : Animation
//                                                .bounce()
//                                                .delay(if: !self.homeViewActive, (isResetting ? 0 : 0.6))
//                                    )
                                SeeEntriesButton(action: self.seeEntriesButtonPressed)
                                    .offset(y: 60)
                                    .modifier(SlideOut(showHome: $homeViewActive))
                            }
                            .offset(x: self.dragValue.width * 0.5, y: self.dragValue.height * 0.5)
                            .onAnimationCompleted(for: dragValue.width, completion: {
                                print("COMPLETED!!!!!")
                            })







                            .position(self.buttonLocation ?? CGPoint(x: geometry.size.width / 2,
                                                                     y: buttonSize / 2))
                            .highPriorityGesture(self.homeViewActive ? nil : self.resistanceDrag)
                            .disabled(self.isResetting)

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
                            self.dragStart = CGPoint(x: geometry.size.width / 2, y: buttonSize / 2)
                            self.buttonLocation = self.dragStart
                        }
                    }
                    .padding(.top, 64)
                }
                // END: - Main View
            }
        }
        .background(Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: self.homeViewActive) { _ in
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

            // Placeholder
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

// MARK: - Old

//var simpleDrag: some Gesture {
//    DragGesture(minimumDistance: 0)
//        .onChanged { value in
//            self.isDragging = true
//
//            guard let startLocation = startLocation else { return }
//            let maxDistance: CGFloat = 40
//            var newLocation = startLocation
//            newLocation.x += value.translation.width
//            newLocation.y += value.translation.height
//            let distance = startLocation.distance(to: newLocation)
//            if distance > maxDistance {
//                self.blurredColorWheelIsActive = (distance > maxDistance * 1.2) ? true : false
//                let k = maxDistance / distance
//                let locationX = ((newLocation.x - startLocation.x) * k) + startLocation.x
//                let locationY = ((newLocation.y - startLocation.y) * k) + startLocation.y
//                self.buttonLocation = CGPoint(x: locationX, y: locationY)
//            } else {
//                self.buttonLocation = newLocation
//            }
//
//            guard let location = buttonLocation else { return }
//            self.degrees = location.angle(to: startLocation)
//            self.pct = self.degrees / 360
//
//        }.updating($startLocation) { value, state, _ in
//            // Set startLocation to current button position
//            // It will reset once the gesture ends
//            state = startLocation ?? buttonLocation
//        }.onEnded { value in
//            self.buttonLocation = self.originalPos
//            self.isDragging = false
//            self.blurredColorWheelIsActive = false
//            self.isResetting = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isResetting = false
//            }
//        }
//}
