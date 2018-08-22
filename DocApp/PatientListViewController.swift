//
//  ViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 21/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit

class PatientListViewController: UITableViewController {
    
    
    let itemArray = ["Paziente Bot", "Paziente Noob", "Paziente Scrub"]
    

    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    


}

