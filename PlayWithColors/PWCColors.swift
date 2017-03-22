//
//  PWCColors.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCColors: NSObject {
    
    var colours: [UIColor]
    
    init(_ colours: [UIColor]) {
        self.colours = colours
    }

    func findColor(_ color: Color, in matrix: PWCImageMatrix) {
        
        
//        for matrix[i, j] in matrix {
//        
//        
//        
//        }
        
        let a : UIColor = matrix[1, 1]
        
        if (getHueFromUIColor(a) ~= hueRangeFromColor(color) {
            
            
        }
    }
    
    func getHueFromUIColor(_ color: UIColor) -> CGFloat {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        color.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba.h
    }
    
    //http://www.workwithcolor.com/cyan-blue-color-hue-range-01.htm
    func hueRangeFromColor(_ color: Color) -> ClosedRange<CGFloat> {
        switch color {
        case .Red:
            return 355...360
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
    
    //the colours are changed
    func mergeSimilarColors(tolerance: Int = 1) {
        for (colour, _) in sortColoursByFrequency().reversed() {
            self.colours = replaceSimilarColor(colour: colour, in: self.colours)
        }
    }
    
    //the colors are changed temporarily
    func afterMergeSimilarColors(tolerance: Int = 1) -> [UIColor] {
        var mergedColours: [UIColor] = self.colours
        for (colour, _) in sortColoursByFrequency().reversed() {
            mergedColours = replaceSimilarColor(colour: colour, in: mergedColours)
        }
        return mergedColours
    }
    
//    func mergeSimilarColors(_ colours: inout [UIColor], with tolerance: Int = 1) {
//        for (colour, _) in sortColoursByFrequency().reversed() {
//            colours = replaceSimilarColor(colour: colour, in: colours)
//            print(sortColoursByFrequency().first?.1)
//        }
//    }
    
    internal func replaceSimilarColor(colour: UIColor, in colours: [UIColor]) ->  [UIColor] {
        return colours.map{isSimilarColors(firstColor: $0, secondColor: colour) ? colour  : $0}
    }
    
    //http://stackoverflow.com/questions/12069494/rgb-similar-color-approximation-algorithm
    func isSimilarColors(firstColor: UIColor, secondColor: UIColor, with tolerance: Double = 0.16) -> Bool {
        if let firstColorComponents = firstColor.cgColor.components, let secondColorComponents = secondColor.cgColor.components {
            let dr = firstColorComponents[0] - secondColorComponents[0]
            let dg = firstColorComponents[1] - secondColorComponents[1]
            let db = firstColorComponents[2] - secondColorComponents[2]
            return sqrt(Double(dr*dr+dg*dg+db*db)/3.0) < tolerance
        }
        return false
    }
    
    func sortColoursByFrequency() -> [(UIColor, Int)] {
        // Create dictionary to map value to count
        var counts = [UIColor : Int]()
        self.colours.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        return reorderDictionaryByValue(counts)
    }
    
    internal func reorderDictionaryByValue(_ dictionary: [UIColor : Int]) -> [(UIColor, Int)] {
        var result = [(UIColor, Int)]()
        for (k,v) in (Array(dictionary).sorted {$0.1 > $1.1}) {
            result.append((k, v))
        }
        return result
    }
    
    // MARK: Helpers
    
    func groupColors(_ colours: [UIColor]) ->  [(UIColor, Int)] {
        var groupedColors: [(UIColor, Int)] = []
        var counts: (UIColor, Int) = (colours.first!, 0)
        colours.forEach {
            if (counts.0==$0) {
                counts.1  = (counts.1) + 1
            } else {
                groupedColors.append(counts)
                counts.0 = $0
                counts.1 = 1
            }
        }
        return groupedColors
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
