//
//  ViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 21/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit
import CoreData

class PatientListViewController: UITableViewController {
    
    
    var itemArray = [Patient]()
    
    //this is where we store our default settings
   // let defaults = UserDefaults.standard //we wont be using this anymore
    
    //we get access to the Document directory of our app, we use .first because it's an array
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        

        
        loadItems()

        // print(dataFilePath)
        
        //old harcoded stuff
//        let newPatient1 = Patient()
//        newPatient1.name = "Manda Noob"
//        itemArray.append(newPatient1)
//
//        let newPatient2 = Patient()
//        newPatient2.name = "Botty Bot"
//        itemArray.append(newPatient2)
//
//        let newPatient3 = Patient()
//        newPatient3.name = "Ana McBot"
//        itemArray.append(newPatient3)
        
        
        
        
        //uso if let per essere sicuro che questo array esista veramente in memoria, questa riga serve a popolare l'array a runtime con l'array salvata nel file .plist su memoria di massa
//        if let items = defaults.array(forKey: "PatientListArray") as? [Patient] {
//            itemArray = items
//        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientItemCell" , for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        cell.detailTextLabel?.text = "Gianni Casadoppia corre tutto da solo sotto la luna e le stelle e prova a scrivere un app iOS"
        cell.textLabel?.textColor = UIColor.purple
        //let labelFontSize = (cell.detailTextLabel!.font.pointSize)
        //cell.textLabel?.font = cell.textLabel?.font.withSize(labelFontSize - 3)
        
        
        
        cell.accessoryType = .disclosureIndicator
        
        //chemark code, this can be done with the following ternary operator
        
//        if itemArray[indexPath.row].selected == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        //cell.accessoryType = itemArray[indexPath.row].selected  ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if i select the bool value is set to the opposite of the current one
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        
        saveItems() //we need to call it because we changed the checkmark property
        
        //necessary to update the view with the checkboxes, they wouldn't show otherwise
        // tableView.reloadData() //it now exists inside saveItems
        
        print(indexPath.row)
        
        //code to make cell selection animation "flash"
//        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField1 = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi Nuovo Paziente", message: "", preferredStyle: .alert)
        
        //modified the UiAlertAction by pressing enter on Action and making a closure this way
        let action = UIAlertAction(title: "Aggiungi Paziente", style: .default) { (action) in
            //what will happens once the user clicks the Aggiungi nuovo paziente on our UIAlerts
            
            //since I'm in a closure i have to add self everywhere
            
            
            
            let newItem = Patient(context: self.context)
            newItem.name = textField1.text!
            newItem.selected = false
            
            self.itemArray.append(newItem) //questa parte va espansa per impedire l'inserimento di stringhe vuote
            
            //old userdefaults cheap storage method
//            self.defaults.set(self.itemArray, forKey: "PatientListArray")
            
            self.saveItems()
        
        }
        
        //again after selecting alert.addTextField from xcode, I press enter on the last field and I create a closure
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField1 = alertTextField //I'm doing this because the alertTextField is only avaible to the scope of this closure
         
   
        }
        
        alert.addAction(action)
        
        //this way I actually show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        
        do{
           try context.save()
        } catch {
            print("Error saving context, \(error)")
            
        }
        
        self.tableView.reloadData() //this line repopulates the table data, otherwise it wouldn't be shown
        
    }
    
    //by placing the =Patient.fetchRequest() inside the passed parameters I'm saying that calling this method without parameters the request will get this default value
    //with request are the external and internal parameters
    func loadItems(with request: NSFetchRequest<Patient> = Patient.fetchRequest()) {
        
      //  let request: NSFetchRequest<Patient> = Patient.fetchRequest() //I'm already passing this
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
    }
            
            
            
}


//MARK: - Search Bar Methods
extension PatientListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Patient> = Patient.fetchRequest()
        //print(searchBar.text)
        
        request.predicate = NSPredicate(format: "name CONTAINS[CD] %@", searchBar.text!)
        

        
        //this way I sort the data I get back in alphabetical order
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector:#selector(NSString.caseInsensitiveCompare(_:)))
        
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //I'm saying to the dispatcher to run this method on the main queue, by doing this the cursors stop flashing on the search bar after i deleted its content
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
            
        }
    }
    
    
}
