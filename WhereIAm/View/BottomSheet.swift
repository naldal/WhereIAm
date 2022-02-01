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
    
    var staionNames: [String]?
    
    lazy var nowYouAreAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: APPLE_FONT_BOLD, size: 22)
        label.tintColor = .black
        label.text = "현재 범위에"
        return label
    }()
    
    lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: APPLE_FONT_MEDIUM, size: 14)
        label.tintColor = .black
        return label
    }()
    
    func setup() {
        var namesText = ""
        if let staionNames = staionNames {
            if staionNames.count == 1 {
                namesText = "\(staionNames.first!)역 입니다."
            }
        } else {
            namesText = "아직 역에 도달하지 않았습니다"
        }
        stationNameLabel.text = namesText
        
        [nowYouAreAtLabel, stationNameLabel].forEach {
            addSubview($0)
        }
        
        layoutLabels()
    }
    
    private func layoutLabels() {
        [nowYouAreAtLabel, stationNameLabel].forEach {
            addSubview($0)
        }
        
        nowYouAreAtLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(50)
        }
        stationNameLabel.snp.makeConstraints {
            $0.top.equalTo(nowYouAreAtLabel).inset(40)
            $0.leading.equalTo(nowYouAreAtLabel)
        }
    }
}
