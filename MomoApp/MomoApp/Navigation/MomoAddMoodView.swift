//
//  MomoAddMoodView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI

struct MomoAddMoodView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var viewLogic = AddMoodViewLogic()

    @State private var homeViewActive = true
    
    @State private var blobValue: CGFloat = 0
    @State private var degrees: CGFloat = 0
    @State private var colorWheelSection: ColorWheelSection = .momo
    
    @State private var isDragging = false
    @State private var isAnimating = false

    // UI Elements
    @State private var text = ""
    @State private var textFieldIsFocused = false
    @State private var textFieldNotEmpty = false
    @State private var colorWheelIsActive = false

    // Add Emotion Button
    @GestureState private var dragState: DragState = .inactive
    @State private var dragValue = CGSize.zero
    @State private var dragStart = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil

    @State private var state: EntryState = .add

    @State private var navigationButtonPressed = false

    // MARK: - Drag Gestures
    // https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged

    var resistanceDrag: some Gesture {
        // Set minimum distance to avoid joystick tapping
        DragGesture(minimumDistance: 0.1)
            .onChanged(onDragChanged(drag:))
            .updating($dragState) { value, state, _ in
                state = .active(location: value.location, translation: value.translation)
            }
            .onEnded(onDragEnded(drag:))
    }

    private func onDragChanged(drag: DragGesture.Value) {
        self.isDragging = true

        /// The lower the limit, the tigher the resistance
        let limit: CGFloat = 200
        let xOff = drag.translation.width
        let yOff = drag.translation.height
        let dist = sqrt(xOff*xOff + yOff*yOff);
        let factor = 1 / (dist / limit + 1)
        self.dragValue = CGSize(width: xOff * factor,
                                height: yOff * factor)

        // Calculate distance to activate 'BlurredColorWheel'
        let maxDistance: CGFloat = 50
        var newLocation = self.dragStart
        newLocation.x += xOff
        newLocation.y += yOff
        let distance = self.dragStart.distance(to: newLocation)
        self.colorWheelIsActive = distance > maxDistance ? true : false

        // Calculate the degrees to activate correct part of 'BlurredColorWheel'
        self.degrees = newLocation.angle(to: self.dragStart)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.isDragging = false
        self.dragValue = .zero
        self.colorWheelIsActive = false
    }
    
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, fingerLocation, _ in
                fingerLocation = .active(location: value.location, translation: value.translation)
            }
    }

    // MARK: - Body

    // TODO: - Adjust blob so it is 20% of the screen height

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let centerPoint = CGPoint(x: geo.size.width / 2, y: ButtonType.joystick.size.w / 2)

                // Main View
                VStack {
                    // Date + TextField
                    VStack(spacing: 36) {
                        currentDate
                            .slideInAnimation(value: self.$homeViewActive)

                        ZStack {
                            helloMessage
                                .slideInAnimation(value: self.$homeViewActive)
                                //.frame(width: 180)
                                .frame(width: 180, height: 80)
                            VStack(spacing: 6) {
                                textField
                                    .slideOutAnimation(value: self.$homeViewActive)
                                textFieldBorder
                                    .msk_applyTextFieldBorderAnimation(value: self.$homeViewActive)
                            }
                            //.frame(width: geo.size.width / 2)
                            .frame(width: geo.size.width / 2, height: 80)
                        }
                    }

                    Spacer()

                    // Blob
                    ZStack {
                        BlobView(blobValue: $blobValue)
                            .msk_applyBlobStyle(BlobStyle(frameSize: geo.size.height, scale: 0.35))

                        #if DEBUG
                        VStack {
                            Text(self.homeViewActive ? "Home Active" : "Home Inactive")
                            Text("Degrees: \(Int(degrees))")
                            Text("Blob: \(blobValue)")
                            Text("Original Pos: x:\(Int(dragStart.x)), y:\(Int(dragStart.y))")
                            Text("Button Pos: x:\(Int(buttonLocation?.x ?? 0)), y:\(Int(buttonLocation?.y ?? 0))")
                            Text(dragState.isActive ? "dragging..." : "")
                            Text(isAnimating ? "animating..." : "")
                        }
                        .font(.system(size: 12.0))
                        #endif
                    }
                    .padding(.bottom, 36)

                    Spacer()

                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(section: self.$colorWheelSection)
                            .position(self.dragStart)
                            .opacity(self.colorWheelIsActive ? 1 : 0)
                            .animation(.activateColorWheel, value: self.colorWheelIsActive)

                        // Joystick + Past Entries
                        ZStack(alignment: .center) {
                            AddEmotionButton(
                                entryState: self.$state,
                                homeViewActive: self.$homeViewActive,
                                isAnimating: self.$isAnimating,
                                isDragging: self.$isDragging,
                                action: self.addEmotionButtonPressed
                            )
                            // Add delay so the 'Color Ring' disappears first.
                            .animation(.resist, value: self.dragState.isActive)
                            .animation(Animation.bounce.delay(if: self.homeViewActive, 0.2), value: self.homeViewActive)

                            MomoLinkButton(
                                link: .pastEntries,
                                action: self.seePastEntriesButtonPressed
                            )
                            .offset(y: 60)
                            .slideInAnimation(value: self.$homeViewActive)
                        }
                        .offset(x: self.dragValue.width * 0.8, y: self.dragValue.height * 0.8)
                        .position(self.buttonLocation ?? centerPoint)
                        .highPriorityGesture(self.homeViewActive ? nil : self.resistanceDrag)

                        #if DEBUG
                        if let dragState = dragState {
                            Circle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .position(dragState.location)
                                .opacity(dragState.isActive ? 1 : 0)
                        }
                        #endif
                    }
                    .frame(height: 160)
                    .onAppear {
                        self.dragStart = centerPoint
                        self.buttonLocation = self.dragStart
                    }
                }
                // END: - Main View





                topNavigation
                    .slideOutAnimation(value: self.$homeViewActive)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }


        }
        .padding(.vertical)

        .msk_applyMomoBackground()

        .onChange(of: self.homeViewActive) { _ in
            self.isAnimating.toggle()
            UIApplication.shared.endEditing()
        }
        .onChange(of: self.degrees) { degrees in
            self.colorWheelSection = self.viewLogic.activateColorWheelSection(degrees: degrees)
            self.blobValue = self.viewLogic.calculateBlobValue(degrees: degrees)
        }
        .onReceive(self.viewRouter.homeWillChange) { state in
            self.homeViewActive = (state == .home)
        }
    }

    // MARK: - Internal Views

    private var topNavigation: some View {
        HStack {
            MomoToolbarButton(button: .back,
                              action: self.backButtonPressed)
            Spacer()
            MomoButton(button: .done,
                       action: self.doneButtonPressed,
                       isActive: self.$textFieldNotEmpty)
                .animation(.ease, value: self.textFieldNotEmpty)
        }
    }

    private var helloMessage: some View {
        Text(NSLocalizedString("Hi, how are you feeling today?", comment: ""))
            .msk_applyTextStyle(.mainMessageFont)
    }

    private var currentDate: some View {
        Text(Date(), formatter: DateFormatter.shortDate)
            .msk_applyTextStyle(.mainDateFont)
    }

    private var textField: some View {
        MomoTextField(text: $text,
                      textFieldIsFocused: $textFieldIsFocused
        )
        .onChange(of: self.text) { text in
            self.textFieldNotEmpty = !text.isEmpty
        }
    }

    private var textFieldBorder: some View {
        MomoTextFieldBorder(isFocused: self.$textFieldIsFocused)
    }
}

