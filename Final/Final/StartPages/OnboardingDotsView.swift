import UIKit

final class OnboardingDotsView: UIStackView {

    private var dots: [UIView] = []
    private var widthConstraints: [NSLayoutConstraint] = []

    private let inactiveWidth: CGFloat = 10
    private let activeWidth: CGFloat = 24
    private let height: CGFloat = 10

    init(numberOfDots: Int) {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 8
        alignment = .center

        createDots(count: numberOfDots)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createDots(count: Int) {
        for _ in 0..<count {
            let dot = UIView()
            dot.backgroundColor = .systemGray4
            dot.layer.cornerRadius = height / 2
            dot.translatesAutoresizingMaskIntoConstraints = false

            let width = dot.widthAnchor.constraint(equalToConstant: inactiveWidth)
            width.isActive = true

            NSLayoutConstraint.activate([
                width,
                dot.heightAnchor.constraint(equalToConstant: height)
            ])

            dots.append(dot)
            widthConstraints.append(width)
            addArrangedSubview(dot)
        }
    }

    func setActiveDot(index: Int, animated: Bool = true) {
        for (i, dot) in dots.enumerated() {
            let isActive = i == index
            dot.backgroundColor = isActive ? .systemOrange : .systemGray4
            widthConstraints[i].constant = isActive ? activeWidth : inactiveWidth
        }

        guard animated else { return }

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.layoutIfNeeded()
            }
        )
    }
}
