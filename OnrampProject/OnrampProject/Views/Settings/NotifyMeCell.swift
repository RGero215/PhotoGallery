//
//  NotifyMeCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/5/20.
//

import UIKit

class NotifyMeCell: UITableViewCell {
    
    let bookSegment: UISegmentedControl = {
        let item = ["No", "Yes"]
        let segment = UISegmentedControl(items: item)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .black
        segment.tintColor = .white
        return segment
    }()
    
    let gameSegment: UISegmentedControl = {
        let item = ["No", "Yes"]
        let segment = UISegmentedControl(items: item)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .black
        segment.tintColor = .white
        return segment
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = VerticalStackView(arrangedSubviews: [bookSegment, gameSegment])
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
