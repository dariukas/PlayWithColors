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
    
    func replaceSimilarColor(colour: UIColor, in colours: [UIColor]) ->  [UIColor] {
        return colours.map {isSimilarColors(firstColor: $0, secondColor: colour) ? colour  : $0}
    }
    
    //http://stackoverflow.com/questions/12069494/rgb-similar-color-approximation-algorithm
    func isSimilarColors(firstColor: UIColor, secondColor: UIColor, with tolerance: Double = 0.16) -> Bool {
        if let firstColorComponents = firstColor.cgColor.components, let secondColorComponents = secondColor.cgColor.components {
            let dr = firstColorComponents[0] - secondColorComponents[0]
            let dg = firstColorComponents[1] - secondColorComponents[1]
            let db = firstColorComponents[2] - secondColorComponents[2]
            let distance = sqrt(Double(dr*dr+dg*dg+db*db)/3.0)
            if (distance < tolerance) {
                return true
            }
        }
        return false
    }
    
    func sortColoursByFrequency() -> [(UIColor, Int)] {
        // Create dictionary to map value to count
        var counts = [UIColor : Int]()
        self.colours.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        return reorderDictionaryByValue(counts)
    }
    
    func reorderDictionaryByValue(_ dictionary: [UIColor : Int]) -> [(UIColor, Int)] {
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
