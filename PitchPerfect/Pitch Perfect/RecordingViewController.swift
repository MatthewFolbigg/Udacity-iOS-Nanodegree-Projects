//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Folbigg on 30/11/2020.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: IB Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    
    //MARK: Variables
    var audioRecorder: AVAudioRecorder!
    
    
    //MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(forRecordingStatus: false)
    }

    
    //MARK: IB Actions
    @IBAction func recordButtonDidTapped(_ sender: AnyObject) {
        configureUI(forRecordingStatus: true)
        recordAudio()
    }
    
    @IBAction func stopButtonDidTapped(_ sender: AnyObject) {
        configureUI(forRecordingStatus: false)
        stopRecordingAudio()
    }
    
    //MARK: Methods
    //MARK: Methods: Audio Recording
    func recordAudio() {
        //Set path for storing recorded audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        //Configue AV audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        //Prepare to a start recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecordingAudio(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: Methods: Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "recordingStopped", sender: audioRecorder.url)
        } else {
            showAlert("Recording Failed", message: "Audio recording failed. Please try again.")
        }
    }
    
    //MARK: Methods: UI Configuration
    func configureUI(forRecordingStatus recording: Bool) {
        if recording {
            recordingLabel.text = "Recording in progress..."
            recordingLabel.textColor = .systemGray
            stopButton.isEnabled = true
            recordButton.isEnabled = false
        } else {
            recordingLabel.text = "Tap to record"
            recordingLabel.textColor = .label
            stopButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordingStopped" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let audioURL = sender as! URL
            playSoundVC.recordedAudioURL = audioURL
        }
    }
    
    
}
