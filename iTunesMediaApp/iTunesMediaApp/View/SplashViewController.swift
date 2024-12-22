//
//  SplashViewController.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit
import Combine

class SplashViewController: UIViewController {
    private var viewModel: SplashViewModel
    private var cancellables: Set<AnyCancellable> = []
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        // Set background color
        self.view.backgroundColor = UIColor.systemBackground
        
        // Create the logo image view
        let configuration = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .medium)
        let logoImageView = UIImageView(image: UIImage(systemName: "applelogo", withConfiguration: configuration))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = UIColor.systemGreen
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoImageView)
        
        // Create the app name label
        let appNameLabel = UILabel()
        appNameLabel.text = "iTunes Media" // Replace with your app's name
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        appNameLabel.textColor = UIColor.label
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appNameLabel)
        
        // Add constraints for the logo
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Add constraints for the app name
        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            appNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            appNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        // Add an animation (e.g., fade-in with scale effect)
        logoImageView.alpha = 0
        appNameLabel.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            logoImageView.alpha = 1.0
            appNameLabel.alpha = 1.0
            logoImageView.transform = .identity
        }) { _ in
            self.viewModel.checkForRootStatus()
        }
    }
    
    
    private func bindViewModel() {
        viewModel.$isRooted
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] isRooted in
                guard let self = self else { return }
                if isRooted {
                    self.showRootDetectionAlert()
                } else {
                    self.navigateToMainScreen()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showRootDetectionAlert() {
        let alert = UIAlertController(
            title: "Security Alert",
            message: "This device appears to be rooted. For your security, the app cannot proceed.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = mainStoryboard.instantiateInitialViewController(),
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainVC
            window.makeKeyAndVisible()
        }
    }
}
