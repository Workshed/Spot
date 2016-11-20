//
//  SpotHandlerTests.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import XCTest

class SpotHandlerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshot() {
        let screenshot = Spot.captureScreen()
        XCTAssertNotNil(screenshot)
    }
    
    func testScreenshotResolution() {
        if let screenshot = Spot.captureScreen() {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            XCTAssertEqual(screenshot.size.width, width)
            XCTAssertEqual(screenshot.size.height, height)
        }
    }
    
    func testDeviceModelName() {
        let model = Spot.modelName()
        XCTAssertNotNil(model)
    }
    
    func testAppName() {
        let appName = Spot.appName()
        XCTAssertNotNil(appName)
        XCTAssertEqual(appName, "Spot")
    }
    
    func testDeviceAppInfo() {
        let info = Spot.deviceAppInfo()
        XCTAssertNotNil(info)
    }
    
    func testCombineImages() {
        let rect = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContext(rect.size);
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            context.setFillColor(UIColor.blue.cgColor)
            context.fill(CGRect.init(x: 0, y: 0, width: 50, height: 100))
            let topImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            
            context.setFillColor(UIColor.red.cgColor)
            context.fill(rect)
            let bottomImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let bottomImage = bottomImage, let topImage = topImage {
                if let combinedImage = Spot.combine(bottom: bottomImage, with: topImage) {
                    XCTAssertNotNil(combinedImage)
                    
                    let leftColor = combinedImage.pixelColor(position: CGPoint.init(x: 25, y: 50))
                    let rightColor = combinedImage.pixelColor(position: CGPoint.init(x: 75, y: 50))
                    
                    XCTAssertEqual(leftColor, UIColor.blue)
                    XCTAssertEqual(rightColor, UIColor.red)
                }
                else {
                    XCTFail()
                }
            }
            else {
                XCTFail()
            }
        }
        else {
            XCTFail()
        }
        
    }
}

// http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
extension UIImage {
    func pixelColor(position: CGPoint) -> UIColor {
        var pixel : [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: UnsafeMutablePointer(mutating: pixel), width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        // Translate the context your required point(x,y)
        context!.translateBy(x: -(position.x), y: -(position.y));
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let redColor : Float = Float(pixel[0])/255.0
        let greenColor : Float = Float(pixel[1])/255.0
        let blueColor: Float = Float(pixel[2])/255.0
        let colorAlpha: Float = Float(pixel[3])/255.0
        
        // Create UIColor Object
        return UIColor(red: CGFloat(redColor), green: CGFloat(greenColor), blue: CGFloat(blueColor), alpha: CGFloat(colorAlpha))
    }
}
