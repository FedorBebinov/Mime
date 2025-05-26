//
//  SceneDelegate.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 21.08.2023.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let service = NetworkService()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if service.isAuthorized{
            window.rootViewController = UINavigationController(rootViewController: MenuViewController(isOnboarding: false))
        }else {
            window.rootViewController = UINavigationController(rootViewController: StartViewController())
        }
            window.makeKeyAndVisible()
            self.window = window
        
        if UserDefaults.standard.firstLaunchDateSeconds == 0 {
            UserDefaults.standard.firstLaunchDateSeconds = Date.now.timeIntervalSince1970
        }

        UserDefaults.standard.register(defaults: ["WhiteTheme": false,
                                                  "HapticsActive": true,
                                                  "SoundActive": true])
        if UserDefaults.standard.bool(forKey: "WhiteTheme") {
            window.overrideUserInterfaceStyle = .light
        } else {
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
                    return
                }
        guard firstUrl.host == "room" else{
            return
        }
        let path = firstUrl.path
        let components = path.split(separator: "/")
        guard components.count == 1 else {
            return
        }
        let roomId = String(components[0])
        print(roomId)
        guard service.isAuthorized else{
            return
        }
        guard let vc = window?.rootViewController as? UINavigationController else{
            return
        }
        vc.setViewControllers([MenuViewController(isOnboarding: false), CallViewController(isEnter: true, isOnboarding: false, roomId: roomId)], animated: true)
    }
}
