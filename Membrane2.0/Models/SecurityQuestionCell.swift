//
//  SecurityQuestionCell.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 10.10.2024.
//

import UIKit

class SecurityQuestionCell: UITableViewCell{
    
    private lazy var newsTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .fontWithSize(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textColor
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .buttonColor
        addSubview(newsTitle)
        NSLayoutConstraint.activate([
            newsTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.5),
            newsTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.5),
            newsTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            newsTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            //newsTitle.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(text: String){
        newsTitle.text = text
    }
}
