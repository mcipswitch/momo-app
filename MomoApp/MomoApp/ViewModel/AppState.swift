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
    var page: Page = .home

    // Journal
    var activeJournal: JournalType = .chart

    // JournalChartView
    var numOfEntries: Int = 7
    var selectedEntry: Entry = .defaultEntry
    var lineChartAnimationOn = false
    var selectionLineAnimationOn = false









    var blobValue: CGFloat = .zero
    var emotionText: String = ""
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
    case addEntryPressed

    case page(action: PageAction)
    case entry(index: Int, action: EntryAction)

    case lineChart(action: LineChartAction)

    case home(action: HomeAction)
    case journal(action: JournalAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var uuid: () -> UUID
}

// MARK: - HomeReducer

enum HomeAction: Equatable {
    case blobValueChanged(CGFloat)

    case emotionTextFieldChanged(text: String)
    case emotionTextFieldFocused(Bool)
    case activateDoneButton
    case activateColorWheel(Bool)
}

struct HomeEnvironment {
}

// MARK: - PageReducer

enum PageAction: Equatable {
    case pageChanged(Page)
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

// MARK: - Journal Actions

enum JournalAction: Equatable {
    case activeJournalChanged(JournalType)
}

// MARK: - LineChart Actions

enum LineChartAction: Equatable {
    case selectEntry(Int)
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
        case .addEntryPressed:
            state.entries.append(
                Entry(emotion: state.emotionText,
                      date: Date(),
                      value: state.blobValue)
            )

            state.currentStatus = .edit
            return .none
        case .journal(action: .activeJournalChanged(let journal)):
            state.activeJournal = journal
            return .none

//            struct CancelDelayID: Hashable {}
//            return
//                Effect(value: AppAction.journal(
//                    action: journal == .graph
//                        ? .showJournalChart
//                        : .showJournalList
//                ))
//                .debounce(id: CancelDelayID(),
//                          for: 0.5,
//                          scheduler: env.mainQueue)








        case .entry(index: let index, action: let action):
            return .none





        case .page(action: .pageChanged(let page)):
            state.page = page

            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startLineChartAnimation))
                .debounce(id: CancelDelayID(),
                          for: 0.4,
                          scheduler: env.mainQueue)

        case .lineChart(action: .startLineChartAnimation):
            state.lineChartAnimationOn.toggle()

            struct CancelDelayID: Hashable {}
            return
                Effect(value: AppAction.lineChart(action: .startSelectionLineAnimation))
                .debounce(id: CancelDelayID(),
                          for: 1.8,
                          scheduler: env.mainQueue)

        case .lineChart(action: .startSelectionLineAnimation):
            state.selectionLineAnimationOn.toggle()
            return .none
        case .lineChart(action: .selectEntry(let idx)):
            state.selectedEntry = state.journalEntries[idx]
            return .none












        case .home(action: .emotionTextFieldChanged(text: let text)):
            state.emotionText = text
            return .none





        case .home(action: .blobValueChanged(let value)):
            state.blobValue = value
            return .none
        case .home(action: .activateDoneButton):
            return .none
        case .home(action: .emotionTextFieldFocused(let isFocused)):
            state.emotionTextFieldFocused = isFocused
            return .none


        case .home(action: .activateColorWheel(let on)):
            state.colorWheelOn = on
            return .none
        }
    }
)
.debug()


// MARK: - Enums

enum Page {
    case home
    case journal
}
