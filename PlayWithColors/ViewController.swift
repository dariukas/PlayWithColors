//
//  ViewController.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 14/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//


//http://stackoverflow.com/questions/14609132/crop-uiimage-to-fit-a-frame-image

//http://stackoverflow.com/questions/26330924/get-average-color-of-uiimage-in-swift
//http://stackoverflow.com/questions/13694618/objective-c-getting-least-used-and-most-used-color-in-a-image
//https://developer.apple.com/reference/coreimage/ciimage/1437996-extent

import UIKit

class ViewController: UIViewController {
    
    //var context: CGContext
    let context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //run()
        
        var colours: [[Int]] = [[0, 0, 0], [0, 0, 0], [10, 10, 9]]
        colours = replaceColor(colour: [0, 0, 0, 0], in: colours)
        print(colours)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func evaluatePerformance(blockToEvaluate: () -> Void) {
        let start = DispatchTime.now()
        blockToEvaluate()
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("It took: \(timeInterval) seconds")
    }
    
    func run() {
        //http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        //http://stackoverflow.com/questions/24755558/measure-elapsed-time-in-swift
        //typealias, enum, inspectable, expandable, expantion, internal;  for loop cases, convertion between types, shortcuts Xcode, runtime, buildtime, apple account
        
        let url = URL(string: "https://wiki.waze.com/wiki/images/0/08/Lithuania_flag.png")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.evaluatePerformance {
                    self.runMain(data)
                }
            }
        }
    }
    
    func runMain(_ data: Data?) {
        let img = UIImage(data: data!)
        let ciImage = CIImage(image: img!)
        let cgImage = convertCIImageToCGImage(inputImage: ciImage!)
        //let color: UIColor = averageColor(cgImage: cgImage!)
        //print(color)
        //self.view.backgroundColor = color
        findTheColors(cgImage: cgImage!)
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
    func averageColor(cgImage: CGImage) -> UIColor {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(cgImage, in: CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0))
        //CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), cgImage)
        
        if rgba[3] > 0 {
            
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
            
        } else {
            
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    func findTheColors(cgImage: CGImage) {
        let dimension: Int = 100
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4*dimension*dimension)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        let context: CGContext = CGContext(data: rgba, width: dimension, height: dimension, bitsPerComponent: 8, bytesPerRow: 400, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: Double(dimension), height: Double(dimension)))
        var colours: [Any] = []
        
        for index1 in 0...dimension {
            for index2 in 0...dimension {
                let index = 4*(index1*dimension + index2)
                let r: Int = Int(rgba[index])
                let g: Int = Int(rgba[index+1])
                let b: Int = Int(rgba[index+2])
                let alpha: Int = Int(rgba[index+3])
                let color: [Int] = [r, g, b, alpha]
                colours.append(color)
            }
        }
        print(colours)
        
        
        //check for empty image
        guard colours.count<1 else {
            return
        }
        
        if let colours1 = colours as? [[Int]] {
            print("next: \(groupColors(colours1))")
        }
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
    
    
    func mergeSimilarColors(_ colours: [[Int]], with tolerance: Int) {
        
        
    }
    
    func arraysToColors(_ colourArray: [[Int]]) -> [UIColor] {
        func toColor(_ colourArray: [Int]) -> UIColor { return UIColor(red: CGFloat(colourArray[0])/255, green: CGFloat(colourArray[1])/255, blue: CGFloat(colourArray[2])/255, alpha: CGFloat(colourArray[3])) }
        return colourArray.map {toColor($0)}
    }
    
    func findTheMainColours(colours: [[Int]]) -> [UIColor : Int] {
        // Create dictionary to map value to count
        var counts = [UIColor : Int]()
        arraysToColors(colours).forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        return counts.sorted(by: {$0.1 < $1.1}) as! [UIColor : Int]
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
