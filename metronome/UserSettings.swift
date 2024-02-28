import Foundation

fileprivate enum UDKeys: String {
    case bpm   = "BPM"
    case sound = "SOUND"
}

final class UserSettings {
    
    private let ud = UserDefaults.standard
    private let iCloudKVStore = NSUbiquitousKeyValueStore.default
    
    public func getBPM() -> Int {
        let bpm = ud.integer(forKey: UDKeys.bpm.rawValue)
        
        if bpm == 0 {
            ud.set(100, forKey: UDKeys.bpm.rawValue)
            return 100
        } else {
            return bpm
        }
    }
    
    public func getPreferredSound() -> Sounds {
        if let sound = ud.string(forKey: UDKeys.sound.rawValue) {
            return Sounds(rawValue: sound) ?? .mechanicalMetronomeLow
        } else {
            ud.set(Sounds.mechanicalMetronomeLow.rawValue as Any, forKey: UDKeys.sound.rawValue)
            return .mechanicalMetronomeLow
        }
    }
    
    
    public func save(bpm: Int) {
        ud.set(bpm, forKey: UDKeys.bpm.rawValue)
    }
    
    public func save(preferredSound: Sounds) {
        ud.set(preferredSound.rawValue as Any, forKey: UDKeys.sound.rawValue)
    }
}
