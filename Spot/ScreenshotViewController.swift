//
//  ScreenshotViewController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit
import MessageUI

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
            
            imageAccumulator.setImage(compositeFilter.value(forKey: kCIOutputImageKey) as! CIImage)
            
            imageView.image = UIImage(ciImage: imageAccumulator.image())
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        previousTouchLocation = nil
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = view.frame
    }
    
    @IBAction func pressedSend(_ sender: Any) {
        showEmail()
    }
    
    @IBAction func pressedCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension SpotViewController: MFMailComposeViewControllerDelegate {
    
    func showEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            if let email = self.delegate?.reportingEmailAddress() {
                mailViewController.setToRecipients([email])
            }
            mailViewController.setSubject("\(Spot.appName()) issue")
            mailViewController.setMessageBody(Spot.reportEmailMessageBody(), isHTML: false)
            
            if let combinedImageData = combinedImageData() {
                mailViewController.addAttachmentData(combinedImageData, mimeType: "image/png", fileName: "annotatedScreenshot.png")
            }
            
            if let screenshotData = screenshotData() {
                mailViewController.addAttachmentData(screenshotData, mimeType: "image/png", fileName: "originalScreenshot.png")
            }
            
            if let userAttachmentData = self.delegate?.fileAttatchment() {
                mailViewController.addAttachmentData(userAttachmentData.data, mimeType: userAttachmentData.mimeType, fileName: userAttachmentData.filename)
            }
            
            self.present(mailViewController, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "No email account available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
                
            present(alert, animated: true, completion: nil)
        }
    }
    
    func combinedImageData() -> Data? {
        var combinedImageData: Data?
        if let drawnImage = imageView.image, let screenshotImage = screenshot {
            if let combinedImage = Spot.combine(bottom: screenshotImage, with: drawnImage) {
                combinedImageData = UIImagePNGRepresentation(combinedImage)
            }
        }
        
        return combinedImageData
    }
    
    func screenshotData() -> Data? {
        var screenshotData: Data?
        if let screenshot = screenshot {
            screenshotData = UIImagePNGRepresentation(screenshot)
        }
        
        return screenshotData
    }
    
    // MARK: MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
