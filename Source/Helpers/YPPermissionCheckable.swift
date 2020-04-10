//
//  PermissionCheckable.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 25/01/2018.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import UIKit
import AVFoundation

protocol YPPermissionCheckable {
    func checkPermission()
}

extension YPPermissionCheckable where Self: UIViewController {
    
    func checkPermission() {
        checkPermissionToAccessVideo { _ in }
    }
    
    func doAfterPermissionCheck(block:@escaping () -> Void) {
        checkPermissionToAccessVideo { hasPermission in
            if hasPermission {
                block()
            }
        }
    }
    
    // Async beacause will prompt permission if .notDetermined
    // and ask custom popup if denied.
    func checkPermissionToAccessVideo(block: @escaping (Bool) -> Void) {
        let bundle = Bundle(for: YPPickerVC.self)
        var deniedView: UIView?
        if let permissionDeniedView = UINib(nibName: "PermissionDeniedView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView {
            print("permissionDeniedView all good!")
            let bounds = UIScreen.main.bounds
            permissionDeniedView.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height - 150)
            deniedView = permissionDeniedView
            view.addSubview(permissionDeniedView)
        }
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            deniedView?.removeFromSuperview()
            block(true)
        case .restricted, .denied:
            let popup = YPPermissionDeniedPopup()
            let alert = popup.popup(cancelBlock: {
                block(false)
            })
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    if granted {
                        deniedView?.removeFromSuperview()
                    }
                    
                    block(granted)
                }
            })
        @unknown default:
            fatalError()
        }
    }
}
