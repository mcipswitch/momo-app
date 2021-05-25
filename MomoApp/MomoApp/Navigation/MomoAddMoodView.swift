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
    @GestureState var dragState = DragState.inactive

    // TODO: - remove this eventually
    @State var dragStart: CGPoint = .zero

    var body: some View {
        ZStack {
            GeometryReader { geo in

                let joystickRadius = MomoButtonStyle.mainJoystick.size.w
                let centerPoint = CGPoint(x: geo.w / 2,
                                          y: joystickRadius / 2)

                // START: - Main View
                VStack {
                    MomoAddMoodMainTextView(viewStore: viewStore, geo: geo)

                    Spacer()

                    ZStack {
                        Blob(viewStore: viewStore, geo: geo)

//                        #if DEBUG
//                        VStack {
//                            Text("Home is Active: \(String(describing: self.viewStore.showHomeScreen))")
//                            Text("Degrees: \(Int(self.viewStore.joystickDegrees))")
//                            Text("Blob: \(self.viewStore.blobValue)")
//                        }
//                        .font(.system(size: 10))
//                        #endif
                    }
                    .padding(.bottom, 36)

                    Spacer()

                    // Bottom Navigation
                    ZStack {
                        JoystickColorWheel(
                            section: self.viewStore.binding(
                                keyPath: \.colorWheelSection,
                                send: AppAction.form),
                            isActivated: self.viewStore.binding(
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
                                        keyPath: \.showHomeScreen,
                                        send: AppAction.form
                                    )
                                )

                            Button(textLink: "See your past entries".localized) {
                                self.viewStore.send(.form(.set(\.showJournalView, true)))
                            }
                            .momoLinkStyle()
                            .offset(y: 60)
                            .slideInAnimation(
                                value: self.viewStore.binding(
                                    keyPath: \.showHomeScreen,
                                    send: AppAction.form
                                )
                            )
                        }
                        .offset(
                            x: self.viewStore.dragValue.width * 0.8,
                            y: self.viewStore.dragValue.height * 0.8
                        )
                        .position(self.viewStore.addEmotionButtonPosition ?? centerPoint)
                        .highPriorityGesture(self.viewStore.showHomeScreen ? nil : self.resistanceDrag)

//                        #if DEBUG
//                        Circle()
//                            .stroke(Color.red, lineWidth: 2)
//                            .frame(width: 20, height: 20)
//                            .position(self.dragState.location)
//                            .opacity(self.dragState.isActive ? 1 : 0)
//                        #endif
                    }
                    .frame(height: 160)
                    .onAppear {
                        self.dragStart = centerPoint
                        self.viewStore.send(.addEmotionButtonLocationChanged(self.dragStart))
                    }
                }
                // END: - Main View

                NavBar(viewStore: viewStore)
                    .slideOutAnimation(
                        value: self.viewStore.binding(
                            keyPath: \.showHomeScreen,
                            send: AppAction.form
                        )
                    )
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: .momo(.scale4),
                            bottom: .momo(.scale4),
                            trailing: .momo(.scale4)
                        )
                    )
            }
        }
        .padding(.vertical, .momo(.scale2))
        .momoBackground()
        .ignoresKeyboard()
    }
}

// MARK: - Internal Views

extension MomoAddMoodView {
    private var addEmotionButton: some View {
        ZStack {
            Button(action: {
                self.viewStore.send(.toggleShowHomeScreen)
            }) {
                // Animates the button's text smoothly
                Text(self.viewStore.currentStatus.text)
                    .opacity(self.viewStore.addEmotionButtonTextOn ? 1 : 0)
            }
            .momoButtonStyle(button: self.viewStore.currentButtonStyle)

            MomoUI.JoystickColorRing(
                showHomeScreen: self.viewStore.binding(
                    keyPath: \.showHomeScreen,
                    send: AppAction.form
                ),
                isDragging: self.viewStore.binding(
                    keyPath: \.joystickIsDragging,
                    send: AppAction.form
                )
            )
            .colorRingAnimation(
                value: self.viewStore.binding(
                    keyPath: \.showHomeScreen,
                    send: AppAction.form
                )
            )
        }
    }

    struct NavBar: View {
        @ObservedObject var viewStore: ViewStore<AppState, AppAction>

        var body: some View {
            HStack {
                MomoUI.NavBarButton(.momo(.back)) {
                    self.viewStore.send(.toggleShowHomeScreen)
                }
                Spacer()
                MomoUI.MainButton(style: .done,
                                  action: { self.viewStore.send(.showThankYouView) })
                    .disabled(viewStore.doneButtonDisabled)
            }
        }
    }

    struct Blob: View {
        @ObservedObject var viewStore: ViewStore<AppState, AppAction>
        var geo: GeometryProxy

        var body: some View {
            BlobView(blobValue: self.viewStore.binding(
                keyPath: \.blobValue,
                send: AppAction.form
            ))
            .momoBlobStyle(
                BlobStyle(frameSize: geo.h, scale: 0.35)
            )
        }
    }
}

// MARK: - MomoAddMoodMainTextView

struct MomoAddMoodMainTextView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    var geo: GeometryProxy

    var body: some View {
        VStack(spacing: 36) {
            Text(Date(), formatter: .standard)
                .momoText(.mainDateFont)
                .slideInAnimation(
                    value: self.viewStore.binding(
                        keyPath: \.showHomeScreen,
                        send: AppAction.form
                    )
                )
            ZStack {
                Text((viewStore.currentStatus == .add
                        ? "Hi, how are you feeling today?".localized
                        : viewStore.entries.last?.emotion) ?? String())
                .momoText(.mainMessageFont)
                .slideInAnimation(
                    value: self.viewStore.binding(
                        keyPath: \.showHomeScreen,
                        send: AppAction.form
                    )
                )
                .frame(width: 180)
                VStack(spacing: 6) {

                    // TODO: - `emotionTextFieldChanged` is being called all the time
                    MomoUI.TextField(text: self.viewStore.binding(
                        keyPath: \.emotionText,
                        send: AppAction.form
                    ), isFocused: self.viewStore.binding(
                        keyPath: \.emotionTextFieldFocused,
                        send: AppAction.form)
                    )
                    .slideOutAnimation(
                        value: self.viewStore.binding(
                            keyPath: \.showHomeScreen,
                            send: AppAction.form
                        )
                    )
                    MomoUI.TextFieldBorder(isFocused: self.viewStore.binding(
                                            keyPath: \.emotionTextFieldFocused,
                                            send: AppAction.form))
                        .textFieldBorderAnimation(
                            value: self.viewStore.binding(
                                keyPath: \.showHomeScreen,
                                send: AppAction.form
                            )
                        )
                }
                .frame(width: geo.w / 2, height: 80)
            }
        }
    }
}
