//
//  YPAssetViewContainer.swift
//  YPImagePicker
//
//  Created by Sacha Durand Saint Omer on 15/11/2016.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import Foundation
import UIKit
import Stevia
import AVFoundation

/// The container for asset (video or image). It containts the YPGridView and YPAssetZoomableView.
class YPAssetViewContainer: UIView {
    public var zoomableView: YPAssetZoomableView?
    public let curtain = UIView()
    public let spinnerView = UIView()
    public let multipleSelectionButton = UIButton()
    public var onlySquare = YPConfig.library.onlySquare
    public var isShown = true
    
    private let spinner = UIActivityIndicatorView(style: .white)
    private var shouldCropToSquare = YPConfig.library.isSquareByDefault
    private var isMultipleSelection = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        
        for sv in subviews {
            if let cv = sv as? YPAssetZoomableView {
                zoomableView = cv
                zoomableView?.myDelegate = self
            }
        }
        
        let touchDownGR = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(handleTouchDown))
        touchDownGR.minimumPressDuration = 0
        touchDownGR.delegate = self
        addGestureRecognizer(touchDownGR)
        
        // TODO: Add tap gesture to play/pause. Add double tap gesture to square/unsquare
        
        sv(
            spinnerView.sv(
                spinner
            ),
            curtain
        )
        
        spinner.centerInContainer()
        spinnerView.fillContainer()
        curtain.fillContainer()
        
        spinner.startAnimating()
        spinnerView.backgroundColor = UIColor.ypLabel.withAlphaComponent(0.3)
        curtain.backgroundColor = UIColor.ypLabel.withAlphaComponent(0.7)
        curtain.alpha = 0
        
        // Multiple selection button
        sv(multipleSelectionButton)
        multipleSelectionButton.size(42)
        multipleSelectionButton-15-|
        multipleSelectionButton.setImage(YPConfig.icons.multipleSelectionOffIcon, for: .normal)
        multipleSelectionButton.Bottom == zoomableView!.Bottom - 15
        
    }
    
    // MARK: - Square button

    @objc public func squareCropButtonTapped() {
        if let zoomableView = zoomableView {
            let z = zoomableView.zoomScale
            shouldCropToSquare = (z >= 1 && z < zoomableView.squaredZoomScale)
        }
        zoomableView?.fitImage(shouldCropToSquare, animated: true)
    }
    
    
    public func refreshSquareCropButton() {
        let shouldFit = YPConfig.library.onlySquare ? true : shouldCropToSquare
        zoomableView?.fitImage(shouldFit)
    }
    
    // MARK: - Multiple selection

    /// Use this to update the multiple selection mode UI state for the YPAssetViewContainer
    public func setMultipleSelectionMode(on: Bool) {
        isMultipleSelection = on
        let image = on ? YPConfig.icons.multipleSelectionOnIcon : YPConfig.icons.multipleSelectionOffIcon
        multipleSelectionButton.setImage(image, for: .normal)
        refreshSquareCropButton()
    }
}

// MARK: - ZoomableViewDelegate
extension YPAssetViewContainer: YPAssetZoomableViewDelegate {
    public func ypAssetZoomableViewDidLayoutSubviews(_ zoomableView: YPAssetZoomableView) {
        // Update play imageView position - bringing the playImageView from the videoView to assetViewContainer,
        // but the controll for appearing it still in videoView.
        if zoomableView.videoView.playImageView.isDescendant(of: self) == false {
            self.addSubview(zoomableView.videoView.playImageView)
            zoomableView.videoView.playImageView.centerInContainer()
        }
    }
    
    public func ypAssetZoomableViewScrollViewDidZoom() {
    }
    
    public func ypAssetZoomableViewScrollViewDidEndZooming() {
    }
}

// MARK: - Gesture recognizer Delegate
extension YPAssetViewContainer: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
    
    @objc
    private func handleTouchDown(sender: UILongPressGestureRecognizer) {
    }
}
