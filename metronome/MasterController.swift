import MediaPlayer
import AVFoundation
import MetronomeKit


public enum Sounds: String {
    case rimshot                 = "Rimshot"
    case bassDrum                = "Bass drum"
    case cowbell                 = "Cowbell"
    case hiHat                   = "Hi-hat"
    case mechanicalMetronomeLow  = "Mechanical metronome - Low"
    case mechanicalMetronomeHigh = "Mechanical metronome - High"
    case jackSlap                = "Jack slap"
    case laugh                   = "LAUGH!"
}


@available(iOS 16.0, *)
public final class MasterController: ObservableObject {
    
    public let minBPM = 20
    public let maxBPM = 300

   
    @Published public var isPlaying = false
    
    @Published public private(set) var bpm = 100
    
    @Published public var totalHoursPracticedSoFar = 0
    @Published public var totalMinutesPracticedSoFar = 0
    
    @Published public var selectedSound: Sounds = .rimshot {
        didSet {
            if self.isPlaying { self.stop() }
            self.loadFile(self.selectedSound)
            self.prepareBuffer()
            if self.isPlaying { self.play() }
        }
    }
    
    private let settings = UserSettings()
    private let engine = AudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()
    
    private var soundFileURL: URL!
    private var aiffBuffer: Array<UInt8>!
    private var startedPracticeTime: Date?
   
    
    public init() {
        self.selectedSound = settings.getPreferredSound()
        self.bpm = settings.getBPM()
        
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            debugPrint("Could not activate AudioSession. Error: \(error)")
        }

        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        // Make the play/pause functionality available in control center &
        // with headphones play/pause button
        let mp = MPRemoteCommandCenter.shared()
        
        mp.playCommand.isEnabled = true
        mp.playCommand.addTarget { _ in
            if !self.isPlaying {
                self.play()
                self.isPlaying = true
                return .success
            }
            return .commandFailed
        }
        
        mp.pauseCommand.isEnabled = true
        mp.pauseCommand.addTarget { _ in
            if self.isPlaying {
                self.stop()
                self.isPlaying = false
                return .success
            }
            return .commandFailed
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    deinit {
        self.stop()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            debugPrint("Could not deactivate audioSession:", error)
        }
    }

    public func saveStuff() {
        settings.save(bpm: self.bpm)
        settings.save(preferredSound: self.selectedSound)
    }
   
    public func play() {
       self.engine.play()
    }
    
   public func stop() {
      self.engine.stop()
   }
    
    public func setBPM(_ bpm: Int) {
        if bpm >= self.maxBPM {
            self.bpm = self.maxBPM
        } else if bpm <= self.minBPM {
            self.bpm = self.minBPM
        } else {
            self.bpm = bpm
        }
    }
    
    public func prepareBuffer() {
        self.engine.prepareToPlay(aiffBuffer: self.aiffBuffer, bpm: self.bpm)
    }
    
    private func loadFile(_ fileName: Sounds) {
        if let path = Bundle.main.path(forResource: "\(selectedSound.rawValue).aif", ofType: nil) {
            self.soundFileURL = URL(fileURLWithPath: path)
        } else {
            fatalError("Could not create url for \(selectedSound.rawValue).aif")
        }
        
        do {
            let soundData = try Data(contentsOf: soundFileURL)
            self.aiffBuffer = Array(soundData[0..<soundData.endIndex])
        } catch {
            fatalError("DATA READING ERROR: \(error)")
        }
    }
    
    @objc private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
        case .began:
            if self.isPlaying {
                self.stop()
                self.isPlaying = false
            }
        default:
            // We could resume playback on .ended, but I don't think that's appropriate for a metronome
            ()
        }
    }
    
}
