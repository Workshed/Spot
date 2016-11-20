//
//  OrientationLockNavigationController.swift
//  Spot
//
//  Created by Daniel Leivers on 20/11/2016.
//  Copyright © 2016 Daniel Leivers. All rights reserved.
//

import UIKit

class OrientationLockNavigationController: UINavigationController {
    
    var orientationToLock: UIDeviceOrientation =  UIDeviceOrientation.portrait

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch orientationToLock {
            case .portrait:
                return UIInterfaceOrientationMask.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientationMask.portraitUpsideDown
        case .landscapeLeft:
            return UIInterfaceOrientationMask.landscapeLeft
        case .landscapeRight:
            return UIInterfaceOrientationMask.landscapeRight
        default:
            return UIInterfaceOrientationMask.portrait
        }
    }
}
