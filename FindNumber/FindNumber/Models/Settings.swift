//
//  Settings.swift
//  FindNumber
//
//  Created by Илья Алексейчук on 08.04.2023.
//

import Foundation

//MARK: UserDefaults keys
enum KeysUserDefaults {
    static let settingsGame = "settingsGame"
    static let recordGame = "recordGame"
}

//MARK: SettingsGame
struct SettingsGame :Codable {
    var timerState :Bool
    var timeForGame :Int
}


class Settings {
    static var shared = Settings()
    
    private let defaultSettings = SettingsGame(timerState: true, timeForGame: 30)
    
    //MARK: Saving new data and fetching saved data from UserDefaults
    var currentSettings : SettingsGame {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsGame) as? Data {
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
                }
                return defaultSettings
            }
            
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
        }
    }
    
    //MARK: Reset settings
    func resetSettings() {
        currentSettings = defaultSettings
    }
    
    
}
