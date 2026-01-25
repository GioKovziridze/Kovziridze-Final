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
final class SocialButton: UIButton {

    init(title: String, image: UIImage?) {
        super.init(frame: .zero)

        setTitle(" \(title)", for: .normal)
        setTitleColor(.label, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        setImage(image, for: .normal)
        tintColor = .label

        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor

        heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
