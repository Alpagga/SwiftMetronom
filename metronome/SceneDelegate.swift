import UIKit
import SwiftUI

@available(iOS 16.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    #if targetEnvironment(macCatalyst)
    let controller = (UIApplication.shared.delegate as! AppDelegate).controller
    #else
    let controller = MasterController()
    #endif
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        NSUbiquitousKeyValueStore.default.synchronize()
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = KeyboardAwareUIHostingController(view: contentView.environmentObject(controller), controller: controller)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        NSUbiquitousKeyValueStore.default.synchronize()
        controller.saveStuff()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        NSUbiquitousKeyValueStore.default.synchronize()
        controller.saveStuff()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        if controller.isPlaying { controller.stop() }
        NSUbiquitousKeyValueStore.default.synchronize()
        controller.saveStuff()
    }
    
}
