//
//  AppState.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-01-08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var entries: [Entry]
    var currentStatus: Status = .add
    var activePage: Page = .home
    var activeJournal: JournalType = .chart

    // MomoAddMoodView
    var homeViewIsActive = true
    var addEmotionButtonTextOn = true

    // Joystick
    var addEmotionButtonPosition: CGPoint? = nil

    var joystickIsDragging = false
    var dragValue = CGSize.zero
    var joystickDegrees: CGFloat = 0
    var colorWheelSection: ColorWheelSection = .momo
    var colorWheelOn = false

    // Line Chart
    var numOfEntries: Int = 7
    var selectedEntry: Entry = .default
    var lineChartAnimationOn = false
    var selectionLineAnimationOn = false




    var newIdx: Int = 0
    var selectedIdx: Int = 0

    var blobValue: CGFloat = .zero
    var emotionText: String = ""
    var doneButtonDisabled: Bool = true
    var emotionTextFieldFocused = false


}

// MARK: - Helper vars

extension AppState {
    /// Last 7 entries
    var journalEntries: [Entry] {
        self.entries.suffix(self.numOfEntries)
    }

    /// Data points for line chart
    var dataPoints: [CGFloat] {
        self.entries.suffix(self.numOfEntries + 1).map(\.value)
    }
}

// MARK: - AppAction

enum AppAction: Equatable {
    case entry(index: Int, action: EntryAction)
    case lineChart(action: LineChartAction)
    case form(FormAction<AppState>)

    case joystickDegreesChanged(CGFloat, Bool)
    case joystickDragValueChanged(CGSize)
    case dismissKeyboard

    case addEmotionButtonLocationChanged(CGPoint)

    case toggleHomeViewIsActive
    case toggleAddEmotionButtonText
}

struct AppEnvironment { }
//var mainQueue: AnySchedulerOf<DispatchQueue>
//var uuid: () -> UUID

// MARK: - EntryReducer

enum EntryAction: Equatable {
    case emotionValueChanged(CGFloat)
    case emotionTextChanged(String)
}

struct EntryEnvironment {}

let entryReducer = Reducer<Entry, EntryAction, EntryEnvironment> { state, action, env in
    switch action {
    case .emotionValueChanged(let value):
        state.value = value
        return .none
    case .emotionTextChanged(let text):
        state.emotion = text
        return .none
    }
}
.debug()

// MARK: - LineChart Actions

enum LineChartAction: Equatable {
    case startLineChartAnimation
    case startSelectionLineAnimation
}

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    entryReducer.forEach(
        state: \AppState.entries,
        action: /AppAction.entry(index:action:),
        environment: { _ in EntryEnvironment() }
    ),

    Reducer { state, action, env in
        switch action {
        case let .addEmotionButtonLocationChanged(position):
            state.addEmotionButtonPosition = position
            return .none

        case .entry(index: let index, action: let action):
            return .none

        case .toggleHomeViewIsActive:
            state.homeViewIsActive.toggle()

            return Effect.merge(
                Effect(value: AppAction.toggleAddEmotionButtonText)
                    .delay(for: 0, scheduler: DispatchQueue.main.animation(
                        state.addEmotionButtonTextOn
                            ? nil
                            : Animation.ease.delay(0.6)
                    ))
                    .eraseToEffect(),
                state.homeViewIsActive
                    ? Effect(value: AppAction.dismissKeyboard)
                    : .none
            )

        case .toggleAddEmotionButtonText:
            state.addEmotionButtonTextOn.toggle()
            return .none








        // Joystick
        case .joystickDegreesChanged(let degrees, let activateColorWheel):
            state.joystickDegrees = degrees
            state.colorWheelSection = JoystickLogic.colorWheelSection(degrees)
            state.blobValue = JoystickLogic.blobValue(degrees)

            state.colorWheelOn = activateColorWheel

            // TODO: - add animation here to the colorWheelSection, can remove from the view

            return .none

        case let .joystickDragValueChanged(dragValue):
            state.dragValue = dragValue
            return .none

        // TODO: - why doesn't this work????
        case .form(\.emotionText):
            state.emotionText = state.emotionText.applyCharLimit(16)
            return .none


        case .form(\.joystickIsDragging):
            if !state.joystickIsDragging {
                state.colorWheelOn = false
                state.dragValue = .zero
            }
            return .none

        case .form(\.activePage):
            state.lineChartAnimationOn = false
            state.selectionLineAnimationOn = false

            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startLineChartAnimation))
                .debounce(id: CancelDelayID(),
                          for: 0.4,
                          scheduler: DispatchQueue.main.animation(.easeInOut(duration: 2.0)))

        case .lineChart(action: .startLineChartAnimation):
            state.lineChartAnimationOn.toggle()

            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startSelectionLineAnimation))
                .debounce(id: CancelDelayID(),
                          for: 1.8,
                          scheduler: DispatchQueue.main.animation(.easeInOut(duration: 1.0)))
        case .lineChart(action: .startSelectionLineAnimation):
            state.selectionLineAnimationOn.toggle()
            return .none

        case .form:
            return .none

        case .dismissKeyboard:
            UIApplication.shared.endEditing()
            return .none
        }
    }
)
.form(action: /AppAction.form)
.debug()

// MARK: - Enums

enum Page {
    case home
    case journal
}

// MARK: - FormAction

struct FormAction<Root>: Equatable {
    let keyPath: PartialKeyPath<Root>
    let value: AnyHashable
    let setter: (inout Root) -> Void

    init<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) where Value: Hashable {
        self.keyPath = keyPath
        self.value = value
        self.setter = { $0[keyPath: keyPath] = value }
    }

    static func set<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) -> Self where Value: Hashable {
        .init(keyPath, value)
    }

    static func == (lhs: FormAction<Root>, rhs: FormAction<Root>) -> Bool {
        lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
    }
}
