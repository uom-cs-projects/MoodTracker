//
//  ThirdViewController.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 19/11/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var GraphView: GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title="Stats"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if calculatedaily() { //if only once per day
            currentstate = 0
            DayTime.isHidden = true
            whichday.isHidden = true
            whichtime.isHidden = true
            timelabels.isHidden = true
        }else{
            currenttimevalue = 6
            currentstate = 1
            
            whichday.isHidden = false
            whichtime.isHidden = true
            daylabels.isHidden = true
            timelabels.isHidden = false
            DayTime.selectedSegmentIndex = currentstate
            whichday.selectedSegmentIndex = currenttimevalue-1
            whichtime.selectedSegmentIndex = currenttimevalue-1
        }


        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue, mystate: currentstate)
        //GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: 0, selectedsegment: 0, mystate: 0)
        GraphView.setNeedsDisplay()
        //print("toggle", currenttogglevalue, "time", currenttimevalue, "state", currentstate)
        happytoggle.selectedSegmentIndex = currenttogglevalue
        
        
    }
    
    var currenttogglevalue = 0
    var currenttimevalue = 6
    var currentstate = 0
    
    func calculatedaily()-> Bool{
        
        let today = Date()
        //var secondmonday = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        //group 1
        let secondmonday = dateFormatter.date(from: "2019/02/18") ?? Date() //start of second week
        
        if today < secondmonday{//if we are still in first week, group 1
            return true
        }else{
            return false
        }
 /*
        
        //group 2
        if today >= secondmonday{//if we are in second week, group 2
            return true
        }else{
            return false
        }
        */
        
        
    }
    
    func refreshgraph(){
        
        GraphView.graphPoints = getgraphvalues.returnnumbers(myvalue: currenttimevalue, selectedsegment: currenttogglevalue, mystate: currentstate)
        GraphView.setNeedsDisplay()
        //print("toggle", currenttogglevalue, "time", currenttimevalue, "state", currentstate)
        
    }
    
    
    @IBAction func happiness(_ sender: UISegmentedControl) {
        currenttogglevalue = happytoggle.selectedSegmentIndex
        refreshgraph()
    }
    
    @IBAction func DayTime(_ sender: Any) {
        currentstate = DayTime.selectedSegmentIndex + 1
        refreshgraph()
        if DayTime.selectedSegmentIndex == 0 {
            whichday.isHidden = false
            whichtime.isHidden = true
            daylabels.isHidden = true
            timelabels.isHidden = false
        }else{
            whichday.isHidden = true
            whichtime.isHidden = false
            daylabels.isHidden = false
            timelabels.isHidden = true
        }
    }
    
    
    @IBAction func changetime(_ sender: Any) {
        currenttimevalue = whichtime.selectedSegmentIndex + 1
        refreshgraph()
    }
    
    
    @IBAction func changeday(_ sender: Any) {
        currenttimevalue = whichday.selectedSegmentIndex + 1
        refreshgraph()
    }
    
    
    @IBOutlet var timelabels: UILabel!
    @IBOutlet var daylabels: UILabel!
    @IBOutlet var happytoggle: UISegmentedControl!
    @IBOutlet var DayTime: UISegmentedControl!
    
    @IBOutlet var whichtime: UISegmentedControl!
    @IBOutlet var whichday: UISegmentedControl!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
