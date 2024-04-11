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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        if service.isAuthorized{
            window.rootViewController = UINavigationController(rootViewController: MenuViewController(isOnboarding: false))
        }else {
            window.rootViewController = UINavigationController(rootViewController: StartViewController())
        }
            window.makeKeyAndVisible()
            self.window = window
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { success, error in
            if success {
                print("success")
            } else if let error {
                print(error)
            }
        }
        print("Message: ", AchievementService.shared.messageAchievement.unlocked)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
                    return
                }
        guard firstUrl.host() == "room" else{
            return
        }
        let path = firstUrl.path()
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

