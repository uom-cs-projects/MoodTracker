//
//  TableViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 17/12/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit
import SQLite3
class TableViewController: UITableViewController {

    @IBOutlet var tabletabbar: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) .appendingPathComponent("MoodDatabase.sqlite")
        
        //open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
          readValues()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        readValues()
        tableView.reloadData()
    }
    var db: OpaquePointer?
    var moodList = [Moods]()
    var count = 0
    // MARK: - Table view data source

    
    func readValues(){
        
        moodList.removeAll()
        
        let queryString = "SELECT * FROM Mood"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traverse through all the moods
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let date = String(cString: sqlite3_column_text(stmt, 1))
            let time = String(cString: sqlite3_column_text(stmt, 2))
            let emotion = String(cString: sqlite3_column_text(stmt, 3))
            
            
            //add values to list
            moodList.append(Moods(id: Int(id), date: String(describing: date), time: String(describing: time), emotion: String(describing: emotion)))
        }
        tableView.dataSource = self
        count = 0
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(moodList.count)
        print("moodList.count")
        return moodList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        NSLog("get cell")
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.detailTextLabel?.textColor = .gray
        cell.selectionStyle = .none
        //cell.textLabel!.text = moodList[count].emotion
        print("count")
        print(count)
        print(indexPath)
        print(indexPath[1])
        cell.textLabel?.text = moodList[indexPath[1]].emotion
        cell.detailTextLabel?.text = moodList[indexPath[1]].date! + " at " + moodList[indexPath[1]].time!

        count = 1 + count
        return cell
    }
 

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
