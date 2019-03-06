//
//  FirstViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 06/10/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet var circleimage: UIImageView!
    var isready = true
    
    @IBAction func gotoinputpage(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBOutlet var inputnow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        isready = true //demo
        
        if isready {
            circleimage.image = #imageLiteral(resourceName: "green")
            inputnow.setTitle("Input data now!", for: .normal)
            inputnow.isEnabled = true
            
        }else{
            circleimage.image = #imageLiteral(resourceName: "orange")
            inputnow.setTitle("Please wait until input time", for: .normal)
            inputnow.isEnabled = false
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

