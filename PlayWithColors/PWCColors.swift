//
//  PWCColors.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCColors: NSObject {
    
    //helper for analysis
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
    
    func replaceColor(colour: UIColor, in colours: [UIColor]) ->  [UIColor] {
        return colours.map {isSimilarColors(firstColor: $0, secondColor: colour) ? colour  : $0}
    }
    
    func mergeSimilarColors(_ colours: inout [UIColor], with tolerance: Int = 1) {
        //var mergedColours = colours
        for (colour, _) in findTheMainColours(colours: colours).reversed() {
            colours = replaceColor(colour: colour, in: colours)
            print(findTheMainColours(colours: colours).first?.1)
        }
        //print(findTheMainColours(colours: colours))
    }
    
    func findTheMainColours(colours: [UIColor]) -> [(UIColor, Int)] {
        // Create dictionary to map value to count
        var counts = [UIColor : Int]()
        colours.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        return reorderDictionaryByValue(counts)
    }
    
    func reorderDictionaryByValue(_ dictionary: [UIColor : Int]) -> [(UIColor, Int)] {
        var result = [(UIColor, Int)]()
        for (k,v) in (Array(dictionary).sorted {$0.1 > $1.1}) {
            result.append((k, v))
        }
        return result
    }
    

}
