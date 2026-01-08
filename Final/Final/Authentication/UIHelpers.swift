//
//  UIHelpers.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

extension UIStackView {
    
    static func makeLabeledField(title: String, field: UITextField) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [label, field])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }
}

extension UITextField {
    static func makeGlassTextField(_ placeholder: String,secure: Bool = false) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.isSecureTextEntry = secure
        field.autocapitalizationType = .none
        
        field.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        field.layer.cornerRadius = 14
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        field.heightAnchor.constraint(equalToConstant: 48).isActive = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
}
