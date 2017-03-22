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
//        let a: PWCColorObjectDetector =  PWCColorObjectDetector()
//        a.detect()
        
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
        if let img = PWCImage(data: data!) {
            //self.view.backgroundColor = color
           print(img.imageToImageMatrix())
            //draw(UIImage(cgImage: cgImage), with: CGSize(width: dimension, height: dimension))
        }
    }
 
    func draw(_ image: UIImage, with size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            //image.draw(at: CGPoint.zero)
            context.draw(image.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
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
