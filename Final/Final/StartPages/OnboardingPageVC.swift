//
//  OnboardingPageVC.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import UIKit

enum AppStorageKeys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
}

final class OnboardingPageVC: UIPageViewController {
    
    private let dotsView = OnboardingDotsView(numberOfDots: 3)
    
    private lazy var pages: [UIViewController] = {
        let first = OnboardingFirstVC()
        let second = OnboardingSecondVC()
        
        first.nextButton.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
        second.onContinueTapped = { [weak self] in
            self?.goToAuth()
        }
        return [first, second]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
        
        setupDots()
        dotsView.setActiveDot(index: 1)
    }
    
    func goToAuth() {
        UserDefaults.standard.set(true, forKey: AppStorageKeys.hasSeenOnboarding)

        let authVC = ViewController()
        navigationController?.pushViewController(authVC, animated: true)
    }

    private func setupDots() {
        view.addSubview(dotsView)
        dotsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dotsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            dotsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func goToNextPage() {
        setViewControllers([pages[1]], direction: .forward, animated: true)
        dotsView.setActiveDot(index: 2)
    }
}

extension OnboardingPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = viewControllers?.first,
              let index = pages.firstIndex(of: currentVC)
        else { return }
        
        if index == 0 {
            dotsView.setActiveDot(index: 1)
        } else {
            dotsView.setActiveDot(index: 2)
        }
    }

}
