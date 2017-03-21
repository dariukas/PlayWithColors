//
//  PWCColorObjectDetector.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCColorObjectDetector: NSObject {
    
    func detect() {
        //find the coordinates of the color HSL
        let colors = [(0, 1), (1, 1), (1, 2), (5, 5), (2, 2), (3, 1), (2, 3)]
        let points: [Point] = matrixToPoints(colors)
        findRedColor()
        //print(detectColorObjectPointsAlternative(points))
        //print(detectColorObjectPoints(points))
        //print(boundingBox(detectColorObjectPoints(points)))
    }
    
    func findRedColor() {
        
        let color = UIColor.blue
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        color.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        
        print(hsba.h)
        
        //using matrix
        //        var redColour: [UIColor] =
        
    }
    
    internal func matrixToPoints(_ detectedPoints: [(Int, Int)]) -> [Point] {
        var points: [Point] = []
        for (x, y) in detectedPoints {
            let point = Point.init(x, y)
            points.append(point)
        }
        return points
    }
    
    internal func boundingBox(_ points: Set<Point>) -> CGRect {
        //let point: Point = array.max{$0.column > $1.column}
        let columns = points.map{$0.column}
        let rows = points.map{$0.row}
        if let minX = columns.min(), let minY = rows.min(), let maxX = columns.max(), let maxY=rows.max(){
            return CGRect(x:minX, y: minY, width: maxX-minX, height: maxY-minY)
        }
        return CGRect.zero
    }
    
    // MARK: Helpers
    
    internal func detectColorObjectPoints(_ thePoints: [Point]) -> Set<Point> {
        //var allColorPointsSet = Set<Point>(allColorPoints)
        var allColorPoints = thePoints
        var colorObjectPoints: Set<Point> = []
        
        func recursion (_ points: Set<Point>) {
            for point in points {
                colorObjectPoints.update(with: point)
                if let indexOfColorPoint = allColorPoints.index(of: point){
                    allColorPoints.remove(at: indexOfColorPoint)
                }
            }
            
            for point in points {
                let aroundPointsSet = findAroundPoints(point)
                let colorAroundPointSet = aroundPointsSet.intersection(allColorPoints)
                if (colorAroundPointSet.count > 0) { //to escape the func forever
                    recursion(colorAroundPointSet)
                }
            }
        }
        
        if let seedPoint = allColorPoints.first {
            let aroundSeedPoint = findAroundPoints(seedPoint)
            let colorAroundSeedPointSet = aroundSeedPoint.intersection(allColorPoints)
            recursion(colorAroundSeedPointSet)
        }
        return colorObjectPoints
    }
    
    internal func findAroundPoints(_ point: Point) -> Set<Point> {
        var aroundPoints: Set<Point> = []
        
        //the validation of row=column=0 or dimension not necessary
        //since the data matrices have no that members like (-1, -1), and the substract set will omit these values
        
        for index1 in -1...1 {
            for index2 in -1...1 {
                aroundPoints.update(with: Point.init(point.column+index1, point.row+index2))
            }
        }
        //aroundPoints.remove(at: aroundPoints.index(of: Point.init(point.column, point.row))!) //exclude the point itself
        return aroundPoints
    }
    
    // MARK: Using Alternative Algorithm
    
    internal func detectColorObjectPointsAlternative(_ thePoints: [Point]) -> Set<Point> {
        var allColorPoints = thePoints
        var colorObjectPoints: Set<Point> = []
        let seedPoint = allColorPoints.first! //could be another for the next object
        
        func recursion (_ point: Point) {
            if let index = allColorPoints.index(of: point){
                allColorPoints.remove(at: index)
                colorObjectPoints.update(with: point)
            }
            for colorPoint in allColorPoints {
                if (colorPoint.isNeighborTo(point)){
                        recursion(colorPoint)
                }
            }
        }
        recursion(seedPoint)
        return colorObjectPoints
    }
    
    //not used
    internal func areNeighbors (lhs: Point, rhs: Point) -> Bool {
        return abs((lhs.column - rhs.column)*(lhs.row - rhs.row)) <= 1
    }
    
}

struct Point: Hashable {
    var column: Int
    var row: Int
    
    init(_ column: Int, _ row: Int) {
        //self.init(column: column, row: row)
        self.column = column
        self.row = row
    }
    //        {
    //        set(row){
    //            row = row
    //        }
    //        get{
    //            return row
    //        }
    //    }
    
    var hashValue: Int {
        return column.hashValue+row.hashValue
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    func isNeighborTo(_ point: Point) -> Bool {
         return abs((self.column - point.column)*(self.row - point.row)) <= 1
    }
}
