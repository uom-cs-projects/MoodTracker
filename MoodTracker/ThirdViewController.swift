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
        navigationController?.navigationBar.topItem?.title="Stats"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        

        if calculatedaily() { //if only once per day
            currentstate = 0
        }else{
            currenttimevalue = 6
            currentstate = 1
        }
        
        for curbutton in timebuttons{
            curbutton.isHidden = true
        }
        for curbutton in datebuttons{
            curbutton.isHidden = false
        }

        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue, mystate: currentstate)
        GraphView.setNeedsDisplay()
        print("toggle", currenttogglevalue, "time", currenttimevalue, "state", currentstate)
    }
    
    var currenttogglevalue = 0
    var currenttimevalue = 6
    var currentstate = 0
    
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
    
    func refreshgraph(){
        
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue, mystate: currentstate)
        GraphView.setNeedsDisplay()
        print("toggle", currenttogglevalue, "time", currenttimevalue, "state", currentstate)
        
    }
    
    
    @IBOutlet var datebuttons: [UIButton]!
    @IBOutlet var timebuttons: [UIButton]!
    @IBAction func morning(_ sender: UIButton) {
        
        currenttimevalue = 1
        refreshgraph()
    }
    
    @IBAction func afternoon(_ sender: UIButton) {
        
        currenttimevalue = 3
        refreshgraph()
    }
    
    @IBAction func lunchtime(_ sender: UIButton) {
        
        currenttimevalue = 2
        refreshgraph()
    }
    
    @IBAction func evening(_ sender: UIButton) {
        
        currenttimevalue = 4
        refreshgraph()
    }
    

    @IBAction func bedtime(_ sender: UIButton) {
        currenttimevalue = 5
        refreshgraph()
    }
    @IBAction func overall(_ sender: UIButton) {
        
        currenttimevalue = 6
        refreshgraph()
    }
    
    @IBAction func monday(_ sender: Any) {
        currenttimevalue = 1
        refreshgraph()
    }
    
    @IBAction func tuesday(_ sender: Any) {
        currenttimevalue = 2
        refreshgraph()
    }
    
    @IBAction func wednesday(_ sender: Any) {
        currenttimevalue = 3
        refreshgraph()
    }
    
    @IBAction func thursday(_ sender: Any) {
        currenttimevalue = 4
        refreshgraph()
    }
    
    @IBAction func friday(_ sender: Any) {
        currenttimevalue = 5
        refreshgraph()
    }
    
    @IBAction func saturday(_ sender: Any) {
        currenttimevalue = 6
        refreshgraph()
    }
    
    @IBAction func sunday(_ sender: Any) {
        currenttimevalue = 7
        refreshgraph()
    }
    
    
    @IBAction func happiness(_ sender: UISegmentedControl) {
        currenttogglevalue = happytoggle.selectedSegmentIndex
        refreshgraph()
    }
    
    @IBAction func DayTime(_ sender: Any) {
        currentstate = DayTime.selectedSegmentIndex + 1
        refreshgraph()
        if DayTime.selectedSegmentIndex == 0 {
            for curbutton in timebuttons{
                curbutton.isHidden = true
            }
            for curbutton in datebuttons{
                curbutton.isHidden = false
            }
        }else{
            for curbutton in timebuttons{
                curbutton.isHidden = false
            }
            for curbutton in datebuttons{
                curbutton.isHidden = true
            }
        }
    }
    @IBOutlet var happytoggle: UISegmentedControl!
    @IBOutlet var DayTime: UISegmentedControl!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
