//
//  NotifyMeCell.swift
//  OnrampProject
//
//  Created by Ramon Geronimo on 3/5/20.
//

import UIKit

class NotifyMeCell: UITableViewCell {
    
    //MARK:- UI COMPONENTS
    let bookLabel = HeaderLabel(text: "Book", font: UIFont.boldSystemFont(ofSize: 16))
    let gameLabel = HeaderLabel(text: "Game", font: UIFont.boldSystemFont(ofSize: 16))
    
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
        let bookStackView = UIStackView(arrangedSubviews: [bookLabel, bookSegment])
        let gameStackView = UIStackView(arrangedSubviews: [gameLabel, gameSegment])
        let overrallStackView = VerticalStackView(arrangedSubviews: [
            bookStackView,
            gameStackView
        ])
        addSubview(overrallStackView)
        overrallStackView.fillSuperview()
        overrallStackView.spacing = 16
        overrallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        bookStackView.distribution = .fillEqually
        gameStackView.distribution = .fillEqually
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
