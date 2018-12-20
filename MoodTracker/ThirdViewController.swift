//
//  ThirdViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 19/11/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    
    
    struct numberss {
        var numbers = [1,2,3,4,5,6,7]
    }
    @IBOutlet weak var GraphView: GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {

        setupGraphDisplay()
    }
    
    func setupGraphDisplay() {
    
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
