//
//  SecondViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 06/10/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var isready = true
    var daily = false
    override func viewWillAppear(_ animated: Bool) {
        daily = calculatedaily()
        //print("daily:")
        //print(daily)
        setisready()
        setcircle()
        //print(timestring)
        let titlestring = "Log Mood for " + String(timestring.prefix(1)).capitalized + String(timestring.dropFirst())
        navigationController?.navigationBar.topItem?.title=titlestring
    }
    
    func calculatedaily()-> Bool{
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let secondmonday = dateFormatter.date(from: "2019/02/18") ?? Date() //start of second week

        /*
         if today < secondmonday{//if we are still in first week, group 1
         return true
         }else{
         return false
         }
         */
        
        //group 2
        if today >= secondmonday{//if we are in second week, group 2
            return true
        }else{
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentbutton = alertbutton

        //db file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) .appendingPathComponent("MoodDatabase.sqlite")

        //open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //create table
       /*
        if sqlite3_exec(db, "DROP TABLE Mood", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error removing table: \(errmsg)")
        }
        */
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Mood (id INTEGER PRIMARY KEY AUTOINCREMENT, thedate TEXT, thetime TEXT, emotion TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        //setisready()
        //setcircle()

    }

    func setisready(){
        if daily {
            timestring = "Today"
            readValues()
            if moodList.count==0{
                isready = true
            }else{
                isready = false
            }
        }else{
            settimestring()
            //print(timestring)
            readValues()
            //print(moodList.count)
            if moodList.count == 0{
                isready = true
            }else if moodList.count == 1 && timestring == "Bedtime"{
                timestring = "Overall"
                isready = true
            }else{
                isready = false
            }
            //print("isready")
            //print(isready)
            if timestring == "Overall"{
                readValues()
                print(moodList.count)
                if moodList.count == 0{
                    isready = true
                }else{
                    isready = false
                }
            }
        }

        //print(isready)
        
    }
    
    func settimestring(){
        if daily {
            timestring = "Today"
        }else{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            switch hour {
            case 5..<11:
                timestring = "Morning"
            case 11..<15:
                timestring = "Lunch"
            case 15..<18:
                timestring = "Afternoon"
            case 18..<22:
                timestring = "Evening"
            default:
                timestring = "Bedtime"
            }
        }
    }
    func setcircle(){
        if isready{
            circle.image = #imageLiteral(resourceName: "green")
            inputnow.setTitle("Input data now!", for: .normal)
            inputnow.isEnabled = true
            //submit.isHidden = false
            submit.isEnabled = true
            let submitstring = "Submit Mood for " + timestring
            submit.setTitle(submitstring, for: .normal)
        }else{
            circle.image = #imageLiteral(resourceName: "orange")
            inputnow.setTitle("You have already logged your mood for now", for: .normal)
            inputnow.isEnabled = false
            submit.isHidden = true
            submit.isEnabled = false
        }
        
        
    }
    
    var db: OpaquePointer?
    var currentbutton : UIButton?
    var currentemotion = ""
    @IBOutlet var alertbutton: UIButton!
    var confirmemotion = UIAlertController()
    var timestring = ""
    var moodList = [Moods]()
    @IBOutlet var inputnow: UIButton!
    
    @IBOutlet var emotionbuttons: [UIButton]!
    
    func resetpage(){
        circle.image = #imageLiteral(resourceName: "orange")
        inputnow.setTitle("You have already logged your mood for now", for: .normal)
        inputnow.isEnabled = false
        submit.isHidden = true
        submit.isEnabled = false
        for curbutton in emotionbuttons {
            curbutton.isHidden = true
        }
        circle.isHidden = false
        inputnow.isHidden = false
        
    }
    
    @IBAction func inputnow(_ sender: Any) {
        for curbutton in emotionbuttons {
            curbutton.isHidden = false
            curbutton.setTitleColor(self.view.tintColor, for: .normal)
        }
        circle.isHidden = true
        inputnow.isHidden = true
        submit.isHidden = false
    }
    @IBOutlet var circle: UIImageView!
    
    
    @IBAction func emotionclick(_ sender: Any) {
        currentbutton?.setTitleColor(self.view.tintColor, for: .normal)
        currentbutton = (sender as! UIButton)
        currentemotion = (sender as AnyObject).currentTitle!
        (sender as AnyObject).setTitleColor(.red, for: .normal)
    }
    @IBOutlet weak var submit: UIButton!


    @IBAction func clicksubmit(_ sender: Any) {
        
        readValues()
        //set up already submitted alert
        let alreadysubmitted = "You have already submitted " + String(moodList.count) + " today"
        let already = UIAlertController(title: "Already Done!", message: alreadysubmitted, preferredStyle: .alert)
        let alreadyOKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
        })
        
        already.addAction(alreadyOKAction)
        
        
        
        //set up not submitted yet
        let alertmessage = "Submitting \"" + currentemotion.lowercased() + "\" as your emotion for " + (timestring.lowercased())
        let alert = UIAlertController(title: "Please Confirm your Data", message: alertmessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        })
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            self.resetpage();
        })
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        alert.preferredAction = OKAction
        
        
        let emptymessage = "Please Select an Emotion"
        let empty = UIAlertController(title: "No Selection", message: emptymessage, preferredStyle: .alert)
        let emptyOKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
        })
        empty.addAction(emptyOKAction)
        
        if currentemotion == ""{
            self.present(empty, animated: true, completion: nil)
        }
        else if !isready{
            self.present(already, animated: true, completion: nil)
        }else{
            self.present(alert, animated: true, completion: nil)
        
    
            let emotion = currentemotion.lowercased() as NSString
            let thetime = (timestring.lowercased()) as NSString
            
            
            let theFormatter = DateFormatter()
            theFormatter.dateFormat = "yyyy-MM-dd";
            let datestring = theFormatter.string(from: Date()) as NSString
            //print(datestring)
            
            //creating a statement
            var stmt: OpaquePointer?
            
            //the insert query
            let queryString = "INSERT INTO Mood (thedate, thetime, emotion) VALUES (?,?,?)"
            
            //preparing the query
            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            //binding the parameters
            if sqlite3_bind_text(stmt, 1, datestring.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            if sqlite3_bind_text(stmt, 2, thetime.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            if sqlite3_bind_text(stmt, 3, emotion.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            //executing the query to insert values
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting emotion: \(errmsg)")
                return
            }
            readValues()
            
            //displaying a success message
            //print("Mood saved successfully")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readValues(){

        moodList.removeAll()
        
        let theFormatter = DateFormatter()
        theFormatter.dateFormat = "yyyy-MM-dd";
        let datestring = theFormatter.string(from: Date()) as NSString
        
        let queryString = "SELECT * FROM Mood WHERE thetime IS ? AND thedate IS ?"
        let mytime = timestring.lowercased() as NSString
        var stmt:OpaquePointer?
        
        //prepare query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, mytime.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, datestring.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }

        
        //traverse through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let date = String(cString: sqlite3_column_text(stmt, 1))
            let time = String(cString: sqlite3_column_text(stmt, 2))
            let emotion = String(cString: sqlite3_column_text(stmt, 3))
            
            
            //add values to list
            moodList.append(Moods(id: Int(id), date: String(describing: date), time: String(describing: time), emotion: String(describing: emotion)))
        }
        
    }
    
    

}

