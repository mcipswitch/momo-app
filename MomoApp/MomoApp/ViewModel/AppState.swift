//
//  AppState.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2021-01-08.
//

import Foundation
import Combine

struct AppState {
    var entries: [Entry]
    var page: Page
}

enum AppAction {
    case change(to: Page)

    case home(HomeAction)
    case journal(JournalAction)
}

// MARK: - Pages

enum HomeAction {
    case prepareToAdd
    case add(entry: Entry)
}

enum JournalAction {
    case toggle(to: JournalType)
}




// MARK: - Store

/// Store object that stores app state and provides read-only access to it
final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer
            .reduce(state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: perform)
            .store(in: &cancellables)
    }

    private func perform(change: Reducer<State, Action>.Change) {
        change(&state)
    }
}

// MARK: - Reducers and Actions

//typealias Reducer<State, Action> = (inout State, Action) -> Void

extension Reducer where State == AppState, Action == AppAction {
    static func appReducer() -> Reducer {
        let viewRouter: ViewRouter = .init()
        let viewModel: EntriesViewModel = .init(dataManager: MockDataManager())

        return Reducer { state, action in
            switch action {
            case .change(let page):
                viewRouter.changePage(to: page)
            case .home(let action):
                handleHomeAction(action, viewModel: viewModel)
            case .journal(let action):
                handleJournalAction(action, viewRouter: viewRouter)
            }


            return Reducer.sync { state in
                //state.entries =
            }
        }
    }

    private static func handleHomeAction(_ action: HomeAction, viewModel: EntriesViewModel) {
        switch action {
        case .prepareToAdd:
            break
        case .add(let entry):
            break
        }
    }

    private static func handleJournalAction(_ action: JournalAction, viewRouter: ViewRouter) {
        switch action {
        case .toggle(let journal):
            viewRouter.toggleJournal(to: journal)
        }
    }
}








// MARK: -

struct Reducer<State, Action> {
    typealias Change = (inout State) -> Void
    let reduce: (State, Action) -> AnyPublisher<Change, Never>
}

extension Reducer {
    static func sync(_ fun: @escaping (inout State) -> Void) -> AnyPublisher<Change, Never> {
        Just(fun).eraseToAnyPublisher()
    }
}
