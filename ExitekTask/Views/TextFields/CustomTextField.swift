//
//  CustomTextField.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit

class CustomTextField: UITextField {
    
    let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        leftView = paddingView
        leftViewMode = .always
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        backgroundColor = .tertiarySystemBackground
        
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 18)
        autocorrectionType = .no
    }
    
    func set(tag: Int, returnKeyType: UIReturnKeyType) {
        self.returnKeyType = returnKeyType
        self.tag = tag
    }
}


