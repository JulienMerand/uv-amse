//
//  TableauScoresTableViewController.swift
//  ProjetHammer
//
//  Created by admin on 07/03/2023.
//

import UIKit
import CoreData

class TableauScoresTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        chargerDonnees()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDetail") {
            (segue.destination as! ShowScores).JoueurEnCours = JoueurEnCours
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let joueurs = fetchedResultsController.fetchedObjects
        else {
            return 0
        }
        return joueurs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celluleJeu", for: indexPath )
        let joueur = fetchedResultsController.object(at: indexPath) as Joueurs
        cell.textLabel?.text = String(joueur.nom! + " " + joueur.prenom!)
        
        
        let ensembleScore: NSArray = joueur.ensembledesscores!.allObjects as NSArray
        
        if ensembleScore.count > 0 {
            var m: Int = 0
            for i in 0..<ensembleScore.count-1 {
                if (ensembleScore.object(at: i+1) as! Scores).score > (ensembleScore.object(at: m) as! Scores).score {
                    m = i
                }
            }
            
            cell.detailTextLabel?.text = "Meilleur score : " + String((ensembleScore.object(at: m) as! Scores).score)
        }
        else {
            cell.detailTextLabel?.text = "Pas encore de score..."
        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObjectContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let managedObject : NSManagedObject = fetchedResultsController.object(at:indexPath) as NSManagedObject
            managedObjectContext.delete(managedObject);
            do {
                try managedObjectContext.save();
                
                chargerDonnees();
                self.tableView.reloadData();
            } catch {
                print("Erreur tableview...")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.estAppeleeParSelection) {
            print("appele par selection")
            (self.appelant as! ViewController).joueurAAssigner = fetchedResultsController.object(at: indexPath) as Joueurs
            (self.appelant as! ViewController).saveScore()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            print("init JoueurEnCours")
            JoueurEnCours = fetchedResultsController.object(at: indexPath) as Joueurs
            self.performSegue(withIdentifier: "segueDetail", sender: self)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    var estAppeleeParSelection = false
    var appelant: UIViewController?
    var JoueurEnCours : Joueurs?
    
    
    let persistentContainer = NSPersistentContainer.init(name: "ProjetHammer") // ici à remplacer par le nom de votre modèle
    
    lazy var fetchedResultsController : NSFetchedResultsController<Joueurs> = {
        
        let fetchRequest: NSFetchRequest<Joueurs> = Joueurs.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: false)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managerContext = appDelegate.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managerContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func chargerDonnees(){
        //persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
        //    if let error = error {
        //        print ("Unable to Load Persistent Store")
        //        print ("\(error), \(error.localizedDescription)")
        //    } else {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print ("Unable to Perform Fetch Request")
            print ("\(fetchError), \(fetchError.localizedDescription)")
        }
        //    }
        //}
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
