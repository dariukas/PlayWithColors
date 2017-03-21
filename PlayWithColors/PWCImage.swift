//
//  PWCImage.swift
//  PlayWithColors
//
//  Created by Darius Miliauskas on 21/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class PWCImage: UIImage {
    
    func cgImage() -> CGImage? {
        if let ciImage = CIImage(image: self), let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil
    }
    
    //calculate the average color of UIImage
    func averageColor() -> UIColor {
        let rgba = getAverageColorData()
        if rgba[3] > 0 {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
        } else {
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    //find all colors of UIImage
    func findColors(dimension: Int = 100) -> [UIColor] {
        let rgba = getColorsData(dimension: dimension)
        var colours: [Any] = []
        for index1 in 0..<dimension {
            for index2 in 0..<dimension {
                let index = 4*(index1*dimension + index2)
                let colour: UIColor = UIColor(red: CGFloat(rgba[index])/255, green: CGFloat(rgba[index+1])/255, blue: CGFloat(rgba[index+2])/255, alpha: CGFloat(rgba[index+3])/255)
                colours.append(colour)
            }
        }
        return colours as! [UIColor]
    }
    
    //convert image colours data to the matrix
    func imageColorsToImageMatrix(colours: [UIColor], dimension: Int = 100) -> PWCImageMatrix {
        return PWCImageMatrix.init(colours, rows: dimension, columns: dimension)
    }
    
    internal func getAverageColorData() -> UnsafeMutablePointer<CUnsignedChar> {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue)!
        if let cgImage = self.cgImage() {
            context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
            //CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), cgImage)
        }
        return rgba
    }
    
    internal func getColorsData(dimension: Int) -> UnsafeMutablePointer<CUnsignedChar> {
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4*dimension*dimension)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        let context: CGContext = CGContext(data: rgba, width: dimension, height: dimension, bitsPerComponent: 8, bytesPerRow: 400, space: colorSpace, bitmapInfo: info.rawValue)!
        
        if let cgImage = self.cgImage() {
            context.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: Double(dimension), height: Double(dimension)))
        }
        return rgba
    }
    
}
