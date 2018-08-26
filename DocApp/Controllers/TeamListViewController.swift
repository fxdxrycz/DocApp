//
//  TeamsViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 26/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TeamListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var teamsArray: Results<Team>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }


    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //I'm casting the cell as SwipeTabelViewCell and setting the delegate to self, necessary to use SwipeCellKit
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        tableView.rowHeight = 80
        cell.textLabel?.text = teamsArray?[indexPath.row].name ?? "Nessuna squadra è stata aggiunta"
        cell.textLabel?.textColor = UIColor.black

        
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToPatientList", sender: self)
        
        //code to make cell selection animation "flash"
        //        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       // let destinationVC = segue.destination as! PatientListViewController
        //if let indexPath = tableView.indexPathForSelectedRow {
           // destinationVC.selectedPatient = teamsArray?[indexPath.row]
        //}
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
                var textField1 = UITextField()
        
        
                let alert = UIAlertController(title: "Inserisci i dati", message: "", preferredStyle: .alert)
        
                //modified the UiAlertAction by pressing enter on Action and making a closure this way
                let action = UIAlertAction(title: "Aggiungi Squadra", style: .default) { (action) in
        
                    let newItem = Team()
                    newItem.name = textField1.text!
                    self.save(team: newItem)
        
        
                }

                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Inserisci qui il nome"
                    textField1 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
        }
        
                alert.addAction(action)
        
                //this way I actually show the alert
                present(alert, animated: true, completion: nil)
        
        
    }


    
    //MARK - Model Manipulation Methods
    
    func save(team: Team) {
        
        
        do{
            try realm.write(){
                realm.add(team)
            }
            
        } catch {
            print("Error saving into db, \(error)")
            
        }
        
        self.tableView.reloadData() //this line repopulates the table data, otherwise it wouldn't be shown
        
    }
    
    func loadItems() {
        
        teamsArray = realm.objects(Team.self)
        
        
        tableView.reloadData()
    }
    
    
    
}


//MARK: - Search Bar Methods
extension TeamListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        teamsArray = teamsArray?.filter("name CONTAINS[CD] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
        
        
        
        
        
        
        
        
        
        
        //        //this way I sort the data I get back in alphabetical order
        //        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector:#selector(NSString.caseInsensitiveCompare(_:)))
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //            I'm saying to the dispatcher to run this method on the main queue, by doing this the cursors stop flashing on the search bar after i deleted its content
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}

//MARK: - SwipeCell Methods
extension TeamListViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let itemForDeletion = self.teamsArray?[indexPath.row] {
                do{
                    try self.realm.write(){
                        self.realm.delete(itemForDeletion)
                    }
                    
                } catch {
                    print("Error deleting from db, \(error)")
                }
                tableView.reloadData()
            }
            
            
        }
        
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
        
    }
    
}
