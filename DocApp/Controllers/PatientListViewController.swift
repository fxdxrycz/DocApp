//
//  ViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 21/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit

class PatientListViewController: UITableViewController {
    
    
    var itemArray = [Patient]()
    
    //this is where we store our default settings
   // let defaults = UserDefaults.standard //we wont be using this anymore
    
    //we get access to the Document directory of our app, we use .first because it's an array
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        print(dataFilePath)
        
        loadItems()

        
        
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
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientItemCell" , for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].name
        
        
        
        //chemark code, this can be done with the following ternary operator
        
//        if itemArray[indexPath.row].selected == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = itemArray[indexPath.row].selected  ? .checkmark : .none 
        
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
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
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField1 = UITextField()
        
        let alert = UIAlertController(title: "Aggiungi Nuovo Paziente", message: "", preferredStyle: .alert)
        
        //modified the UiAlertAction by pressing enter on Action and making a closure this way
        let action = UIAlertAction(title: "Aggiungi Paziente", style: .default) { (action) in
            //what will happens once the user clicks the Aggiungi nuovo paziente on our UIAlerts
            
            //since I'm in a closure i have to add self everywhere
            
            let newItem = Patient()
            newItem.name = textField1.text!
            
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
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding iteam array, \(error)")
            
        }
        
        self.tableView.reloadData() //this line repopulates the table data, otherwise it wouldn't be shown
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Patient].self, from: data)
            } catch {
                print("Error decoding iteam array, \(error)")
            }
        }
        
    }
    


            
            
            
            
            
}

