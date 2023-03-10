//
//  ViewController.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//

import UIKit
import CoreMotion
import CoreData
import AudioToolbox

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0.0

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueSelectionJoueur") {
            ((segue.destination as! UINavigationController).topViewController as! TableauScoresTableViewController).estAppeleeParSelection = true
            ((segue.destination as! UINavigationController).topViewController as! TableauScoresTableViewController).appelant = self
        }
    }
    
    var motionManager : CMMotionManager!
    var timer: Timer!
    var nbVal: Int = 0
    var donnees: [Double] = []
    var joueurAAssigner : Joueurs?
    var score: Int = 0
    
    @IBOutlet var message : UILabel?
    @IBOutlet var boutonGo : UIButton?
    @IBOutlet var boutonScores : UIButton?
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet var text: UILabel?
    
    @IBAction func GoGoGo(_ sender : UIButton) {
        nbVal = 0
        slider?.value = 0.0
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates()
        donnees = [Double](repeating: 0, count: 500)
        // ici : décoration pour faire une jolie animation avec des chiffres
        // possiblement parler : classe AVSpeechVoiceSynthesis : https://developer.apple.com/documentation/avfaudio/avspeechsynthesisvoice
        boutonGo?.isEnabled = false
        boutonScores?.isEnabled = false
        progressView?.isHidden = false
        text?.isHidden = false
        message?.isHidden = true
        slider?.isHidden = true
        
        while motionManager == nil {
            
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self , selector: #selector(mesureDonnees), userInfo: nil, repeats: true)
        //timer = Timer.scheduledTimer(timeInterval: 1.0, target: self , selector: #selector(lanceMesure), userInfo: nil, repeats: false)
    }
    
    //@objc func lanceMesure() {
    //    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self , selector: #selector(mesureDonnees), userInfo: nil, repeats: true)
    //}
    
    @objc func mesureDonnees(timer: Timer) {
        if(nbVal >= 500) {
            
            motionManager.stopAccelerometerUpdates()
            timer.invalidate()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            motionManager = nil
            self.calculScore()
            boutonGo?.isEnabled = true
            boutonScores?.isEnabled = true
            self.performSegue(withIdentifier: "segueSelectionJoueur", sender: self)
            progressView?.progress = 0.0
            progressView?.isHidden = true
            text?.isHidden = true
            message?.isHidden = false
            slider?.isHidden = false
        }
        else {
            if(motionManager == nil) {
                return
            }
            donnees[nbVal] = sqrt(motionManager.accelerometerData!.acceleration.x * motionManager.accelerometerData!.acceleration.x + motionManager.accelerometerData!.acceleration.y * motionManager.accelerometerData!.acceleration.y + motionManager.accelerometerData!.acceleration.z * motionManager.accelerometerData!.acceleration.z)
            
            //donnees[nbVal] = Double.random(in: 1..<10)
            
            //attention sur simulateur , accelerometerData est nil ...
            print("Acquisition :  \(nbVal) --> \(donnees[nbVal])")
            
            self.progressView.progress += 1/500
            slider?.value = Float(donnees[nbVal]*100)
            
            nbVal += 1
        }
    }
    
    func calculScore() {
        // calcul du score en fonction du tableau de donnees
        // et affectation de la variable score
        var sum: Int = 0
        for i in 0..<donnees.count {
            sum += Int(donnees[i]*100)
        }
        score = sum/donnees.count
        message?.text = "Score : " + String(score)
        slider?.value = Float(score)
    }
    
    func saveScore() {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext
        let s: Scores = NSEntityDescription.insertNewObject(forEntityName: "Scores", into: managerContext) as! Scores
        
        s.score = Int32(score)
        s.date = Date()
        s.queljoueur = joueurAAssigner
        
        if(joueurAAssigner?.ensembledesscores == nil) {
            let setScores = NSSet.init(object: s)
            joueurAAssigner?.ensembledesscores = setScores
        }
        else {
            joueurAAssigner?.addToEnsembledesscores(s)
        }
        do {
            try managerContext.save()
            print("Ajout ok")
        } catch {
            let fetchError = error as NSError
            print("Impossible d'ajouter")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
}
