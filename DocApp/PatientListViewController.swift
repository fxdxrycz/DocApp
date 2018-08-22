//
//  ViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 21/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit

class PatientListViewController: UITableViewController {
    
    
    var itemArray = ["Paziente Bot", "Paziente Noob", "Paziente Scrub"]
    
    //this is where we store our default settings
    let defaults = UserDefaults.standard
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //uso if let per essere sicuro che questo array esista veramente in memoria, questa riga serve a popolare l'array a runtime con l'array salvata nel file .plist su memoria di massa
        if let items = defaults.array(forKey: "PatientListArray") as? [String] {
            itemArray = items
        }
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            self.itemArray.append(textField1.text!) //questa parte va espansa per impedire l'inserimento di stringhe vuote
            
            self.defaults.set(self.itemArray, forKey: "PatientListArray")
            
            self.tableView.reloadData() //this line repopulates the table data, otherwise it wouldn't be shown
        
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
    
    


}

