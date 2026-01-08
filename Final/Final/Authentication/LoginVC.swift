//
//  LoginVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    private let usernameField = UITextField.makeGlassTextField("Enter your username")
    private let passwordField = UITextField.makeGlassTextField("Enter your password")
    
    private let stackViewForInputFields: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupFieldsStack() {
        view.addSubview(stackViewForInputFields)
        
    }
}
#Preview {
    LoginVC()
}
