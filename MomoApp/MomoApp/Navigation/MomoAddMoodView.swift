//
//  MomoAddMoodView.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-08-17.
//

import SwiftUI
import ComposableArchitecture

struct MomoAddMoodView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    var viewLogic = AddMoodViewLogic()

    @State private var homeViewActive = true
    @State private var degrees: CGFloat = 0
    @State private var colorWheelSection: ColorWheelSection = .momo

    @State private var isDragging = false
    @State private var buttonTextOn = true

    // Add Emotion Button
    @GestureState private var dragState: DragState = .inactive
    @State private var dragValue = CGSize.zero
    @State private var dragStart = CGPoint.zero
    @State private var buttonLocation: CGPoint? = nil

    @State private var state: Status = .add

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
                        BlobView(blobValue: self.viewStore.binding(
                                    get: \.blobValue,
                                    send: { .home(action: .blobValueChanged($0)) })
                        )
                        .msk_applyBlobStyle(BlobStyle(frameSize: geo.h, scale: 0.35))

                        #if DEBUG
                        VStack {
                            Text("Home: \(String(describing: homeViewActive))")
                            Text("Degrees: \(Int(degrees))")
                            Text("Blob: \(self.viewStore.blobValue)")
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
                            .opacity(self.viewStore.colorWheelOn ? 1 : 0)
                            .animation(.activateColorWheel, value: self.viewStore.colorWheelOn)

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
                        .offset(
                            x: self.dragValue.width * 0.8,
                            y: self.dragValue.height * 0.8
                        )
                        .position(self.buttonLocation ?? centerPoint)
                        .highPriorityGesture(self.homeViewActive ? nil : self.resistanceDrag)

                        #if DEBUG
//                        if let dragState = self.dragState {
//                            Circle()
//                                .stroke(Color.red, lineWidth: 2)
//                                .frame(width: 20, height: 20)
//                                .position(self.dragState.location)
//                                .opacity(self.dragState.isActive ? 1 : 0)
//                        }
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

            let blobValue = self.viewLogic.blobValue(degrees)
            self.viewStore.send(.home(action: .blobValueChanged(blobValue)))

        }
        .onChange(of: self.homeViewActive) { isHome in
            // This state is needed to animate button text opacity
            self.buttonTextOn.toggle()

            if isHome {
                self.dismissKeyboard()
            }
        }
        .ignoresKeyboard()
    }
}

// MARK: - Internal Methods

extension MomoAddMoodView {
    private func dismissKeyboard() {
        UIApplication.shared.endEditing()
    }

    private func addEmotionButtonPressed() {
        self.homeViewActive.toggle()
    }

    private func pastEntriesButtonPressed() {
        self.viewStore.send(.page(action: .pageChanged(.journal)))
    }

    private func backButtonPressed() {
        self.homeViewActive.toggle()
    }

    private func doneButtonPressed() {
        self.viewStore.send(.addEntryPressed)
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
            ColorRing(homeViewActive: self.$homeViewActive,
                      isDragging: self.$isDragging)
                .colorRingAnimation(value: self.$homeViewActive)
        }
    }

    private var topNavigation: some View {
        HStack {
            MomoToolbarButton(.back, action: self.backButtonPressed)

            Spacer()

            MomoButton(button: .done,
                       action: self.doneButtonPressed,
                       isActive: self.viewStore.binding(
                        get: \.emotionText.isNotEmpty,
                        send: .home(action: .activateDoneButton))
            )
            .animation(.ease, value: self.viewStore.emotionText.isEmpty)
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

    // TODO: - Fix why `emotionTextFieldChanged` is being called all the time
    private var textField: some View {
        MomoTextField(text: viewStore.binding(
            get: \.emotionText,
            send: { .home(action: .emotionTextFieldChanged(text: $0)) }
        ),
        isFocused: viewStore.binding(
            get: \.emotionTextFieldFocused,
            send: { .home(action: .emotionTextFieldFocused($0)) }
        ))
    }

    private var textFieldBorder: some View {
        MomoTextFieldBorder(isFocused: self.viewStore.binding(
            get: \.emotionTextFieldFocused,
            send: { .home(action: .emotionTextFieldFocused($0)) }
        ))
    }
}

// MARK: - Drag Gestures

extension MomoAddMoodView {

    /// Please see: https://stackoverflow.com/questions/62268937/swiftui-how-to-change-the-speed-of-drag-based-on-distance-already-dragged
    var resistanceDrag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged(self.onDragChanged(drag:))
            .updating(self.$dragState) { value, state, _ in
                state = .active(location: value.location, translation: value.translation)
            }
            .onEnded(self.onDragEnded(drag:))
    }

    private func onDragChanged(drag: DragGesture.Value) {
        self.isDragging = true

        /// The lower the limit, the tighter the resistance
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

        self.viewStore.send(.home(action: .activateColorWheel(distance > maxDistance)))


        // Calculate the degrees to activate corresponding color wheel section
        self.degrees = newLocation.angle(to: self.dragStart)
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.isDragging = false
        self.dragValue = .zero
        self.viewStore.send(.home(action: .activateColorWheel(false)))
    }

    // MARK: - Helper vars

    private var joystickTapped: Bool {
        self.dragValue == .zero
    }
}
