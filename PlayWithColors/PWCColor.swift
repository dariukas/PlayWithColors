//
//  PWCColor.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 23/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCColor: NSObject {
    
    func findColorPoints(_ color: Color, in imageMatrix: PWCImageMatrix) -> [(Int, Int)]  {
        var result = [(Int, Int)]()
        for i in 0..<imageMatrix.rows{
            for j in 0..<imageMatrix.columns{
                if (hueRangeFromColor(color) ~= getHueFromUIColor(imageMatrix[i, j])) {
                    result.append((i, j))
                }
            }
        }
        return result
    }
    
    func getHueFromUIColor(_ color: UIColor) -> Int {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        color.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return Int(360*hsba.h)
    }
    
    //http://www.workwithcolor.com/cyan-blue-color-hue-range-01.htm
    func hueRangeFromColor(_ color: Color) -> ClosedRange<Int> {
        switch color {
        case .Red:
            return 355...360 //0...10
        case .Orange:
            return 21...50
        case .Yellow:
            return 51...80
        case .Green:
            return 81...170
        case .Cyan:
            return 170...200
        case .Blue:
            return 201...240
        }
    }
}

enum Color {
    case Red
    case Orange
    case Yellow
    case Green
    case Cyan
    case Blue
}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        print(hsba)
        return hsba
    }
}
