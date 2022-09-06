//
//  MovieCell.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let reuseID = "MovieCell"
    let movieNameAndYearLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with movie: String) {
        movieNameAndYearLabel.text = movie
    }
    
    private func configure() {
        addSubview(movieNameAndYearLabel)
        
        movieNameAndYearLabel.textColor = .label
        movieNameAndYearLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        movieNameAndYearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameAndYearLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            movieNameAndYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            movieNameAndYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieNameAndYearLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
