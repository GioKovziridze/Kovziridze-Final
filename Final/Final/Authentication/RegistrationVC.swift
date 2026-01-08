//
//  RegistrationVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

final class RegistrationVC: UIViewController {

    // MARK: - Data
    private let cities = ["Tbilisi", "Batumi", "Kutaisi", "Rustavi", "New York", "Tel-Aviv", "Milan", "Berlin", "Beijing", "Rio"]
    private let cityPicker = UIPickerView()
    private var selectedCity: String?

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usernameField = UITextField.makeGlassTextField("Enter your ysername")
    private let emailField = UITextField.makeGlassTextField("Enter Email")
    private let passwordField = UITextField.makeGlassTextField("Enter your password", secure: true)
    private let confirmPasswordField = UITextField.makeGlassTextField("Confirm Password", secure: true)
    
    private let cityField: UITextField = {
        let field = UITextField()
        field.placeholder = "City"
        field.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        field.layer.cornerRadius = 14
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 48).isActive = true

        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        field.leftViewMode = .always

        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = .secondaryLabel
        arrow.contentMode = .scaleAspectFit
        arrow.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        field.rightView = arrow
        field.rightViewMode = .always

        return field
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        button.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 16
        button.layer.shadowOffset = CGSize(width: 0, height: 8)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let stackViewForInputFields: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "By tapping “Register” you accept our terms and conditions"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    private let haveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an Account?"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let continueEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Email", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.systemGray.withAlphaComponent(0.25)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Google", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.orange.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupPicker()
        setupFieldsStack()
        setupRegisterButton()
        setupButtons()

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    // MARK: - Setup


    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupPicker() {
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityField.inputView = cityPicker
    }

    private func setupFieldsStack() {
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(stackViewForInputFields)

        stackViewForInputFields.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Username", field: usernameField)
        )

        stackViewForInputFields.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Email", field: emailField)
        )

        stackViewForInputFields.addArrangedSubview(
            UIStackView.makeLabeledField(title: "City", field: cityField)
        )

        stackViewForInputFields.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Password", field: passwordField)
        )

        stackViewForInputFields.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Confirm Password", field: confirmPasswordField)
        )

        stackViewForInputFields.addArrangedSubview(errorLabel)
        contentStack.setCustomSpacing(40, after: stackViewForInputFields)

        }
    

    private func setupRegisterButton() {
        contentStack.addArrangedSubview(registerButton)
        contentStack.addArrangedSubview(termsLabel)
        contentStack.addArrangedSubview(haveAccountLabel)

        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupButtons() {
        buttonsStack.addArrangedSubview(continueEmailButton)
        buttonsStack.addArrangedSubview(googleLoginButton)
        contentStack.addArrangedSubview(buttonsStack)

        NSLayoutConstraint.activate([
            continueEmailButton.heightAnchor.constraint(equalToConstant: 52),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

//    TODO: - setup proper keyboard handling (Notification Center)

    // MARK: - Validation

    
    @objc private func registerTapped() {
        errorLabel.isHidden = true
        
        do {
            try AuthValidator.validateRegistration(
                username: usernameField.text,
                email: emailField.text,
                city: cityField.text,
                password: passwordField.text,
                confirmPassword: confirmPasswordField.text
            )
            
            print("Registration valid")
            //API call
            
        } catch {
            showError(error.localizedDescription)
        }
    }


    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    // MARK: - Helpers

   
}

// MARK: - Picker

extension RegistrationVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        cities[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityField.text = cities[row]
        selectedCity = cities[row]
        cityField.resignFirstResponder()
    }
}

#Preview {
    RegistrationVC() 
}