// MARK: - Internal Methods

extension MomoAddMoodView {

    private func addEmotionButtonPressed() {
        self.viewRouter.changeHomeState(.add)
    }

    private func seePastEntriesButtonPressed() {
        self.viewRouter.change(to: .journal)
    }

    private func backButtonPressed() {
        self.navigationButtonPressed.toggle()

        self.viewRouter.changeHomeState(.home)
    }

    private func doneButtonPressed() {
        self.navigationButtonPressed.toggle()

        self.viewRouter.changeHomeState(.done)

        print("Emotion: \(self.text), Value: \(self.blobValue)")
    }
}

// MARK: - Internal Views

struct AddEmotionButton: View {
    @Binding var entryState: EntryState
    @Binding var homeViewActive: Bool
    @Binding var isAnimating: Bool
    @Binding var isDragging: Bool
    let action: () -> Void

    var body: some View {
        ZStack {
            Button(action: self.action) {
                Text(self.entryState.text)
                    .opacity(self.isAnimating ? 0 : 1)
                    .animation(self.isAnimating
                                ? .none
                                : Animation.ease.delay(0.5)
                    )
            }
            .msk_applyMomoButtonStyle(button: homeViewActive ? .standard : .joystick)

            // Add delay so this appears after button morph
            ColorRing(
                isAnimating: self.$isAnimating,
                isDragging: self.$isDragging
            )
            .animation(Animation.bounce.delay(if: !homeViewActive, 0.6), value: self.homeViewActive)
        }
    }
}
