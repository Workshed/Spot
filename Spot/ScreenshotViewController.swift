//
//  ScreenshotViewController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

/// Drawing code taken from https://github.com/FlexMonkey/ForceSketch
class SpotViewController: UIViewController {
    
    @IBOutlet weak var screenshotImageView: UIImageView!
    
    var screenshot: UIImage?
    weak var delegate: SpotDelegate?
    
    let imageView = UIImageView()
    
    let hsb = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputBrightnessKey: 0.05])!
    let gaussianBlur = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputRadiusKey: 1])!
    let compositeFilter = CIFilter(name: "CISourceOverCompositing")!
    var imageAccumulator: CIImageAccumulator!
    var previousTouchLocation: CGPoint?
    
    private var shareReport: SpotReport?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let screenshot = screenshot, let screenshotImageView = screenshotImageView {
            screenshotImageView.image = screenshot
        }
        
        imageAccumulator = CIImageAccumulator(extent: view.frame, format: kCIFormatARGB8)
        
        view.addSubview(imageView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = touches.first?.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let event = event,
            let coalescedTouches = event.coalescedTouches(for: touch) else {
            return
        }
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        if let cgContext = UIGraphicsGetCurrentContext() {
        
            cgContext.setLineCap(CGLineCap.round)
            
            for coalescedTouch in coalescedTouches {
                let lineWidth: CGFloat
                if coalescedTouch.force != 0 {
                    lineWidth = (coalescedTouch.force / coalescedTouch.maximumPossibleForce) * 20
                }
                else {
                    lineWidth = 10
                }

                let lineColor = UIColor.blue.cgColor
                
                cgContext.setLineWidth(lineWidth)
                cgContext.setStrokeColor(lineColor)
                
                cgContext.move(to: previousTouchLocation!)
                cgContext.addLine(to: coalescedTouch.location(in: view))
                cgContext.strokePath()
                
                previousTouchLocation = coalescedTouch.location(in: view)
            }
            
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            compositeFilter.setValue(CIImage(image: drawnImage!),
                                     forKey: kCIInputImageKey)
            compositeFilter.setValue(imageAccumulator.image(),
                                     forKey: kCIInputBackgroundImageKey)
            guard let ciImage = compositeFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return }
            imageAccumulator.setImage(ciImage)
            
            imageView.image = UIImage(ciImage: imageAccumulator.image())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.frame
    }
    
    @IBAction func pressedShare(_ sender: Any) {
        let appName = Spot.appName()
        let email = self.delegate?.reportingEmailAddress()
        let reportInformation = Spot.reportInformation()
        let compositeImage = combinedImage()
        let additionalFile = self.delegate?.fileAttatchment()
        
        shareReport = SpotReport(appName: appName, emailRecipient: email, reportInformation: reportInformation, annotatedImage: compositeImage, screenshotImage: screenshot, additionalAttachment: additionalFile)
        performSegue(withIdentifier: "shareReport", sender: self)
    }
    
    @IBAction func pressedCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shareController = segue.destination as? ShareSelectionViewController {
            shareController.shareReport = shareReport
        }
    }
    
    func combinedImage() -> UIImage? {
        guard let drawnImage = imageView.image, let screenshotImage = screenshot else { return nil }
        return Spot.combine(bottom: screenshotImage, with: drawnImage)
    }
}
