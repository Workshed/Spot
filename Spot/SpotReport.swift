//
//  SpotReport.swift
//  Spot
//
//  Created by Daniel Leivers on 18/05/2018.
//  Copyright © 2018 Daniel Leivers. All rights reserved.
//

import Foundation
import UIKit

class SpotReport {
    let appName: String
    let emailRecipient: String?
    let reportInformation: String
    let annotatedImage: UIImage?
    let screenshotImage: UIImage?
    let additionalAttachment: SpotAttachment?
    
    init(appName: String,
         emailRecipient: String?,
         reportInformation: String,
         annotatedImage: UIImage?,
         screenshotImage: UIImage?,
         additionalAttachment: SpotAttachment?) {
        self.appName = appName
        self.emailRecipient = emailRecipient
        self.reportInformation = reportInformation
        self.annotatedImage = annotatedImage
        self.screenshotImage = screenshotImage
        self.additionalAttachment = additionalAttachment
    }
}
