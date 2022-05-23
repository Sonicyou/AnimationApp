//
//  SkeletonTableViewCell.swift
//  AnimationApp
//
//  Created by Artem Frolov on 23.05.2022.
//

import UIKit

class SkeletonTableViewCell: UITableViewCell {

    let label = UILabel()
    let image = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [image, label].forEach {
            contentView.addSubview($0)
            $0.isSkeletonable = true
        }

        self.isSkeletonable = true
        label.numberOfLines = 3

        setupLayout()
    }

    private func setupLayout() {
        image.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.width.equalTo(80)
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
        })

        label.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(image.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
