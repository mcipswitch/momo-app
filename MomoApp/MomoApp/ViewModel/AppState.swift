//
//  AppState.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-01-08.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Domain

enum EntryStatus: Equatable {
    case add
    case edit
}

struct AppState: Equatable {
    var entries: [Entry]
    var currentStatus: EntryStatus = .add
    var activePage: Page = .home
    var activeJournal: JournalType = .chart

    // JournalChartView
    var numOfEntries: Int = 7
    var selectedEntry: Entry = .default
    var lineChartAnimationOn = false
    var selectionLineAnimationOn = false

    var newIdx: Int = 0
    var selectedIdx: Int = 0

    var blobValue: CGFloat = .zero
    var emotionText: String = ""
    var doneButtonOn: Bool = false
    var emotionTextFieldFocused = false
    var colorWheelOn = false



    var reversedEntries: [Entry] {
        self.entries.reversed()
    }

    /// Last week (7) of entries
    var journalEntries: [Entry] {
        self.entries.suffix(self.numOfEntries)
    }

    /// Data points for line chart
    var dataPoints: [CGFloat] {
        self.entries.suffix(self.numOfEntries + 1).map(\.value)
    }
}

enum AppAction: Equatable {
    case entry(index: Int, action: EntryAction)
    case lineChart(action: LineChartAction)
    case form(FormAction<AppState>)
}

struct AppEnvironment {
//    var mainQueue: AnySchedulerOf<DispatchQueue>
//    var uuid: () -> UUID
}

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
        case .entry(index: let index, action: let action):
            return .none

        case .lineChart(action: .startLineChartAnimation):
            state.lineChartAnimationOn.toggle()

            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startSelectionLineAnimation))
                .debounce(id: CancelDelayID(),
                          for: 1.8,
                          scheduler: DispatchQueue.main)
        case .lineChart(action: .startSelectionLineAnimation):
            state.selectionLineAnimationOn.toggle()
            return .none

        case .form(\.activePage):
            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startLineChartAnimation))
                .debounce(id: CancelDelayID(),
                          for: 0.4,
                          scheduler: DispatchQueue.main)

        case .form:
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

// MARK: - Reducer + Extension

func ~= <Root, Value> (
    keyPath: WritableKeyPath<Root, Value>,
    formAction: FormAction<Root>
) -> Bool {
    formAction.keyPath == keyPath
}

extension Reducer {
    func form(
        action formAction: CasePath<Action, FormAction<State>>
    ) -> Self {
        Self { state, action, environment in
            guard let formAction = formAction.extract(from: action) else {
                return self.run(&state, action, environment)
            }

            formAction.setter(&state)
            return self.run(&state, action, environment)
        }
    }
}

// MARK: - ViewStore + Extension

extension ViewStore {
    func binding<Value>(
        keyPath: WritableKeyPath<State, Value>,
        send action: @escaping (FormAction<State>) -> Action
    ) -> Binding<Value> where Value: Hashable {
        self.binding(
            get: { $0[keyPath: keyPath] },
            send: { action(.init(keyPath, $0)) }
        )
    }
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
