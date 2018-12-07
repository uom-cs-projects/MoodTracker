//
//  SecondViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 06/10/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textbox.delegate = self
        currentbutton = alertbutton
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 6..<11:
            timestring = "Morning"
        case 11..<15:
            timestring = "Lunch"
        case 15..<18:
            timestring = "Afternoon"
        case 18..<22:
            timestring = "Evening"
        default:
            timestring = "Bed Time"
        }
        
        
    }

    var currentbutton : UIButton?
    var currentemotion = ""
    @IBOutlet var alertbutton: UIButton!
    var confirmemotion = UIAlertController()
    var timestring : String?
    

    
    
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
        
        let alertmessage = "Submitting \"" + currentemotion.lowercased() + "\" as your emotion at " + (timestring?.lowercased())!
        let alert = UIAlertController(title: "Please Confirm your Data", message: alertmessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"Cancel\" alert occured.")
        })
        
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            self.textbox.text = self.currentemotion;
        })
        
        alert.addAction(cancelAction)
        alert.addAction(OKAction)
        alert.preferredAction = OKAction
        self.present(alert, animated: true, completion: nil)
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


}

