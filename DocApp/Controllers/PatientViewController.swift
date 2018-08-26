//
//  PatientViewController.swift
//  DocApp
//
//  Created by Federico Dazzan on 25/08/2018.
//  Copyright © 2018 Federico Dazzan. All rights reserved.
//

import UIKit
import RealmSwift

class PatientViewController: UITableViewController {
    
    var detailsLabels : [String] = ["nome", "età", "codice fiscale", "indirizzo", "note"]
    var detailsData : [String] = []
    var selectedPatient : Patient? {
        didSet{
            detailsData = [selectedPatient?.name, selectedPatient?.age, selectedPatient?.cf, selectedPatient?.address, selectedPatient?.notes] as! [String]
            //loadDetails()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailsLabels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //I'm casting the cell as SwipeTabelViewCell and setting the delegate to self, necessary to use SwipeCellKit
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientDetailCell" , for: indexPath)
        
        
        cell.textLabel?.text = detailsData[indexPath.row]
        cell.detailTextLabel?.text = detailsLabels[indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.blue
        //let labelFontSize = (cell.detailTextLabel!.font.pointSize)
        //cell.textLabel?.font = cell.textLabel?.font.withSize(labelFontSize - 3)
        
        
        
        //cell.accessoryType = .disclosureIndicator
        
        
        
        //chemark code, this can be done with the following ternary operator
        
        //        if patientArray[indexPath.row].selected == true{
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        //ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        
//        cell.accessoryType = patientArray![indexPath.row].selected  ? .checkmark : .none
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
