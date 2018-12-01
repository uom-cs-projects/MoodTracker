//
//  FourthViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 20/11/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet var Infobox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Infobox.text = "This app is a third year project research application with the University of Manchester. \nYou will spend a week inputting your mood throughout the day. \nThen you will spend a week inputting your mood throughout the day and at the end of the day.\nWe will use this data to figure out which is a better way of collecting your mood."
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
