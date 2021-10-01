//
//  ImageViewModification.swift
//  AllCountriesApp
//
//  Created by Дмитрий on 26.09.2021.
//

import UIKit

class SetFlagsImageShadow: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = false
    }
}

class SetViewShadow: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        clipsToBounds = false
    }
}
