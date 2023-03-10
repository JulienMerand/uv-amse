//
//  ShowScores.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//

import UIKit
import CoreData

class ShowScores: UIViewController {
    
    var JoueurEnCours: Joueurs?
    @IBOutlet var textAAfficher: UILabel?
    var texte: String = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        afficherJoueur()
        textAAfficher?.text = texte
    }
    
    func afficherJoueur() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "EEEE d MMMM à HH:mm"
        
        if(JoueurEnCours == nil) {
            print("JoueurEnCours = nil")
            return
        }
        if(JoueurEnCours?.ensembledesscores == nil || JoueurEnCours?.ensembledesscores?.count == 0) {
            let j: Joueurs = JoueurEnCours!
            texte = "Aucun score pour le moment pour \(j.nom!) \(j.prenom!)"
        }
        else {
            let j: Joueurs = JoueurEnCours!
            let ensembleScores: NSArray = j.ensembledesscores!.allObjects as NSArray
            texte = "Joueur \(j.nom!) \(j.prenom!) : \n\n"
            for index in 0..<ensembleScores.count - 1 {
                let s = ensembleScores.object(at: index) as! Scores
                
                let date = dateFormatter.string(from: s.date!)
                
                texte += "Le \(date) --> \(s.score)\n"
            }
            let s = ensembleScores.object(at: ensembleScores.count - 1) as! Scores
            let date = dateFormatter.string(from: s.date!)
            texte += "Le \(date) --> \(s.score)"
        }
    }
    
    @IBAction func back(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
