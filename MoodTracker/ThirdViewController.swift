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

        if calculatedaily() { //if only once per day
            for curbutton in timebuttons{
                curbutton.isHidden = true
            }
        }else{
            for curbutton in timebuttons{
                curbutton.isHidden = false
            }
            currenttimevalue = 6
            
        }
        
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    var currenttogglevalue = 0
    var currenttimevalue = 6
    
    func calculatedaily()-> Bool{
        
        let today = Date()
        //var secondmonday = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let secondmonday = dateFormatter.date(from: "2019/02/18") ?? Date() //start of second week
        
        if today > secondmonday{//if we are still in first week
            return true
        }else{
            return false
        }
    }
    
    
    @IBOutlet var timebuttons: [UIButton]!
    @IBAction func morning(_ sender: UIButton) {
        
        currenttimevalue = 1
            
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    @IBAction func afternoon(_ sender: UIButton) {
        
        currenttimevalue = 3
        
       GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    @IBAction func lunchtime(_ sender: UIButton) {
        
        currenttimevalue = 2
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    @IBAction func evening(_ sender: UIButton) {
        
        currenttimevalue = 4
        
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    

    @IBAction func bedtime(_ sender: UIButton) {
        currenttimevalue = 5
        
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    @IBAction func overall(_ sender: UIButton) {
        
        currenttimevalue = 6
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    
    @IBAction func happiness(_ sender: UISegmentedControl) {
        
        currenttogglevalue = happytoggle.selectedSegmentIndex
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue)
        GraphView.setNeedsDisplay()
        setupGraphDisplay()
    }
    
    @IBOutlet var happytoggle: UISegmentedControl!
    
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
