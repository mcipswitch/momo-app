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
    @GestureState private var dragState = DragState.inactive

    // TODO: - remove this eventually
    @State private var dragStart = CGPoint.zero

    private var isEditMode: Bool {
        self.viewStore.currentStatus == .edit
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in

                let joystickRadius = ButtonType.joystick.size.w
                let centerPoint = CGPoint(
                    x: geo.w / 2,
                    y: joystickRadius / 2
                )

                // START: - Main View
                VStack {
                    // Date + TextField
                    VStack(spacing: 36) {
                        currentDate
                            .slideInAnimation(
                                value: self.viewStore.binding(
                                    keyPath: \.homeViewIsActive,
                                    send: AppAction.form
                                )
                            )
                        ZStack {
                            helloMessage
                                .slideInAnimation(
                                    value: self.viewStore.binding(
                                        keyPath: \.homeViewIsActive,
                                        send: AppAction.form
                                    )
                                )
                                .frame(width: 180)
                            VStack(spacing: 6) {
                                textField
                                    .slideOutAnimation(
                                        value: self.viewStore.binding(
                                            keyPath: \.homeViewIsActive,
                                            send: AppAction.form
                                        )
                                    )
                                textFieldBorder
                                    .textFieldBorderAnimation(
                                        value: self.viewStore.binding(
                                            keyPath: \.homeViewIsActive,
                                            send: AppAction.form
                                        )
                                    )
                            }
                            .frame(width: geo.w / 2, height: 80)
                        }
                    }

                    Spacer()

                    // Blob
                    ZStack {
                        BlobView(
                            blobValue: self.viewStore.binding(
                                keyPath: \.blobValue,
                                send: AppAction.form
                            )
                        )
                        .msk_applyBlobStyle(BlobStyle(frameSize: geo.h, scale: 0.35))

                        #if DEBUG
                        VStack {
                            Text("Home is Active: \(String(describing: self.viewStore.homeViewIsActive))")
                            Text("Degrees: \(Int(self.viewStore.joystickDegrees))")
                            Text("Blob: \(self.viewStore.blobValue)")
                            Text("Drag Start: x:\(Int(dragStart.x)), y:\(Int(dragStart.y))")
                            Text("Dragging: \(String(describing: self.viewStore.joystickIsDragging))")
                        }
                        .font(.system(size: 12.0))
                        #endif
                    }
                    .padding(.bottom, 36)

                    Spacer()

                    // Bottom Navigation
                    ZStack {
                        BlurredColorWheel(
                            section: self.viewStore.binding(
                                keyPath: \.colorWheelSection,
                                send: AppAction.form
                            ), isActivated: self.viewStore.binding(
                                keyPath: \.colorWheelOn,
                                send: AppAction.form
                            )
                        )
                        .position(self.dragStart)

                        // Joystick + Past Entries
                        ZStack(alignment: .center) {
                            addEmotionButton
                                // Add delay so the 'Color Ring' disappears first.
                                .animation(.resist, value: self.viewStore.joystickIsDragging)
                                .addEmotionButtonAnimation(
                                    value: self.viewStore.binding(
                                        keyPath: \.homeViewIsActive,
                                        send: AppAction.form
                                    )
                                )
                            MomoLinkButton(.pastEntries) {
                                self.viewStore.send(.form(.set(\.activePage, .journal)))
                            }
                            .offset(y: 60)
                            .slideInAnimation(
                                value: self.viewStore.binding(
                                    keyPath: \.homeViewIsActive,
                                    send: AppAction.form
                                )
                            )
                        }
                        .offset(
                            x: self.viewStore.dragValue.width * 0.8,
                            y: self.viewStore.dragValue.height * 0.8
                        )
                        .position(self.viewStore.addEmotionButtonPosition ?? centerPoint)
                        .highPriorityGesture(self.viewStore.homeViewIsActive ? nil : self.resistanceDrag)

                        #if DEBUG
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                            .frame(width: 20, height: 20)
                            .position(self.dragState.location)
                            .opacity(self.dragState.isActive ? 1 : 0)
                        #endif
                    }
                    .frame(height: 160)
                    .onAppear {
                        self.dragStart = centerPoint
                        self.viewStore.send(.addEmotionButtonLocationChanged(self.dragStart))
                    }
                }
                // END: - Main View

                topNavigation
                    .slideOutAnimation(
                        value: self.viewStore.binding(
                            keyPath: \.homeViewIsActive,
                            send: AppAction.form
                        )
                    )
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
        }
        .padding(.vertical)
        .addMomoBackground()
        .ignoresKeyboard()
    }
}

