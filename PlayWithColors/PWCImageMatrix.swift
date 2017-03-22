//
//  PWCImageMatrix.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCImageMatrix: NSObject {
    
    internal var data: [UIColor]
    
    var rows: Int
    var columns: Int
    
    init(_ data: [UIColor], rows: Int, columns: Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int) {
        self.data = [UIColor](repeating: UIColor.white, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    
    //the singular matrices are not covered
    subscript(row: Int, col: Int) -> UIColor {
        get {
            return data[(row * columns) + col]
        }
        
        set {
            self.data[(row * columns) + col] = newValue
        }
    }
    
    //to turn a row or a column into an array.
    func row(index:Int) -> [UIColor] {
        var r = [UIColor]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        return r
    }
    func col(index:Int) -> [UIColor] {
        var c = [UIColor]()
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
    func copy(with zone: NSZone? = nil) -> PWCImageMatrix {
        let cp = PWCImageMatrix(self.data, rows:self.rows, columns:self.columns)
        return cp
    }
}
