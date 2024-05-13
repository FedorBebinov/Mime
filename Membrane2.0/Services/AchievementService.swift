//
//  AchievementService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 08.04.2024.
//

import UIKit

class AchievementService {
    static let shared = AchievementService()

    var messageAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "messageAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "message")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "message")
        }
        return achievement
    }()

    var daysAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "daysAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "days")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "days")
        }
        return achievement
    }()
    
    var callsAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "callsAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "calls")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "calls")
        }
        return achievement
    }()
    
    var friendsAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "friendsAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "friends")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "friends")
        }
        return achievement
    }()
    
    var experimenterAchievement: Achievement = {
        let data = UserDefaults.standard.object(forKey: "experimenterAchievement") as? Data
        guard let data else{
            return Achievement(unlocked: false, id: "experimenter")
        }
        let decoder = JSONDecoder()
        let achievement = try? decoder.decode(Achievement.self, from: data)
        guard let achievement else{
            return Achievement(unlocked: false, id: "experimenter")
        }
        return achievement
    }()

    var messagesCount = UserDefaults.standard.integer(forKey: "messagesCount")
    var usingDays: Int {
        let currentDate = Date.now
        let seconds = UserDefaults.standard.firstLaunchDateSeconds
        let firstlaunchDate = Date(timeIntervalSince1970: seconds)
        let dateComponents = Calendar.current.dateComponents([.day], from: firstlaunchDate, to: currentDate)
        return dateComponents.day ?? 0
    }
    var callsCounter = UserDefaults.standard.dictionary(forKey: "callsCouter")
    var uniqueGestures: [String] = {
        if let uniqueGestures = UserDefaults.standard.array(forKey: "uniqueGestures") as? [String] {
            return uniqueGestures
        } else {
            return []
        }
    }()
    
    func trackCalls(username: String){
        guard var callsCounter else{
            callsCounter = [username:1]
            UserDefaults.standard.set(callsCounter, forKey: "callsCouter")
            return
        }
        if let call = callsCounter[username] as? Int {
            callsCounter[username] = call + 1
            UserDefaults.standard.set(callsCounter, forKey: "callsCouter")
        } else{
            callsCounter[username] = 1
            UserDefaults.standard.set(callsCounter, forKey: "callsCouter")
        }
        if callsCounter.values.contains(where: { value in
            if let value = value as? Int {
                return value >= 5
            }
            return false
        }) {
            if !callsAchievement.unlocked{
                callsAchievement.unlocked = true
                UIApplication.shared.keyWindow?.showNotification(achievement: NSLocalizedString("closeConnect", comment: ""))
                save()
            }
        }
        if callsCounter.count >= 2 {
            if !friendsAchievement.unlocked{
                friendsAchievement.unlocked = true
                UIApplication.shared.keyWindow?.showNotification(achievement: NSLocalizedString("friendly", comment: ""))
                save()
            }
        }
    }
    
    func trackSendMessage(){
        messagesCount += 1
        UserDefaults.standard.set(messagesCount, forKey: "messagesCount")
        if messagesCount >= 100, !messageAchievement.unlocked {
            messageAchievement.unlocked = true
            UIApplication.shared.keyWindow?.showNotification(achievement: NSLocalizedString("communicative", comment: ""))
            save()
        }
    }
    
    func checkAppLaunch(){
            if usingDays >= 15 {
                if !daysAchievement.unlocked{
                    daysAchievement.unlocked = true
                    UIApplication.shared.keyWindow?.showNotification(achievement: NSLocalizedString("habitue", comment: ""))
                    save()
                }
            }
    }
    
    func checkMessageType(points: [CGPoint], gesture: String){
        if !uniqueGestures.contains(String(points.count)){
            uniqueGestures.append(String(points.count))
        }
        
        if !uniqueGestures.contains(gesture){
            uniqueGestures.append(gesture)
        }
        UserDefaults.standard.set(uniqueGestures, forKey: "uniqueGestures")
        if uniqueGestures.count >= 8{
            if !experimenterAchievement.unlocked{
                experimenterAchievement.unlocked = true
                UIApplication.shared.keyWindow?.showNotification(achievement: NSLocalizedString("experimenter", comment: ""))
                save()
            }
        }
    }

    
    func save(){
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(messageAchievement)
            UserDefaults.standard.set(data, forKey: "messageAchievement")
        } catch {
            print(error)
        }
    }
}

class Achievement: Codable {
    var unlocked = false
    let id: String
    
    init(unlocked: Bool = false, id: String) {
        self.unlocked = unlocked
        self.id = id
    }
}

extension UserDefaults {
    var firstLaunchDateSeconds: Double {
        get {
            self.double(forKey: "firstLaunch")
        }
        set {
            self.set(newValue, forKey: "firstLaunch")
        }
    }
}
