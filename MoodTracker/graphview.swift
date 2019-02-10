//
//  graphview.swift
//  MoodTracker
//
//  Created by Fiona Campbell on 20/12/2018.
//  Copyright © 2018 Fiona Campbell. All rights reserved.
//  tutorial @ raywenderlich.com/410-core-graphics-tutorial-part-2-gradients-and-contexts

import UIKit
import SQLite3

private struct Constants {
    static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 5.0
}

@IBDesignable class GraphView: UIView {
    
    //var graphPoints = getgraphvalues.returnnumbers(myvalue: 4)
    var graphPoints: [Int] = []// = getgraphvalues.returnnumbers(myvalue: 4)
    // 1
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    override func draw(_ rect: CGRect) {
        
        if graphPoints == []{
                   graphPoints = getgraphvalues.returnnumbers(myvalue: 0, selectedsegment: 0, mystate: 0)
        }
        
        
        //graphPoints = getgraphvalues.returnnumbers(myvalue: 4)
        let width = rect.width
        let height = rect.height
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        // 2
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        
        //calculate the x point
        
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        
        // calculate the y point
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y // Flip the graph
        }
        
        
        
        // draw the line graph
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        // set up the points line
        let graphPath = UIBezierPath()
        
        // go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //graphPath.stroke()
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        context.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        
        //5
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    
    
}



class getgraphvalues{
    static var moodList = [Moods]()
    static var count = 0
    static var db: OpaquePointer?
    static var iteration = 4
    var myvalue = 4
    
    class func returnnumbers(myvalue: Int, selectedsegment: Int, mystate: Int) -> [Int] {
        var activation = [0,0,0,0,0,0,0]
        var pleasedness = [0,0,0,0,0,0,0]
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) .appendingPathComponent("MoodDatabase.sqlite")
        
        //open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        readValues(myvalue: myvalue, mystate: mystate)
        
        var position = 0
        for currentmood in moodList {
            switch currentmood.emotion{
            case "alert":
                activation[position] = 10+1
                pleasedness[position] = 5+1
            case "nervous":
                activation[position] = 9+1
                pleasedness[position] = 4+1
            case "cheerful":
                activation[position] = 9+1
                pleasedness[position] = 6+1
            case "angry":
                activation[position] = 8+1
                pleasedness[position] = 3+1
            case "suprise":
                activation[position] = 8+1
                pleasedness[position] = 7+1
            case "stressed":
                activation[position] = 7+1
                pleasedness[position] = 2+1
            case "excited":
                activation[position] = 7+1
                pleasedness[position] = 8+1
            case "irritated":
                activation[position] = 6+1
                pleasedness[position] = 1+1
            case "delighted":
                activation[position] = 6+1
                pleasedness[position] = 9+1
            case "sad":
                activation[position] = 5+1
                pleasedness[position] = 0+1
            case "happy":
                activation[position] = 5+1
                pleasedness[position] = 10+1
            case "depressed":
                activation[position] = 4+1
                pleasedness[position] = 1+1
            case "pleasure":
                activation[position] = 4+1
                pleasedness[position] = 9+1
            case "bored":
                activation[position] = 3+1
                pleasedness[position] = 2+1
            case "hopeful":
                activation[position] = 3+1
                pleasedness[position] = 8+1
            case "fatigued":
                activation[position] = 2+1
                pleasedness[position] = 3+1
            case "content":
                activation[position] = 2+1
                pleasedness[position] = 7+1
            case "tired":
                activation[position] = 1+1
                pleasedness[position] = 4+1
            case "relaxed":
                activation[position] = 1+1
                pleasedness[position] = 6+1
            case "numb":
                activation[position] = 0+1
                pleasedness[position] = 5+1
                
            default:
                activation[position] = 0
                pleasedness[position] = 0
            }
            position = position + 1
        }
        if selectedsegment == 1 {
            return activation
        }
        else{return pleasedness}
    }
    
    class func readValues(myvalue: Int, mystate: Int){
        
        moodList.removeAll()
        //print("state", mystate, "value", myvalue)
        var queryString = "SELECT * FROM Mood"
        //if daily ie only "today" should be shown
        if mystate==0 {
            queryString = "SELECT * FROM Mood where thetime is \"today\" limit 7"
        }else if mystate==1{
            //if we are measuring throughout day, and we want the day overview ie morning through evening
            switch myvalue {
            case 1:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-11\" limit 7"
            case 2:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-12\" limit 7"
            case 3:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-13\" limit 7"
            case 4:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-14\" limit 7"
            case 5:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-15\" limit 7"
            case 6:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-16\" limit 7"
            default:
                queryString = "SELECT * FROM Mood where thedate is \"2019-02-17\" limit 7"
            }
        }else{
           //if we are measuring throughout day and we want moods for mornings through the week
            switch myvalue {
            case 1:
                queryString = "SELECT * FROM Mood where thetime is \"morning\" limit 7"
            case 2:
                queryString = "SELECT * FROM Mood where thetime is \"lunch\" limit 7"
            case 3:
                queryString = "SELECT * FROM Mood where thetime is \"afternoon\" limit 7"
            case 4:
                queryString = "SELECT * FROM Mood where thetime is \"evening\" limit 7"
            case 5:
                queryString = "SELECT * FROM Mood where thetime is \"bedtime\" limit 7"
            default:
                queryString = "SELECT * FROM Mood where thetime is \"overall\" limit 7"
            }

            
        }
                    //print("state", queryString)
        
        
        

        
        
        var stmt:OpaquePointer?

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }

        //traverse through all the moods
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let date = String(cString: sqlite3_column_text(stmt, 1))
            let time = String(cString: sqlite3_column_text(stmt, 2))
            let emotion = String(cString: sqlite3_column_text(stmt, 3))
            
            
            //adding values to list
            moodList.append(Moods(id: Int(id), date: String(describing: date), time: String(describing: time), emotion: String(describing: emotion)))
        }
        //print("state: numebr found:", moodList.count)
        count = 0
    }
    
    
    
}
