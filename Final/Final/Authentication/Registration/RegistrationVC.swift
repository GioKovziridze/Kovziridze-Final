import UIKit

final class RegistrationVC: UIViewController {

    // MARK: - ViewModel
    private let viewModel: RegistrationViewModel

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Data
    private let cities = [
        "Tbilisi", "Batumi", "Kutaisi", "Rustavi",
        "New York", "Tel-Aviv", "Milan", "Berlin", "Beijing", "Rio",
        "Paris", "Amsterdam", "Madrid", 
    ]

    private let cityPicker = UIPickerView()

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let usernameField = UITextField.makeGlassTextField("Username")
    private let emailField = UITextField.makeGlassTextField("Email Address")
    private let passwordField = UITextField.makeGlassTextField("Password", secure: true)
    private let confirmPasswordField = UITextField.makeGlassTextField("Confirm Password", secure: true)

    private let cityField: UITextField = {
        let field = UITextField.makeGlassTextField("City")
        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = .secondaryLabel
        arrow.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
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
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.black, for: .normal)

        button.backgroundColor = UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 0.7)
        button.layer.cornerRadius = 28
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "By tapping “Register” you accept our terms and conditions"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let loginHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account? Login"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private var spinner = UIActivityIndicatorView(style: .medium)
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupScroll()
        setupPicker()
        setupUI()
        bindViewModel()

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    // MARK: - Setup

    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 20

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupPicker() {
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityField.inputView = cityPicker
    }

    private func setupUI() {
        contentStack.addArrangedSubview(titleLabel)
        contentStack.setCustomSpacing(32, after: titleLabel)

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Username", field: usernameField)
        )

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Email Address", field: emailField)
        )

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "City", field: cityField)
        )

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Password", field: passwordField)
        )

        contentStack.addArrangedSubview(
            UIStackView.makeLabeledField(title: "Confirm Password", field: confirmPasswordField)
        )

        contentStack.addArrangedSubview(errorLabel)
        contentStack.setCustomSpacing(32, after: errorLabel)

        contentStack.addArrangedSubview(registerButton)
        contentStack.addArrangedSubview(termsLabel)
        contentStack.addArrangedSubview(loginHintLabel)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            spinner.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions

    @objc private func registerTapped() {
        errorLabel.isHidden = true

        viewModel.register(
            username: usernameField.text,
            email: emailField.text,
            city: cityField.text,
            password: passwordField.text,
            confirmPassword: confirmPasswordField.text
        )
    }

    // MARK: - Bind

    private func bindViewModel() {
        viewModel.onError = { [weak self] message in
            self?.errorLabel.text = message
            self?.errorLabel.isHidden = false
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            self?.registerButton.isEnabled = !isLoading
            if isLoading {
                self?.spinner.startAnimating()
            } else {
                self?.spinner.stopAnimating()
            }
        }

        viewModel.onSuccess = { [weak self] userModel in
            guard let self = self else { return }
            let tabBar = TabBarController()
           
            self.navigationController?.setViewControllers([tabBar], animated: true)
            print("Registration success")
        }
    }
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
        cityField.resignFirstResponder()
    }
}

extension RegistrationVC: UITextFieldDelegate {
    
}

#Preview {
    RegistrationVC(viewModel: RegistrationViewModel())
}
