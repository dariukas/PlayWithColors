//
//  PWCColorObjectDetector.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCColorObjectDetector: NSObject {
    
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
    
    // MARK: Using Another Algorithm
    
    internal func close(lhs: Point, rhs: Point) -> Bool {
        return lhs.column == rhs.column+1 && lhs.row == rhs.row+1
    }

    
    internal func detectColorObjectPoints2(_ thePoints: [Point]) -> Set<Point> {

        var allColorPoints = thePoints
        let seedPoint = allColorPoints.first
        
        for point in allColorPoints {
        
            if (lhs.column == rhs.column && lhs.row == rhs.row) {
            
            
            }
        
        }
        
        
        var colorObjectPoints: Set<Point> = []
        
        func recursion (_ points: Set<Point>) {
            for point in points {
                colorObjectPoints.update(with: point)
                allColorPoints.remove(at: allColorPoints.index(of: point)!)
            }
            
            for point in points {
                let aroundPointsSet = findAroundPoints(point)
                let colorAroundPointSet = aroundPointsSet.intersection(allColorPoints)
                if (colorAroundPointSet.count > 0) { //to escape the func forever
                    recursion(colorAroundPointSet)
                }
            }
        }
        
        if let initialPoint = allColorPoints.first {
            let aroundInitialPoint = findAroundPoints(initialPoint)
            let colorAroundInitialPointSet = aroundInitialPoint.intersection(allColorPoints)
            recursion(colorAroundInitialPointSet)
        }
        return colorObjectPoints
    }
    
    // MARK: Helpers
    
    internal func detectColorObjectPoints(_ thePoints: [Point]) -> Set<Point> {
        //var allColorPointsSet = Set<Point>(allColorPoints)
        var allColorPoints = thePoints
        var colorObjectPoints: Set<Point> = []
        
        func recursion (_ points: Set<Point>) {
            for point in points {
                colorObjectPoints.update(with: point)
                allColorPoints.remove(at: allColorPoints.index(of: point)!)
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
    
    func detect() {
        //find the coordinates of the color HSL
        let colors = [(0, 1), (1, 1), (1, 2), (5, 5), (2, 2), (3, 1), (2, 3)]
        let points: [Point] = matrixToPoints(colors)
        //print(detectColorObjectPoints(points))
         print(boundingBox(detectColorObjectPoints(points)))
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
}
