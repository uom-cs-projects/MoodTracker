//
//  SecondViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 06/10/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

   var isready = true
    
    override func viewWillAppear(_ animated: Bool) {
        setcircle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textbox.delegate = self
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
        
        readValues()
        
        setcircle()
        
    }

    func setcircle(){
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
        
        if moodList.count==0{
            isready = true
        }else if moodList.count == 1 && timestring == "Bedtime"{
            isready = true
            timestring = "Overall"
        }else{
            isready = false
        }
        
        
        if isready{
            circle.image = #imageLiteral(resourceName: "green")
            inputnow.setTitle("Input data now!", for: .normal)
            inputnow.isEnabled = true
        }else{
            circle.image = #imageLiteral(resourceName: "orange")
            inputnow.setTitle("Please wait until input time", for: .normal)
            inputnow.isEnabled = false
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
        inputnow.setTitle("Please wait until input time", for: .normal)
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
    }
    @IBOutlet var circle: UIImageView!
    
    
    @IBAction func emotionclick(_ sender: Any) {
        currentbutton?.setTitleColor(self.view.tintColor, for: .normal)
        currentbutton = (sender as! UIButton)
        currentemotion = (sender as AnyObject).currentTitle!
        (sender as AnyObject).setTitleColor(.red, for: .normal)
    }
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var textbox: UITextField!
    @IBOutlet weak var picview: UIImageView!
    @IBAction func tappic(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        textbox.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        picview.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clicksubmit(_ sender: Any) {
        
        readValues()
        //set up already submitted alert
        let alreadysubmitted = "You have already submitted " + String(moodList.count) + " today"
        let already = UIAlertController(title: "Already Done!", message: alreadysubmitted, preferredStyle: .alert)
        let alreadyOKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            self.textbox.text = self.currentemotion;
        })
        
        already.addAction(alreadyOKAction)
        
        
        
        //set up not submitted yet
        let alertmessage = "Submitting \"" + currentemotion.lowercased() + "\" as your emotion at " + (timestring.lowercased()) + String(moodList.count)
        let alert = UIAlertController(title: "Please Confirm your Data", message: alertmessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        })
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            self.textbox.text = self.currentemotion; self.resetpage();
        })
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        alert.preferredAction = OKAction
        
        
        let emptymessage = "Please Select an Emotion"
        let empty = UIAlertController(title: "No Selection", message: emptymessage, preferredStyle: .alert)
        let emptyOKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
        })
        empty.addAction(emptyOKAction)
        
        
        
        //if false{
        //if moodList.count > 0 || moodList.count == 1 && timestring == "Overall"{
        if currentemotion == ""{
            self.present(empty, animated: true, completion: nil)
        }
        else if !isready{
            self.present(already, animated: true, completion: nil)
        }else{
            self.present(alert, animated: true, completion: nil)
        
        
            //getting values from textfields
            let emotion = currentemotion.lowercased() as NSString
            let thetime = (timestring.lowercased()) as NSString
            
            
            let theFormatter = DateFormatter()
            theFormatter.dateFormat = "yyyy-MM-dd";
            let datestring = theFormatter.string(from: Date()) as NSString
            print(datestring)
            /*
            //validating that values are not empty
            if(name?.isEmpty)!{
                textFieldName.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            if(powerRanking?.isEmpty)!{
                textFieldName.layer.borderColor = UIColor.red.cgColor
                return
            }
            */
            
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
            print("Mood saved successfully")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textbox.text = textField.text
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
        
        print(mytime)
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

