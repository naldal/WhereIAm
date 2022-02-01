//
//  UIViewUtils.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/02/01.
//

import UIKit

class UIViewUtils {
    
    static var shared = UIViewUtils()
    
    func safeAreaTopHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            guard let topPadding = topPadding else { return 0 }
            return topPadding
        }
    }
    
    func safeAreaBottomHeight() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let bottomPadding = window?.safeAreaInsets.bottom
            guard let bottomPadding = bottomPadding else { return 0 }
            return bottomPadding
        }
    }
}
