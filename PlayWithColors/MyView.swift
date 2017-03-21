//
//  MyView.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 20/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class MyView: UIView {

    var context : CGContext?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
     //run()
     //   self.setNeedsDisplay()
        
       // draw(context!)
//        if let c : CGContext = UIGraphicsGetCurrentContext() {
//        draw(c)
//        }
      //  self.setNeedsDisplay()
        
//        ctx.cgContext.setFillColor(UIColor.red.cgColor)
//        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//        ctx.cgContext.setLineWidth(10)
//        
//        ctx.cgContext.addRect(rectangle)
//        ctx.cgContext.drawPath(using: .fillStroke)
        
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        
//        CGContextSaveGState(c);
//        CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
//        CGContextSetLineWidth(c,1.5f);
//        
//        for(CFIndex i = 0; i < CFArrayGetCount(_pathArray); i++)
//        {
//            CGPathRef path = CFArrayGetValueAtIndex(_pathArray, i);
//            CGContextAddPath(c, path);
//        }
//        
//        CGContextStrokePath(c);
//        
//        CGContextRestoreGState(c);
    }
    
    func draw(_ context: CGContext) {
        let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
        context.setFillColor(UIColor.red.cgColor)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(10)
        
        context.addRect(rectangle)
        context.drawPath(using: .fillStroke)
    }
    
    func run() {
        //http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        //http://stackoverflow.com/questions/24755558/measure-elapsed-time-in-swift
        //typealias, enum, inspectable, expandable, expantion, internal;  for loop cases, convertion between types, shortcuts Xcode, runtime, buildtime, apple account
        
        let url = URL(string: "https://wiki.waze.com/wiki/images/0/08/Lithuania_flag.png")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                //self.evaluatePerformance {
                    self.runMain(data)
                //}
            }
        }
    }
    
    func runMain(_ data: Data?) {
        if let img = UIImage(data: data!), let cgImage = cgImageFromUIImage(img) {
            //let color: UIColor = averageColor(cgImage: cgImage!)
            //print(color)
            //self.view.backgroundColor = color
            findTheColors(cgImage: cgImage)
        }
    }
    
    func cgImageFromUIImage(_ uiImage: UIImage) -> CGImage? {
        if let ciImage = CIImage(image: uiImage), let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    func averageColor(cgImage: CGImage) -> UIColor {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
        
        context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
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
        
        // let colour: UIColor = UIColor(red: CGFloat(rgba[404])/255, green: CGFloat(rgba[405])/255, blue: CGFloat(rgba[406])/255, alpha: CGFloat(rgba[index+3])/255)
        
        for index1 in 0..<dimension {
            for index2 in 0..<dimension {
                let index = 4*(index1*dimension + index2)
                let colour: UIColor = UIColor(red: CGFloat(rgba[index])/255, green: CGFloat(rgba[index+1])/255, blue: CGFloat(rgba[index+2])/255, alpha: CGFloat(rgba[index+3])/255)
                colours.append(colour)
            }
        }
        //print(colours)
        
        
        //check for empty image
        guard colours.count>1 else {
            return
        }
        
        //        if var colours1 = colours as? [UIColor] {
        //            //  print(findTheMainColours(colours: colours1))
        //            //   print("next: \(groupColors(colours1))")
        //            mergeSimilarColors(&colours1)
        //            addLabels(findTheMainColours(colours: colours1))
        //        }
        
        //draw(UIImage(cgImage: cgImage), with: CGSize(width: dimension, height: dimension))
    }
    

    
//    func addLabels(_ unit: [(UIColor, Int)]) {
//        let dh = view.frame.height/CGFloat(unit.count)
//        let size = CGSize(width: view.frame.width, height: dh)
//        
//        for index in 0..<unit.count {
//            let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: CGFloat(index)*dh), size: size))
//            label.center.x = view.center.x
//            label.backgroundColor = unit[index].0
//            label.text = unit[index].1.description
//            label.textAlignment = NSTextAlignment.center
//            view.addSubview(label)
//        }
//    }
    
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
