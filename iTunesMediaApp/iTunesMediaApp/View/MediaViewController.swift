//
//  MediaViewController.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//

import UIKit
import Combine

class MediaViewController: UIViewController {
    
    private var viewModel: MediaViewModel!
    // Injected MediaService (via a shared instance or manually)
    var mediaService: MediaServiceProtocol?
    private var cancellables = Set<AnyCancellable>()
    // UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "music.note"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for music, albums, movies, etc."
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter search term"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Media Type"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mediaTypeDropDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Media Type", for: .normal)
        button.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mediaTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let submitButton: LoaderButton = {
        let button = LoaderButton(type: .system)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var mediaTypeCollectionViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Inject mediaService if not already set
        if mediaService == nil {
            mediaService = ITunesService()
        }
        
        // Initialize viewModel
        self.viewModel = MediaViewModel(mediaService: mediaService!)
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(iconImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(searchTextField)
        view.addSubview(titleLabel)
        view.addSubview(mediaTypeDropDownButton)
        view.addSubview(mediaTypeCollectionView)
        view.addSubview(submitButton)
        
        mediaTypeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MediaTypeCell")
        mediaTypeCollectionView.delegate = self
        mediaTypeCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            searchTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            mediaTypeDropDownButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mediaTypeDropDownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaTypeDropDownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mediaTypeCollectionView.topAnchor.constraint(equalTo: mediaTypeDropDownButton.bottomAnchor, constant: 10),
            mediaTypeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaTypeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Submit Button Constraints
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Button Styling
        submitButton.layer.cornerRadius = 25
        submitButton.clipsToBounds = true
        
        mediaTypeCollectionViewHeightConstraint = mediaTypeCollectionView.heightAnchor.constraint(equalToConstant: 60)
        mediaTypeCollectionViewHeightConstraint?.isActive = true
        
        toggleViewVisibility()
    }
    
    @objc private func searchTextFieldChanged() {
        guard let text = searchTextField.text else { return }
        viewModel.term = text
    }
    
    @objc private func submitButtonTapped() {
        guard let searchText = searchTextField.text else { return }
        
        // Trigger validation
        viewModel.validateInput()
        
        // Proceed if there's no validation error
        if viewModel.validationError == nil  {
            submitButton.setLoading(true)
            viewModel.searchMedia(term: searchText) { [weak self] in
                guard let self = self else { return }
                self.submitButton.setLoading(false)
                let mediaResultsVC = MediaResultsViewController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(mediaResultsVC, animated: true)
            }
        }
    }
    
    @objc private func dropDownButtonTapped() {
        let selectMediaVC = SelectMediaTypeViewController(viewModel: viewModel)
        selectMediaVC.selectedMediaTypes = viewModel.selectedMediaTypes
        selectMediaVC.delegate = self
        self.navigationController?.pushViewController(selectMediaVC, animated: true)
    }
    
    private func bindViewModel() {
        // Bind validation error to alert
        viewModel.$validationError
            .sink { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(message: error)
                    
                }
            }
            .store(in: &cancellables)
        // Observe the error  from the view model
        viewModel.$error
            .sink { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorPopup(message: error.localizedDescription)
                    self.submitButton.setLoading(false)
                }
            }
            .store(in: &cancellables)
        // Bind searchTextField changes to viewModel.term
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.term, on: viewModel)
            .store(in: &cancellables)
        searchTextField.addTarget(self, action: #selector(searchTextFieldChanged), for: .editingChanged)
    }
    
    // Helper function to show alerts
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // Function to show the error popup
    private func showErrorPopup(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func toggleViewVisibility() {
        if viewModel.selectedMediaTypes.isEmpty {
            mediaTypeCollectionView.isHidden = true
            mediaTypeCollectionViewHeightConstraint?.constant = 0
        } else {
            mediaTypeCollectionView.isHidden = false
            mediaTypeCollectionViewHeightConstraint?.constant = 60
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        mediaTypeCollectionView.reloadData()
    }
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedMediaTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaTypeCell", for: indexPath)
        let mediaType = viewModel.selectedMediaTypes[indexPath.row]
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.text = mediaType.displayName
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0 // Allow multi-line text if needed
        label.textColor = .black
        
        // Adding padding to the label for spacing inside the cell
        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
        ])
        
        return cell
    }
}

extension MediaViewController: SelectMediaTypeDelegate {
    func didSelectMediaTypes(_ mediaTypes: [MediaType]) {
        viewModel.selectedMediaTypes = mediaTypes
        toggleViewVisibility()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MediaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dynamically adjust the cell size based on content
        let mediaType = viewModel.selectedMediaTypes[indexPath.row]
        let width = mediaType.displayName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 40 // Adding padding
        return CGSize(width: width, height: 40) // Adjust height as needed
    }
    
}
