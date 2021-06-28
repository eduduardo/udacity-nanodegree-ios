//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Eduardo Ramos on 08/06/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    struct Texts {
        static let RecordingLabel = "Recording..."
        static let TapToRecordLabel = "Tap to record!"
        static let ErrorAlert = "Record failed, please, try again!"
    }
    
    enum RecordState { case recording, notRecording }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.notRecording)
    }
    
    @IBAction func recordAction(_ sender: Any) {
        configureUI(.recording)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordName = "recordedVoice.wav"
        let pathArray = [dirPath, recordName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        configureUI(.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func configureUI(_ recording: RecordState){
        if recording == .recording {
            recordLabel.text = Texts.RecordingLabel
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        } else {
            recordLabel.text = Texts.TapToRecordLabel
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Record", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlert(Texts.ErrorAlert)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

