//
//  AddController.swift
//  
//
//  Created by 597588 on 7/10/18.
//
import UIKit
import FirebaseDatabase
import Speech

class AddController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var noteNameField: UITextField!
    @IBOutlet weak var noteBodyField: UITextView!
    @IBOutlet weak var startButton: UIButton!
    
    private var currentText = String()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer?=SFSpeechRecognizer()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    let summarizer = Summarizer()
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func savePressed(_ sender: Any) {
        let first = ref?.child("Note Info").child("Note: " + noteNameField.text!)
        first?.child("Name").setValue(noteNameField.text!)
        first?.child("Body").setValue(noteBodyField.text!)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let first = ref?.child("Note Info").child("Note: " + noteNameField.text!)
        first?.child("Name").setValue(noteNameField.text!)
        first?.child("Body").setValue(noteBodyField.text!)
        noteSumm = summarizer.summarize(text: noteBody)
        first?.child("Summary").setValue(noteSumm)
    }
    
    /* Start of Speech To Text */
    @IBAction func startButtonTapped(_ sender: Any) {
        var isButtonEnabled = false
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus{
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                self.noteBodyField.text = "User denied access to speech recognition"
            case .restricted:
                isButtonEnabled = false
                self.noteBodyField.text = "Speech Recognition restricted on this device"
            case .notDetermined:
                isButtonEnabled = false
                self.noteBodyField.text = "Speech Recognition is not yet authorized"
            }
            OperationQueue.main.addOperation {
                self.startButton.isEnabled = isButtonEnabled // 3
            }
        }
        self.speechRecognizer?.delegate = self
        if audioEngine.isRunning{
            audioEngine.stop()
            request?.endAudio()
            startButton.isEnabled = false
            startButton.setTitle("Start Recording", for: .normal)
        }else{
            startRecording()
            startButton.setTitle("Stop Recording", for: .normal)
        }
    }
    func startRecording(){
        self.currentText = self.noteBodyField.text
        if  recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            print("audioSession properties weren’t set because of an error.")
        }
        request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        request?.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: request!, resultHandler: { (result, error) in
            var isFinal = false;
            if result != nil{
                self.noteBodyField.text = self.currentText + (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.request = nil
                    self.recognitionTask = nil
                    self.startButton.isEnabled = true
                }
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request?.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch{
            print("AudioEngine could not start because of an Error.")
        }
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
    /* End of Speech To Text */
    
    @IBAction func addArticle(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}
