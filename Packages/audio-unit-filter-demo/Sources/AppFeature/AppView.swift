
import ComposableArchitecture
import FilterDemo
import SwiftUI
import FilterView

public struct AppState: Equatable {
    var titleText: String
    
    var filter: FilterState
    
    public init() {
        titleText = "Play"
        filter = FilterState()
    }
}

public enum AppAction: Equatable {
    case filter(FilterAction)
    case playButtonTapped
    case toggleView
    case cutoffSliderValueChanged(Float)
    case resonanceSliderValueChanged(Float)
}

public struct AppEnvironment {
    var audioUnitManager: AudioUnitManager
    
    public init() {
        audioUnitManager = AudioUnitManager()
    }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .filter(_):
        return .none
        
    case .playButtonTapped:
        let isPlaying = environment.audioUnitManager.togglePlayback()  //TODO: Effect...
        state.titleText = isPlaying ? "Stop" : "Play"
        return .none
    
    case .toggleView:
        environment.audioUnitManager.toggleView() //TODO: Effect...
        return .none
    
    case let .cutoffSliderValueChanged(value):
        state.filter.cutoff = value
        environment.audioUnitManager.cutoffValue = frequencyValueForSliderLocation(value)
        return .none

    case let .resonanceSliderValueChanged(value):
        state.filter.resonance = value
        environment.audioUnitManager.resonanceValue = value
        return .none
    
    }
}.debug()

func frequencyValueForSliderLocation(_ location: Float) -> Float {
    
    let defaultMinHertz: Float = 12.0
    let defaultMaxHertz: Float = 20_000.0
    
    var value = pow(2, location)
    value = (value - 1) / 511

    value *= (defaultMaxHertz - defaultMinHertz)

    return value + defaultMinHertz
}

//MARK: View

public struct AppView: SwiftUI.View {

    public let store: Store<AppState, AppAction>
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
    }
    
    public var body: some  SwiftUI.View {
        WithViewStore(self.store) { viewStore in
            
            VStack {
                HStack {
                    Spacer()
                    Button(viewStore.titleText) {
                        viewStore.send(.playButtonTapped)
                    }
                    Button("Toggle Views") {
                        viewStore.send(.toggleView)
                    }
                    Spacer()
                }
                HStack {
                    VStack {
                        Text("Cutoff")
                        Text("Resonance")
                    }
                    VStack {
                        Slider(
                            value: viewStore.binding(
                                get: \.filter.cutoff,
                                send: AppAction.cutoffSliderValueChanged
                            ),
                            in: .init(uncheckedBounds: (lower: 0.0, upper: 9.0))
                        ) {
                            Text("Cutoff")
                        }
                        Slider(
                            value: viewStore.binding(
                                get: \.filter.resonance,
                                send: AppAction.resonanceSliderValueChanged
                            ),
                            in: .init(uncheckedBounds: (lower: -20.0, upper: 20.0))
                        ) {
                            Text("Resonance")
                        }
                    }
                }
                FilterViewContainer(store: self.store.scope(state: \.filter, action: AppAction.filter))
                    
            }
            
        }
    }
}


//MARK: Preview
#if DEBUG

struct AppView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        return AppView(store: Store(
                        initialState: AppState(),
                        reducer: appReducer,
                        environment: .init()
                        )
        )
            .environment(\.colorScheme, .light)
    }
}
#endif
