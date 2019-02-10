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
        
        Infobox.text = "This app is a third year project research application with the University of Manchester. \nYou will spend a week inputting your mood throughout the day.\nThen you will spend a week inputting your mood throughout the day and at the end of the day\nWe will use this data to figure out which is a better way of collecting your mood.\nPlease set yourself a reminder to remind you of when to input data. You cannot edit, delete or retrospectively input a reading, however don't worry if you miss one. The graph will only show you your results from the current week, however the history log will show them all.\n\n\nResources for  Low Mood:\nwww.nhs.uk/conditions/stress-anxiety-depression/\n\nwww.mind.org.uk/information-support/\n\nwww.selfhelpservices.org.uk\n\nwww.studentsagainstdepression.org\n\nUnder 16s:\nhttps://youngminds.org.uk/find-help/\n\nHelplines:\nwww.nhs.uk/conditions/stress-anxiety-depression/mental-health-helplines/\n\nhttp://manchester.nightline.ac.uk"
        
        
        
        navigationController?.navigationBar.topItem?.title="Help"
        navigationController?.navigationBar.prefersLargeTitles = true
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
