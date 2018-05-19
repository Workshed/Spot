//
//  ShareSelectionViewController.swift
//  Spot
//
//  Created by Daniel Leivers on 18/05/2018.
//  Copyright © 2018 Daniel Leivers. All rights reserved.
//

import UIKit
import MessageUI
import Zip

class ShareSelectionViewController: UIViewController {
    
    var shareReport: SpotReport?

    @IBAction func pressedEmail() {
        showEmail()
    }
    
    @IBAction func pressedShare() {
        createZipPackage()
    }
    
    private func createZipPackage() {
        var fileUrls: [URL] = []
        
        if let combinedImageData = combinedImageData(), let imageUrl = tmpFile(forData: combinedImageData, fileName: "annotated", fileExtension: "png") {
            fileUrls.append(imageUrl)
        }
        
        if let screenshotImageData = screenshotData(), let imageUrl = tmpFile(forData: screenshotImageData, fileName: "original", fileExtension: "png") {
            fileUrls.append(imageUrl)
        }
        
        if let reportData = shareReport?.reportInformation.data(using: .utf8), let reportFileUrl = tmpFile(forData: reportData, fileName: "report", fileExtension: "txt") {
            fileUrls.append(reportFileUrl)
        }
        
        if let extraAttachment = shareReport?.additionalAttachment, let additionalAttachmentUrl = tmpFile(forData: extraAttachment.data, fileName: extraAttachment.fileName, fileExtension: extraAttachment.fileExtension) {
            fileUrls.append(additionalAttachmentUrl)
        }
        
        let fileName: String
        if let appName = shareReport?.appName {
            fileName = appName
        }
        else {
            fileName = "spotreport"
        }
        
        guard let reportZip = try? Zip.quickZipFiles(fileUrls, fileName: fileName) else { return }
        let shareViewController = UIActivityViewController(activityItems: [reportZip], applicationActivities: [])
        present(shareViewController, animated: true, completion: nil)
    }
    
    private func tmpFile(forData data: Data, fileName: String, fileExtension: String) -> URL? {
        let fileUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)

        do {
            try data.write(to: fileUrl, options: .atomic)
            return fileUrl
        } catch {
            print(error)
            return nil
        }
    }
}

// MARK: Email sharing

extension ShareSelectionViewController: MFMailComposeViewControllerDelegate {
    
    func showEmail() {
        guard let report = shareReport else { return }
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            if let email = report.emailRecipient {
                mailViewController.setToRecipients([email])
            }
            mailViewController.setSubject("\(report.appName) issue")
            mailViewController.setMessageBody(reportEmailMessageBody(), isHTML: false)
            
            if let combinedImageData = combinedImageData() {
                mailViewController.addAttachmentData(combinedImageData, mimeType: "image/png", fileName: "annotatedScreenshot.png")
            }
            
            if let screenshotData = screenshotData() {
                mailViewController.addAttachmentData(screenshotData, mimeType: "image/png", fileName: "originalScreenshot.png")
            }
            
            if let userAttachmentData = report.additionalAttachment {
                mailViewController.addAttachmentData(userAttachmentData.data, mimeType: userAttachmentData.mimeType, fileName: userAttachmentData.fileName + "." + userAttachmentData.fileExtension)
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
    
    private func reportEmailMessageBody() -> String {
        let instructions = "<Please tell us what happened here>"
        guard let report = shareReport else { return instructions }
        return "\(instructions)\n\n\(report.reportInformation)"
    }
    
    fileprivate func combinedImageData() -> Data? {
        guard let image = shareReport?.annotatedImage else { return nil }
        return UIImagePNGRepresentation(image)
    }
    
    fileprivate func screenshotData() -> Data? {
        guard let screenshot = shareReport?.screenshotImage else { return nil }
        return UIImagePNGRepresentation(screenshot)
    }
    
    // MARK: MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