// MARK: - Internal Views

extension MomoAddMoodView {
    private var addEmotionButton: some View {
        ZStack {
            Button(action: {
                self.viewStore.send(.toggleHomeViewIsActive)
            }, label: {
                Text(self.viewStore.currentStatus.text)
                    .opacity(self.viewStore.addEmotionButtonTextOn ? 1 : 0)
            })
            .msk_applyMomoButtonStyle(button: self.viewStore.homeViewIsActive ? .standard : .joystick)
            ColorRing(
                homeViewActive: self.viewStore.binding(
                    keyPath: \.homeViewIsActive,
                    send: AppAction.form
                ),
                isDragging: self.viewStore.binding(
                    keyPath: \.joystickIsDragging,
                    send: AppAction.form
                )
            )
            .colorRingAnimation(
                value: self.viewStore.binding(
                    keyPath: \.homeViewIsActive,
                    send: AppAction.form
                )
            )
        }
    }

    private var topNavigation: some View {
        HStack {
            MomoToolbarButton(.backButton) {
                self.viewStore.send(.toggleHomeViewIsActive)
            }

            Spacer()

            // TODO: - Fix the done button
            MomoButton(
                button: self.isEditMode ? .doneConfirmed : .done,
                action: {
                    self.viewStore.send(.form(.set(\.currentStatus, .edit)))
                },
                disabled: self.viewStore.binding(
                    get: \.doneButtonDisabled,
                    send: AppAction.form(.set(\.doneButtonDisabled, self.viewStore.emotionText.isEmpty))
                )
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

    // TODO: - `emotionTextFieldChanged` is being called all the time
    private var textField: some View {
        MomoTextField(text: self.viewStore.binding(
            keyPath: \.emotionText,
            send: AppAction.form
        ), isFocused: self.viewStore.binding(
            keyPath: \.emotionTextFieldFocused,
            send: AppAction.form)
        )
    }

    private var textFieldBorder: some View {
        MomoTextFieldBorder(isFocused: self.viewStore.binding(
            keyPath: \.emotionTextFieldFocused,
            send: AppAction.form)
        )
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
        self.viewStore.send(.form(.set(\.joystickIsDragging, true)))

        /// The lower the limit, the tighter the resistance
        let limit: CGFloat = 200
        let xOff = drag.translation.width
        let yOff = drag.translation.height
        let dist = sqrt(xOff*xOff + yOff*yOff);
        let factor = 1 / (dist / limit + 1)

        self.viewStore.send(
            .joystickDragValueChanged(CGSize(width: xOff * factor,
                                             height: yOff * factor))
        )

        // Do nothing if joystick is just tapped
        if self.joystickTapped {
            return
        }

        // Calculate distance to activate 'BlurredColorWheel'
        let minDistance: CGFloat = 50
        var newLocation = self.dragStart
        newLocation.x += xOff
        newLocation.y += yOff
        let distance = self.dragStart.distance(to: newLocation)

        // Calculate degrees to activate corresponding color wheel section
        let degrees = newLocation.angle(to: self.dragStart)

        // Activate the color wheel if joystick is passed minimum distance
        var activateColorWheel: Bool {
            distance > minDistance
        }
        self.viewStore.send(.joystickDegreesChanged(degrees, activateColorWheel))
    }

    private func onDragEnded(drag: DragGesture.Value) {
        self.viewStore.send(.form(.set(\.joystickIsDragging, false)))
    }

    // MARK: - Helper vars

    private var joystickTapped: Bool {
        self.viewStore.dragValue == .zero
    }
}
