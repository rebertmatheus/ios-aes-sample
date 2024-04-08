//
//  UIView+Extensions.swift
//  AesWebViewSample
//
//  Created by Rebert Matheus Teixeira on 03/04/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
