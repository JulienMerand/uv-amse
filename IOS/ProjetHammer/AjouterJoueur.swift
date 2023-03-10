//
//  AjouterJoueur.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//

import UIKit
import CoreData

class AjouterJoueur: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var n: UITextField?
    @IBOutlet var p: UITextField?

    var np: String?
    
    @IBAction func ok(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext
        let j: Joueurs = NSEntityDescription.insertNewObject(forEntityName: "Joueurs", into: managerContext) as! Joueurs
        
        
        j.nom = n?.text
        j.prenom = p?.text
        j.ensembledesscores = nil
        
        do {
            try managerContext.save()
            
            
            
            
            print("Ajout ok")
        } catch {
            let fetchError = error as NSError
            print("Impossible d'ajouter")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func annuler(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
