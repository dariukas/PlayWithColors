//
//  AdditionalMethods.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 18/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class AlternativeMethods: NSObject {
    
    func cgImageFromUIImage(_ uiImage: UIImage) -> CGImage? {
        if let ciImage = CIImage(image: uiImage), let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func findTheColors(cgImage: CGImage) {
        let dimension: Int = 100
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4*dimension*dimension)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        let context: CGContext = CGContext(data: rgba, width: dimension, height: dimension, bitsPerComponent: 8, bytesPerRow: 400, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: Double(dimension), height: Double(dimension)))
        //CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), cgImage)
        
        var colours: [Any] = []
        
        for index1 in 0..<dimension {
            for index2 in 0..<dimension {
                let index = 4*(index1*dimension + index2)
                let r: Int = Int(rgba[index])
                let g: Int = Int(rgba[index+1])
                let b: Int = Int(rgba[index+2])
                let alpha: Int = Int(rgba[index+3])
                let color: [Int] = [r, g, b, alpha]
                colours.append(color)
            }
        }
        //check for empty image
        guard colours.count>1 else {
            return
        }
        if let colours1 = colours as? [[Int]] {
            print(findTheMainColours(colours: colours1))
        }
    }
    
    func arraysToColors(_ colourArray: [[Int]]) -> [UIColor] {
        func toColor(_ colourArray: [Int]) -> UIColor { return UIColor(red: CGFloat(colourArray[0])/255, green: CGFloat(colourArray[1])/255, blue: CGFloat(colourArray[2])/255, alpha: CGFloat(colourArray[3])) }
        return colourArray.map {toColor($0)}
    }
    
    //http://stackoverflow.com/questions/12069494/rgb-similar-color-approximation-algorithm
    func isSimilarColors(firstColor: [Int], secondColor: [Int], with tolerance: Int = 10) -> Bool {
        guard (firstColor.count != secondColor.count) else {
            return false
        }
        let dr = firstColor[0] - secondColor[0]
        let dg = firstColor[1] - secondColor[1]
        let db = firstColor[2] - secondColor[2]
        let distance = sqrt(Double(dr*dr+dg*dg+db*db)/3.0)
        if (distance < Double(tolerance)) {
            return true
        }
        return false
    }
    
    func replaceColor(colour: [Int], in colours: [[Int]]) ->  [[Int]] {
        return colours.map {isSimilarColors(firstColor: $0, secondColor: colour) ? colour  : $0}
    }
    
    func findTheMainColours(colours: [[Int]]) -> [(UIColor, Int)] {
        // Create dictionary to map value to count
        var counts = [UIColor : Int]()
        arraysToColors(colours).forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        return reorderDictionaryByValue(counts)
    }
    
    func reorderDictionaryByValue(_ dictionary: [UIColor : Int]) -> [(UIColor, Int)] {
        var result = [(UIColor, Int)]()
        for (k,v) in (Array(dictionary).sorted {$0.1 > $1.1}) {
            result.append((k, v))
        }
        return result
    }
    
    //helper for analysis
    func groupColors(_ colours: [[Int]]) ->  [([Int], Int)] {
        var groupedColors: [([Int], Int)] = []
        var counts: ([Int], Int) = (colours.first!, 0)
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
