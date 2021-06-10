
import AppFeature
import ComposableArchitecture
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    let store = Store(
        initialState: .init(),
        reducer: appReducer,
        environment: .live
    )

    lazy var viewStore = ViewStore(self.store)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

@main
struct AUv3Filter: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AppView(store: self.appDelegate.store)
        }
        .onChange(of: self.scenePhase) { _ in 
//            self.appDelegate.viewStore.send(.didChangeScenePhase($0))
        }
    }
}
