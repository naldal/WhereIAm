//
//  bottomSheet.swift
//  WhereIAm
//
//  Created by 송하민 on 2022/02/01.
//

// 인포가 말이 없다 죽었나보다 ㅠㅠ

import SnapKit
import UIKit

final class BottomSheet: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: APPLE_FONT_BOLD, size: 25)
        label.textColor = .black
        return label
    }()
    
    func setup(stationsName: [String]?) {
        var namesText = ""
        if let staionNames = stationsName {
            if staionNames.isEmpty {
                namesText = "현재 범위에 역이 없습니다."
            } else {
                namesText = "현재 \(staionNames.first!)역 입니다."
            }
        }
        stationNameLabel.text = namesText
        
        layoutLabels()
    }
    
    private func layoutLabels() {
        addSubview(stationNameLabel)
        stationNameLabel.snp.remakeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
