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
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        run()
       // detect()
        
//        var colours: [[Int]] = [[0, 0, 0], [0, 0, 0], [10, 10, 9]]
//        colours = replaceColor(colour: [0, 0, 0, 0], in: colours)
//        print(colours)
//            var counts = [1:2, 2:4, 5:1, 8:2, 9:0]

//        print(counts)
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
        
        draw(UIImage(cgImage: cgImage), with: CGSize(width: dimension, height: dimension))
    }
    
    
    func draw(_ image: UIImage, with size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            //image.draw(at: CGPoint.zero)
            context.draw(cgImageFromUIImage(image)!, in: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
            let rectangle = CGRect(x: 0, y: 0, width: 20, height: 20)
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.addRect(rectangle)
            context.drawPath(using: .stroke)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imgView.image = newImage
        //view.setNeedsDisplay()
    }

    func addLabels(_ unit: [(UIColor, Int)]) {
        let dh = view.frame.height/CGFloat(unit.count)
        let size = CGSize(width: view.frame.width, height: dh)
        
        for index in 0..<unit.count {
            let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: CGFloat(index)*dh), size: size))
            label.center.x = view.center.x
            label.backgroundColor = unit[index].0
            label.text = unit[index].1.description
            label.textAlignment = NSTextAlignment.center
            view.addSubview(label)
        }
    }
    

        
    
    //detection
    func aroundPointsSet(_ point: Point, in range: Range<Int> = 0..<100) -> Set<Point> {
        var aroundPoints: Set<Point> = []
        var i = -1, j = -1
        if (point.column == 0) {
            i = 0
        }
        if (point.row == 0) {
            j = 0
        }
        
        for index1 in -i...1 {
            for index2 in j...1 {
                aroundPoints.update(with: Point.init(point.column+index1, point.row+index2))
            }
        }
        aroundPoints.remove(at: aroundPoints.index(of: Point.init(point.column, point.row))!)
        return aroundPoints
    }
    
    func findObjectPoints(_ thePoints: [Point]) -> Set<Point> {
        var allPoints = thePoints
        var objectPoints: Set<Point> = []
        //var allPoints = Set<Point>(points)
        
        func recursion (_ points: Set<Point>) {
            for point in points {
                objectPoints.update(with: point)
                allPoints.remove(at: allPoints.index(of: point)!)
                let aroundPoint = aroundPointsSet(point)
                let foundPointsAround = aroundPoint.intersection(allPoints)
                if (foundPointsAround.count < 1) { //to escape the func forever
                    recursion(foundPointsAround)
                }
            }
        }
        
        if let initialPoint = allPoints.first {
            let aroundInitialPoint = aroundPointsSet(initialPoint)
            let foundPointsAroundInitial = aroundInitialPoint.intersection(allPoints)
            recursion(foundPointsAroundInitial)
        }
        return objectPoints
    }
    
    func detect() {
        //find the coordinates
        let colors = [(0, 1), (1, 1), (1, 2), (5, 5), (2, 2), (3, 1)]
        
        var points: [Point] = []
        for (x, y) in colors {
            let point = Point.init(x, y)
            points.append(point)
        }
        print(findObjectPoints(points))
        //find max and min of x y to make rectangle
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

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

//extension CGPoint: Hashable {
//    public var hashValue: Int {
//        return self.x.hashValue << sizeof(CGFloat) ^ self.y.hashValue
//    }
//}
//
//// Hashable requires Equatable, so define the equality function for CGPoints.
//public func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
//    return lhs.equalTo(rhs)
//}
