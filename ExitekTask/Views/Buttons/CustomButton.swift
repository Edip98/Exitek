//
//  CustomButton.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        setTitle("Add", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
    }
}
