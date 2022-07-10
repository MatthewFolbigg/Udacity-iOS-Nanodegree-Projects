//
//  playSoundViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Folbigg on 30/11/2020.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    //MARK: IB Outlets
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var delayButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    //MARK: Variables
    var recordedAudioURL: URL!
    
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setButtonUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    
    //MARK: IB Actions
    // Change intensity of audio effects here
    @IBAction func playButtonDidTapped(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag) {
        case .slow:
            playSound(rate: 0.5) //1 = 100% speed
        case .fast:
            playSound(rate: 1.5) //1 = 100% speed
        case .chipmunk:
            playSound(pitch: 1000) //0 = Standard Pitch, +1000 = 1 octave up
        case .vader:
            playSound(pitch: -1000) //0 = Standard Pitch, -1000 = 1 octave down
        case .echo:
            playSound(echo: true) 
        case .reverb:
            playSound(reverb: true)
        case .none:
            print("Error with playback button")
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonDidTapped(_ sender: AnyObject) {
        stopAudio()
    }
    
    func setButtonUI() {
        slowButton.imageView?.contentMode = .scaleAspectFit
        fastButton.imageView?.contentMode = .scaleAspectFit
        highButton.imageView?.contentMode = .scaleAspectFit
        lowButton.imageView?.contentMode = .scaleAspectFit
        reverbButton.imageView?.contentMode = .scaleAspectFit
        delayButton.imageView?.contentMode = .scaleAspectFit
    }
    
}
