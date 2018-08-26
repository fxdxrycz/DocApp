//
//  ViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 21/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class PatientListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var patientArray: Results<Patient>?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loadItems()

        // print(dataFilePath)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the "??" is the Nil Coalescing Operator, it means the patientArray could be nil, so I'm getting the count only if it's not nil, otherwise I'm getting 1
        return patientArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //I'm casting the cell as SwipeTabelViewCell and setting the delegate to self, necessary to use SwipeCellKit
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientItemCell" , for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        tableView.rowHeight = 80
        cell.textLabel?.text = patientArray?[indexPath.row].name ?? "Nessun paziente è stato aggiunto"
        cell.textLabel?.textColor = UIColor.black
        //let labelFontSize = (cell.detailTextLabel!.font.pointSize)
        //cell.textLabel?.font = cell.textLabel?.font.withSize(labelFontSize - 3)
        
        
        
        cell.accessoryType = .disclosureIndicator
        
        
        
        //chemark code, this can be done with the following ternary operator
        
//        if patientArray[indexPath.row].selected == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = patientArray![indexPath.row].selected  ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToPatients", sender: self)
        
        
        
        
//        if let item = patientArray?[indexPath.row] {
//            do{
//                try realm.write {
//                    //realm.delete(item)
//                    item.selected = !item.selected
//                }
//            } catch {
//                print("Error deleting, \(error)")
//            }
//        }
//         tableView.reloadData()
        
        
        
        //if i select the bool value is set to the opposite of the current one
        //patientArray![indexPath.row].selected = !patientArray[indexPath.row].selected
        
        //self.save(patient: Patient) //we need to call it because we changed the checkmark property
        
        //necessary to update the view with the checkboxes, they wouldn't show otherwise
        // tableView.reloadData() //it now exists inside saveItems
        
        print(indexPath.row)
        
        //code to make cell selection animation "flash"
//        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! PatientViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPatient = patientArray?[indexPath.row]
        }
    }
    
    
    
    
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField1 = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        var textField4 = UITextField()
        var textField5 = UITextField()
        
        
        let alert = UIAlertController(title: "Inserisci i dati", message: "", preferredStyle: .alert)
        
        //modified the UiAlertAction by pressing enter on Action and making a closure this way
        let action = UIAlertAction(title: "Aggiungi Paziente", style: .default) { (action) in
            //what will happens once the user clicks the Aggiungi nuovo paziente on our UIAlerts
            
            //since I'm in a closure i have to add self everywhere
            
            let newItem = Patient()
            newItem.name = textField1.text!
            newItem.age = textField2.text!
            newItem.cf = textField3.text!
            newItem.address = textField4.text!
            newItem.notes = textField5.text!
            newItem.selected = false
            newItem.dateCreated = Date()
            self.save(patient: newItem)
        
            
        
        }
        
       
        
        //again after selecting alert.addTextField from xcode, I press enter on the last field and I create a closure
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci qui il nome"
            textField1 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci qui l'età"
            textField2 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci qui il codice fiscale"
            textField3 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci qui l'indirizzo"
            textField4 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Inserisci qui le note"
            textField5 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
        }
        
        alert.addAction(action)
        
        //this way I actually show the alert
        present(alert, animated: true, completion: nil)
        
        
        

        
        
        
        
    }
    
    
    //MARK - Model Manipulation Methods
    
    func save(patient: Patient) {
        
        
        do{
            try realm.write(){
                realm.add(patient)
            }
            
        } catch {
            print("Error saving into db, \(error)")
            
        }
        
        self.tableView.reloadData() //this line repopulates the table data, otherwise it wouldn't be shown
        
    }
    
    func loadItems() {
        
        patientArray = realm.objects(Patient.self)
    

        tableView.reloadData()
    }
    
            
            
}


//MARK: - Search Bar Methods
extension PatientListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        patientArray = patientArray?.filter("name CONTAINS[CD] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
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
extension PatientListViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let itemForDeletion = self.patientArray?[indexPath.row] {
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
