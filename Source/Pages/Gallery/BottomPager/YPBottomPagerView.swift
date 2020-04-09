//
//  YPBottomPagerView.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 24/01/2018.
//  Copyright © 2016 Yummypets. All rights reserved.
//

import UIKit
import Stevia

final class YPBottomPagerView: UIView {
    
    var header = YPPagerMenu()
    var scrollView = UIScrollView()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .offWhiteOrBlack
        
        sv(
            scrollView,
            header
        )
        
        layout(
            0,
            |scrollView|,
            0,
            |header| ~ 44
        )
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom {
                header.bottom(bottomPadding > 0 ? 26 : 0)
            } else {
                header.bottom(0)
            }
        } else {
            header.bottom(0)
        }
        
        header.heightConstraint?.constant = YPConfig.hidesBottomBar ? 0 : 44
        
        clipsToBounds = false
        setupScrollView()
    }

    private func setupScrollView() {
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
    }
}
