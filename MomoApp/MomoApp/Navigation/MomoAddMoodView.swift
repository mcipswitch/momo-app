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
    @State private var buttonTextOn = true

    // UI Elements
    @State private var text = ""
    @State private var textFieldIsFocused = false
    @State private var textFieldNotEmpty = false
    @State private var colorWheelOn = false

    // Add Emotion Button
    @GestureState private var dragState: DragState = .inactive
    @State private var dragValue = CGSize.zero
    @State private var dragStart = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil

    @State private var state: EntryState = .add

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let joystickRadius = ButtonType.joystick.size.w
                let centerPoint = CGPoint(x: geo.w / 2, y: joystickRadius / 2)

                // START: - Main View
                VStack {
                    // Date + TextField
                    VStack(spacing: 36) {
                        currentDate
                            .slideInAnimation(value: self.$homeViewActive)
                        ZStack {
                            helloMessage
                                .slideInAnimation(value: self.$homeViewActive)
                                .frame(width: 180)
                            VStack(spacing: 6) {
                                textField
                                    .slideOutAnimation(value: self.$homeViewActive)
                                textFieldBorder
                                    .textFieldBorderAnimation(value: self.$homeViewActive)
                            }
                            .frame(width: geo.w / 2, height: 80)
                        }
                    }

                    Spacer()

                    // Blob
                    ZStack {
                        BlobView(blobValue: $blobValue)
                            .msk_applyBlobStyle(BlobStyle(frameSize: geo.h, scale: 0.35))

                        #if DEBUG
                        VStack {
                            Text("Home: \(String(describing: homeViewActive))")
                            Text("Degrees: \(Int(degrees))")
                            Text("Blob: \(blobValue)")
                            Text("Drag Start: x:\(Int(dragStart.x)), y:\(Int(dragStart.y))")
                            Text("Dragging: \(String(describing: dragState.isActive))")
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
                            .opacity(self.colorWheelOn ? 1 : 0)
                            .animation(.activateColorWheel, value: self.colorWheelOn)

                        // Joystick + Past Entries
                        ZStack(alignment: .center) {
                            addEmotionButton
                                // Add delay so the 'Color Ring' disappears first.
                                .animation(.resist, value: self.dragState.isActive)
                                .addEmotionButtonAnimation(value: self.$homeViewActive)
                            MomoLinkButton(.pastEntries, action: self.pastEntriesButtonPressed)
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
        .addMomoBackground()
        .onChange(of: self.degrees) { degrees in
            self.colorWheelSection = self.viewLogic.colorWheelSection(degrees)
            self.blobValue = self.viewLogic.blobValue(degrees)
        }
        .onChange(of: self.homeViewActive) { _ in
            // This state is needed to animate button text opacity
            self.buttonTextOn.toggle()

            // TODO: - WTF is this?
            UIApplication.shared.endEditing()
        }
        // TODO: - Fix this later
        .onReceive(self.viewRouter.homeWillChange) { state in
            self.homeViewActive = (state == .home)
        }
    }
}

// MARK: - Internal Methods

extension MomoAddMoodView {
    private func addEmotionButtonPressed() {
        self.viewRouter.changeHomeState(.add)
    }

    private func pastEntriesButtonPressed() {
        self.viewRouter.change(to: .journal)
    }

    private func backButtonPressed() {
        self.viewRouter.changeHomeState(.home)
    }

    private func doneButtonPressed() {
        self.viewRouter.changeHomeState(.done)

        // TODO: - Add this page
        print("Emotion: \(self.text), Value: \(self.blobValue)")
    }
}

// MARK: - Internal Views

extension MomoAddMoodView {
    private var addEmotionButton: some View {
        ZStack {
            Button(action: self.addEmotionButtonPressed) {
                Text(self.state.text)
                    .opacity(self.buttonTextOn ? 1 : 0)
                    .animation(self.buttonTextOn ? Animation.ease.delay(0.5) : nil)
            }
            .msk_applyMomoButtonStyle(button: self.homeViewActive ? .standard : .joystick)
            ColorRing(
                homeViewActive: self.$homeViewActive,
                isDragging: self.$isDragging
            )
            .colorRingAnimation(value: self.$homeViewActive)
        }
    }

    private var topNavigation: some View {
        HStack {
            MomoToolbarButton(.back, action: self.backButtonPressed)
            Spacer()
            MomoButton(button: .done,
                       action: self.doneButtonPressed,
                       isActive: self.$textFieldNotEmpty)
                .animation(.ease, value: self.textFieldNotEmpty)
        }
    }

    private var helloMessage: some View {
        Text("Hi, how are you feeling today?".localized)
            .msk_applyTextStyle(.mainMessageFont)
    }

    private var currentDate: some View {
        Text(Date(), formatter: .shortDate)
            .msk_applyTextStyle(.mainDateFont)
    }

    private var textField: some View {
        MomoTextField(self.$text.onChange(self.textChanged), isFocused: self.$textFieldIsFocused)
    }

    fileprivate func textChanged(_ text: String) {
        self.textFieldNotEmpty = !text.isEmpty
    }

    private var textFieldBorder: some View {
        MomoTextFieldBorder(isFocused: self.$textFieldIsFocused)
    }
}

// MARK: - Drag Gestures

// TODO: - refactor this drag gesture into view modifier?
extension MomoAddMoodView {

    /// Please see: https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged
    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged(self.onDragChanged(drag:))
            .updating($dragState) { value, state, _ in
                state = .active(location: value.location, translation: value.translation)
            }
            .onEnded(self.onDragEnded(drag:))
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

        // Do nothing if joystick is just tapped
        if self.joystickTapped { return }

        // Calculate distance to activate 'BlurredColorWheel'
        let maxDistance: CGFloat = 50
        var newLocation = self.dragStart
        newLocation.x += xOff
        newLocation.y += yOff
        let distance = self.dragStart.distance(to: newLocation)
        self.colorWheelOn = distance > maxDistance ? true : false

        // Calculate the degrees to activate 'BlurredColorWheel' section
        self.degrees = newLocation.angle(to: self.dragStart)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.isDragging = false
        self.dragValue = .zero
        self.colorWheelOn = false
    }

    #if DEBUG
    var fingerDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragState) { value, fingerLocation, _ in
                fingerLocation = .active(location: value.location, translation: value.translation)
            }
    }
    #endif

    // MARK: - Helper vars

    private var joystickTapped: Bool {
        self.dragValue == .zero
    }
}
