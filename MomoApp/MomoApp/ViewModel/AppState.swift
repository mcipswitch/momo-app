//
//  AppState.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-01-08.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Domain

struct AppState: Equatable {
    var entries: [Entry]
    var numOfEntries: Int = 7
    var selectedEntry: Entry = .defaultEntry
    var page: Page?

    var emotionText: String = ""
    var emotionTextNotNil: Bool = false

    /// Last week (7) of entries
    var journalEntries: [Entry] {
        self.entries.suffix(self.numOfEntries)
    }

    /// Data points for line chart
    var dataPoints: [CGFloat] {
        self.entries.suffix(self.numOfEntries + 1).map(\.value)
    }
}

enum AppAction {
    case addEntryPressed

    case page(action: PageAction)
    case entry(index: Int, action: EntryAction)

    case lineChart(action: LineChartAction)

    case home(action: HomeAction)
}

struct AppEnvironment {
    //var fetchPage: () -> Effect<Page, Never>
}

// MARK: - HomeReducer

enum HomeAction {
    case emotionTextFieldChanged(text: String)
    case activateDoneButton
}

struct HomeEnvironment {
}

// MARK: - LineChartReducer

enum LineChartAction {
    case selectEntry(Int)
}

struct LineChartEnvironment {
}

// MARK: - PageReducer

enum PageAction {
    case pageChanged(Page)
}

// MARK: - EntryReducer

enum EntryAction {
    case entryEmotionChanged(Double)
    case entryTextFieldChanged(String)
}

struct EntryEnvironment {
}

let entryReducer = Reducer<Entry, EntryAction, EntryEnvironment> { state, action, environment in
    switch action {
    case .entryEmotionChanged(let value):
        return .none
    case .entryTextFieldChanged(let text):
        return .none
    }
}
.debug()

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    entryReducer.forEach(
        state: \AppState.entries,
        action: /AppAction.entry(index:action:),
        environment: { _ in EntryEnvironment() }
    ),
    Reducer { state, action, env in
        switch action {
        case .addEntryPressed:
            state.entries.insert(Entry(emotion: "Sunflower", date: Date(), value: 0.86), at: 0)
            return .none
        case .entry(index: let index, action: let action):
            return .none
        case .page(action: .pageChanged(let page)):
            state.page = page
            return .none
        case .lineChart(action: .selectEntry(let idx)):
            state.selectedEntry = state.journalEntries[idx]
            return .none


        case .home(action: .emotionTextFieldChanged(text: let text)):
            state.emotionText = text
            return .none
        case .home(action: .activateDoneButton):
            return .none
        }
    }
)
.debug()
