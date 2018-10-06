//
//  SecondViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 06/10/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var textbox: UITextField!
    
    @IBAction func clicksubmit(_ sender: Any) {
        textbox.text = "test";
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

