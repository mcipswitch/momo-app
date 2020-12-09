//
//  AddMoodProfile.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

enum EmotionState {
    case add, edit
    var text: String {
        switch self {
        case .add:
            return "Add today's emotion"
        case .edit:
            return "Edit today's emotion"
        }
    }
}

struct MomoAddMoodView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    @State private var homeViewActive = true
    @State private var addViewActive = false
    @State private var doneViewActive = false
    
    @State private var pct: CGFloat = 0
    @State private var degrees: CGFloat = 0
    @State private var colorWheelSection: ColorWheelSection = .momo
    
    @State private var isDragging = false
    @State private var isAnimating = false
    @State private var isResetting = false
    
    // Emotion Text Field
    @State private var emotionText = ""
    @State private var textFieldIsFocused = false
    @State private var emotionTextFieldCompleted = false

    // Blurred Color Wheel
    @State private var blurredColorWheelIsActive = false

    // Add Emotion Button
    @GestureState private var dragState: DragState = .inactive
    @State private var dragValue = CGSize.zero
    @State private var dragStart = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil

    @State private var state: EmotionState = .add

    private var buttonSize: CGFloat = 80
    
    // MARK: - Drag Gestures
    // https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged

    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.isDragging = true

                /// The lower the limit, the tigher the resistance
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
                let centerPoint = CGPoint(x: geometry.size.width / 2, y: self.buttonSize / 2)

                // Main View
                VStack(spacing: 48) {

                    // Date + EmotionTextField
                    VStack(spacing: 36) {
                        currentDate
                            .slideInAnimation(if: self.$homeViewActive)
                            .padding(.top, 16)

                            // Animate in controls after done view
                            .opacity(self.doneViewActive ? 0 : 1)
                            .animation(
                                Animation.easeInOut(duration: 1.0)
                                    .delay(self.doneViewActive ? 0 : 2.0)
                            )

                        ZStack {
                            // TODO: - Placeholder should animate out immediately if writing
                            Text("Hi, how are you feeling today?")
                                .momoText(.main)
                                .slideInAnimation(if: self.$homeViewActive)

                                // Animate in controls after done view
                                .opacity(self.doneViewActive ? 0 : 1)
                                .animation(
                                    Animation.easeInOut(duration: 1.0)
                                        .delay(self.doneViewActive ? 0 : 2.0)
                                )

                            VStack(spacing: 6) {
                                MomoTextField(text: $emotionText, textFieldIsFocused: $textFieldIsFocused)
                                    .animateHomeState(inValue: self.$addViewActive, outValue: self.$doneViewActive)
                                MomoTextFieldBorder(textFieldIsFocused: self.$textFieldIsFocused)
                                    .animateTextFieldBorder(inValue: self.$addViewActive, outValue: self.$doneViewActive)
                            }
                        }
                        .onChange(of: self.emotionText) { field in
                            self.emotionTextFieldCompleted = field.isEmpty ? false : true
                        }
                        .frame(width: 180, height: 80)
                    }

                    // Blob
                    ZStack {
                        BlobView(blobValue: $pct, isStatic: false)
                        VStack {
                            Text(self.homeViewActive ? "Home Active" : "Home Inactive")
                            Text("Pct: \(pct)")
                            Text("Original Pos: x:\(Int(dragStart.x)), y:\(Int(dragStart.y))")
                            Text("Button Pos: x:\(Int(buttonLocation?.x ?? 0)), y:\(Int(buttonLocation?.y ?? 0))")
                            Text("Angle: \(Int(degrees))")
                            Text(dragState.isActive ? "active drag" : "")
                            Text(isResetting ? "resetting..." : "")
                            Text(isAnimating ? "animating..." : "")
                            Text(!homeViewActive ? "H.animating..." : "")

                            Text("\(dragValue.width), \(dragValue.height)")
                        }
                        .font(.system(size: 12.0))
                    }

                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(
                            isActive: self.$blurredColorWheelIsActive,
                            section: self.$colorWheelSection
                        )
                        .position(self.dragStart)

                        // TODO: CLEAN UP ANIMATION HERE
                        GeometryReader { geometry in
                            ZStack(alignment: .center) {

                                // TODO: Remove $isAnimating
                                AddEmotionButton(emotionState: self.$state, homeViewActive: self.$homeViewActive, isAnimating: self.$isAnimating, buttonSize: self.buttonSize, action: self.addEmotionButtonPressed)
                                    /*
                                     Add delay so the 'Color Ring' disappears first.
                                     Remove delay if the button is resetting position.
                                     */
                                    .animation(dragState.isActive ? .resist() : Animation
                                                .bounce()
                                                .delay(if: self.homeViewActive, (isResetting ? 0 : 0.2))
                                    )

                                // TODO: Remove $isAnimating
                                ColorRing(
                                    size: self.buttonSize,
                                    shiftColors: self.$isAnimating,
                                    isDragging: self.$isDragging
                                )
                                    /*
                                     Add delay so the 'Color Ring' appears after button morph.
                                     Remove delay if the button is resetting position.
                                     */
                                    .animation(dragState.isActive ? .resist() :
                                                self.homeViewActive ? .resist() : Animation
                                                .bounce()
                                                .delay(if: !self.homeViewActive, (isResetting ? 0 : 0.6))
                                    )

                                MomoTextLinkButton(link: .pastEntries, action: self.seePastEntriesButtonPressed)
                                    .offset(y: 60)
                                    .slideInAnimation(if: self.$homeViewActive)
                            }
                            // Animate in controls after done view
                            .opacity(self.doneViewActive ? 0 : 1)
                            .animation(
                                Animation.easeInOut(duration: 1.0)
                                    .delay(self.doneViewActive ? 0 : 2.0)
                            )







                            .offset(x: self.dragValue.width * 0.8, y: self.dragValue.height * 0.8)
                            .position(self.buttonLocation ?? centerPoint)
                            .highPriorityGesture(self.homeViewActive ? nil : self.resistanceDrag)
                            .disabled(self.isResetting)

                            if let dragState = dragState {
                                Circle()
                                    .stroke(Color.red, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                    .position(dragState.location)
                                    .opacity(dragState.isActive ? 1 : 0)
                            }
                            
                        }
                        .onAppear {
                            self.dragStart = centerPoint
                            self.buttonLocation = self.dragStart
                        }
                    }
                    .padding(.top, 64)
                }
                // END: - Main View

                topNavigation
                    .animateHomeState(inValue: self.$addViewActive, outValue: self.$doneViewActive)
                    .padding()
                    .disabled(self.isResetting)

                    .opacity(self.doneViewActive ? 0 : 1)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .delay(self.doneViewActive ? 0 : 2.0)
                    )


            }
        }
        .background(
            ZStack {
                RadialGradient.momo
                RadialGradient.done
                    .opacity(self.doneViewActive ? 1 : 0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .delay(if: self.doneViewActive, 0)
                    )
            }
            .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: self.homeViewActive) { _ in
            self.isAnimating.toggle()
            UIApplication.shared.endEditing()
        }
        .onChange(of: self.degrees) { degrees in
            switch degrees {
            case 0..<120: self.colorWheelSection = .momo
            case 120..<240: self.colorWheelSection = .momoPurple
            case 240..<360: self.colorWheelSection = .momoOrange
            default: break
            }
        }
        .onReceive(self.viewRouter.homeWillChange) { state in
            switch state {
            case .home:
                self.homeViewActive = true
                self.addViewActive = false
                self.doneViewActive = false
            case .add:
                self.homeViewActive = false
                self.addViewActive = true
                self.doneViewActive = false
            case .done:
                self.doneViewActive = true
            }
        }
    }

    // MARK: - Views

    var topNavigation: some View {
        HStack {
            MomoToolbarButton(type: .back, action: self.backButtonPressed)
            Spacer()
            MomoButton(isActive: self.$emotionTextFieldCompleted, type: .done, action: self.doneButtonPressed)
        }
    }

    var currentDate: some View {
        Text(Date(), formatter: DateFormatter.shortDate)
            .momoText(.date)
    }
    
    // MARK: - Internal Methods
    
    private func addEmotionButtonPressed() {
        self.viewRouter.changeHomeState(.add)

        // Joystick is not draggable until animation settles
        self.isResetting = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            self.isResetting = false
        }
    }
    
    private func seePastEntriesButtonPressed() {
        self.viewRouter.change(to: .journal)
    }

    private func backButtonPressed() {
        //self.homeViewActive = true
        self.viewRouter.changeHomeState(.home)
    }
    
    private func doneButtonPressed() {
        self.viewRouter.changeHomeState(.done)

        print("Emotion: \(self.emotionText), Value: \(self.pct)")

        // Reset to home page after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewRouter.changeHomeState(.home)
        }
    }
}

// MARK: - Views

struct AddEmotionButton: View {
    @Binding var emotionState: EmotionState
    @Binding var homeViewActive: Bool
    @Binding var isAnimating: Bool
    @State var buttonSize: CGFloat
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(self.emotionState.text)
                .opacity(isAnimating ? 0 : 1)
                .animation(isAnimating
                            ? .none
                            : Animation.ease().delay(0.5)
                )
        }
        .buttonStyle(MomoButtonStyle(w: homeViewActive ? 230 : self.buttonSize,
                                     h: homeViewActive ? 60 : self.buttonSize))
    }
}

// MARK: - Previews

struct AddMoodProfile_Previews: PreviewProvider {
    static var previews: some View {
        MomoAddMoodView()
    }
}
