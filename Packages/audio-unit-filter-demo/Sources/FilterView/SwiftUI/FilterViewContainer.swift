//
//  SwiftUIView.swift
//  
//
//  Created by Anders Östlin on 2021-05-27.
//

import ComposableArchitecture
import SwiftUI

public struct FilterState: Equatable {
    
    public var cutoff: Float
    public var resonance: Float
    
    public init() {
        cutoff = 5.0
        resonance = 0
    }
}

public enum FilterAction: Equatable {
    case touchBegan
    case didChangeResonance(Float)
    case didChangeFrequency(Float)
    case didChangeFrequencyAndResonance(Float, Float)
}

public struct FilterViewContainer: SwiftUI.View {
    let store: Store<FilterState, FilterAction>
    
    public init(store: Store<FilterState, FilterAction>) {
        self.store = store
    }
    
    public var body: some SwiftUI.View {
        WithViewStore(self.store) { viewStore in
            FilterViewRepresentable(viewStore: viewStore)
                .frame(width: 400, height: 400, alignment: .center)
//            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

struct FilterViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewStore: ViewStore<FilterState, FilterAction>
    
    public init(viewStore: ViewStore<FilterState, FilterAction>) {
        self.viewStore = viewStore
    }
    
    public func makeUIView(context: UIViewRepresentableContext<FilterViewRepresentable>) -> FilterView {
        let fv = FilterView()
        fv.delegate = context.coordinator
        fv.awakeFromNib()
        
        return fv
    }
    public func updateUIView(_ filterView: FilterView, context: UIViewRepresentableContext<FilterViewRepresentable>) {
        filterView.frequency = viewStore.cutoff
        filterView.resonance = viewStore.resonance
    }
    
    //MARK: Coordinator

    public func makeCoordinator() -> FilterViewRepresentable.Coordinator {
        Coordinator(self.viewStore)
    }
        
    final public class Coordinator: NSObject, FilterViewDelegate {
        
        private var viewStore: ViewStore<FilterState, FilterAction>

        init(_ viewStore: ViewStore<FilterState, FilterAction>) {
            self.viewStore = viewStore
        }
        
        public func filterViewTouchBegan(_ filterView: FilterView) {
            viewStore.send(.touchBegan)
        }
        
        public func filterView(_ filterView: FilterView, didChangeResonance resonance: Float) {
            viewStore.send(.didChangeResonance(resonance))

        }
        
        public func filterView(_ filterView: FilterView, didChangeFrequency frequency: Float) {
            viewStore.send(.didChangeFrequency(frequency))

        }
        
        public func filterView(_ filterView: FilterView, didChangeFrequency frequency: Float, andResonance resonance: Float) {
            viewStore.send(.didChangeFrequencyAndResonance(frequency, resonance))
        }
        
        public func filterViewTouchEnded(_ filterView: FilterView) {
            //TODO:
        }
        
        public func filterViewDataDidChange(_ filterView: FilterView) {
            //TODO:
        }
        
        
    }

}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some SwiftUI.View {
//        FilterViewRepresentable(viewStore: <#ViewStore<FilterState, FilterAction>#>)
//            .frame(width: 400, height: 400, alignment: .center)
//    }
//}
