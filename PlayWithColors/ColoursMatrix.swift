//
//  ColoursMatrix.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 16/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//  Following: http://blog.karmadust.com/creating-a-matrix-class-in-swift-3-0/

import UIKit
import Accelerate

class ColoursMatrix: NSObject {
    
    internal var data: [[Int]]
    
    var rows: Int
    var columns: Int
    
    init(_ data: [[Int]], rows: Int, columns: Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int) {
        self.data = [[Int]](repeating: [0, 0, 0, 0], count: rows*columns)
        self.rows = rows
        self.columns = columns
    }

    subscript(row: Int, col: Int) -> [Int] {
        get {
            return data[(row * columns) + col]
        }
        
        set {
            self.data[(row * columns) + col] = newValue
        }
    }

    //to turn a row or a column into an array.
    func row(index:Int) -> [[Int]] {
        var r = [[Int]]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        return r
    }
    func col(index:Int) -> [[Int]] {
        var c = [[Int]]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        return c
    }
    
    //printing data
    override var description: String {
        var dsc = ""
        for row in 0..<rows {
            for col in 0..<columns {
                let s = "\(self[row,col])"
                dsc += s + " "
            }
            dsc += "\n"
        }
        return dsc
    }
    
    //copying
    func copy(with zone: NSZone? = nil) -> ColoursMatrix {
        let cp = ColoursMatrix(self.data, rows:self.rows, columns:self.columns)
        return cp
    }


    
    
}

// definitions to accelerate
//typealias Vector = [[Int]]
//infix operator **
//func **(left: Vector, right: Vector) -> [Int] {
//    precondition(left.count == right.count)
//    var d: [Int] = [0, 0, 0, 0]
//    for i in 0..<left.count {
//        d += left[i] * right[i]
//    }
//    return d
//}
//
//func **(left: Vector, right: Vector) -> [Int] {
//    precondition(left.count == right.count)
//    var d: [Int] = [0, 0, 0, 0]
//    vDSP_dotprD(left, 1, right, 1, &d, vDSP_Length(left.count))
//    return d
//}
