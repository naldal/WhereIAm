//
//  RefreshLocationButton.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/02/02.
//

import SnapKit
import UIKit

final class RefreshLocationButtonView: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setup() {
        backgroundColor = .white
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "refreshLocation")
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        self.layer.cornerRadius = self.frame.width/2
    }
    
    
    
}
