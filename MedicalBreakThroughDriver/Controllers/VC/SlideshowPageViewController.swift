//
//  SlideshowPageViewController.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 21/02/25.
//

import UIKit

class SlideshowPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var deliveryImages: [DeliveryImages] = []
    var selectedIndex: Int = 0
    private let pageCountLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setInitialViewController()
        setupBackButton()
        setupPageCountLabel()
        updatePageCount()
    }

    private func setInitialViewController() {
        guard !deliveryImages.isEmpty, selectedIndex < deliveryImages.count else { return }
        let initialVC = createPreviewController(for: selectedIndex)
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }

    private func createPreviewController(for index: Int) -> PreviewViewController {
        let previewVC = PreviewViewController()
        previewVC.deliveryImage = deliveryImages[index]
        previewVC.view.tag = index // Assign index to view tag for tracking
        return previewVC
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = getCurrentIndex(viewController: viewController), currentIndex > 0 else { return nil }
        return createPreviewController(for: currentIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = getCurrentIndex(viewController: viewController), currentIndex < deliveryImages.count - 1 else { return nil }
        return createPreviewController(for: currentIndex + 1)
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            updatePageCount()
        }
    }

    // MARK: - Helpers

    private func getCurrentIndex(viewController: UIViewController) -> Int? {
        return viewController.view.tag
    }

    private func updatePageCount() {
        if let currentVC = viewControllers?.first, let index = getCurrentIndex(viewController: currentVC) {
            pageCountLabel.text = "\(index + 1)/\(deliveryImages.count)"
        }
    }

    // MARK: - Back Button Setup
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("✕", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)

        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Page Count Label Setup
    private func setupPageCountLabel() {
        pageCountLabel.textColor = .white
        pageCountLabel.font = UIFont.boldSystemFont(ofSize: 18)
        pageCountLabel.textAlignment = .center
        pageCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pageCountLabel.layer.cornerRadius = 15
        pageCountLabel.clipsToBounds = true
        pageCountLabel.text = "1/\(deliveryImages.count)"

        view.addSubview(pageCountLabel)
        pageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pageCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageCountLabel.widthAnchor.constraint(equalToConstant: 60),
            pageCountLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
