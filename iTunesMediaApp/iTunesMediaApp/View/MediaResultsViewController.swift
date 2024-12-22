//
//  MediaResultsViewController.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//
import UIKit
import Combine
class MediaResultsViewController: UIViewController {
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Grid Layout", "List Layout"])
        control.selectedSegmentIndex = 0
        
        // Set the background color
        control.backgroundColor = .lightGray
        control.selectedSegmentTintColor = .darkGray // Color for selected segment
        
        // Set text attributes for normal state
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        
        // Set text attributes for selected state
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        control.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MediaViewModel
    private let collectionView: UICollectionView
    private let tableView: UITableView
    
    var mediaItems: [MediaItem]  // Original mediaItems list
    var groupedMediaItems: [String: [MediaItem]] = [:]  // Grouped mediaItems by kind
    var sectionTitles: [String] = [] // Section titles for header (e.g., "Album", "Movie")
    private let noDataLabel = UILabel()
    init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
        self.mediaItems = self.viewModel.mediaItems
        print("ssdsd",mediaItems)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        groupMediaItems()
        setupNoDataLabel()
        checkForData()
    }
    
    private func groupMediaItems() {
        // Group media items by 'kind' (or another property like 'category')
        groupedMediaItems = Dictionary(grouping: mediaItems, by: { $0.kind ?? "" })
        sectionTitles = Array(groupedMediaItems.keys).sorted() // Sort keys alphabetically or as needed
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    // Check if there is data and show/hide the noDataLabel accordingly
    private func checkForData() {
        if sectionTitles.isEmpty {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    // Set up the "No data available" label
    private func setupNoDataLabel() {
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.text = "No data available"
        noDataLabel.textColor = .gray
        noDataLabel.textAlignment = .center
        view.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        noDataLabel.isHidden = true // Initially hidden
    }
    
    private func setupUI() {
        // Add segmented control to the view
        view.addSubview(segmentedControl)
        
        // Layout constraints for segmentedControl
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Setup the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        let itemsPerRow: CGFloat = 4
        let spacing: CGFloat = 5 // Space between items
        
        let totalSpacing = (itemsPerRow - 1) * spacing + layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (view.frame.width - totalSpacing) / itemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5) // Adjust height ratio as needed
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "MediaCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = false  // Initially show grid
        collectionView.backgroundColor = .black
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        // Setup the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MediaTableViewCell.self, forCellReuseIdentifier: "MediaCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true  // Initially hide table
        tableView.backgroundColor = .black
        
        // Add collectionView and tableView to the view
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        // Layout constraints for collectionView and tableView
        NSLayoutConstraint.activate([
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func segmentedControlChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView.isHidden = false
            tableView.isHidden = true
        } else {
            collectionView.isHidden = true
            tableView.isHidden = false
        }
        collectionView.reloadData()
        tableView.reloadData()
    }
}
extension MediaResultsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count // Number of sections based on the grouped media types
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let title = sectionTitles[section]
        return groupedMediaItems[title]?.count ?? 0 // Return the count of items for that kind
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = sectionTitles[indexPath.section]
        let mediaItem = groupedMediaItems[title]?[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        if let mediaItem = mediaItem {
            cell.configure(with: mediaItem)
        }
        return cell
    }
    
    // Header for sections
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        
        // Set the background color of the header view
        headerView.backgroundColor = .gray
        
        // Configure the label
        let label = UILabel()
        label.text = sectionTitles[indexPath.section]
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Optional: Adjust font size and weight
        
        // Add the label to the header view
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    // Header size for each section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Customize header height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected media item
        let title = sectionTitles[indexPath.section]
        guard let mediaItem = groupedMediaItems[title]?[indexPath.row] else { return }  // Replace with your actual data array
        
        // Create an instance of ImagePreviewViewController
        let imagePreviewVC = PreviewViewController(mediaItem: mediaItem)
        
        // Push to the navigation stack
        navigationController?.pushViewController(imagePreviewVC, animated: true)
    }
    
}

extension MediaResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = sectionTitles[section]
        return groupedMediaItems[title]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = sectionTitles[indexPath.section]
        let mediaItem = groupedMediaItems[title]?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! MediaTableViewCell
        if let mediaItem = mediaItem {
            cell.configure(with: mediaItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Adjust height to include padding (image + padding)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray // Set the background color for the header
        
        let titleLabel = UILabel()
        titleLabel.text = sectionTitles[section] // Set the section title
        titleLabel.textColor = .white // Set the text color
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16) // Optional: Set a bold font
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        // Add constraints to center the titleLabel within the headerView
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Adjust this value as needed
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = sectionTitles[indexPath.section]
        guard let mediaItem = groupedMediaItems[title]?[indexPath.row] else { return }  // Replace with your actual data array
        
        // Create an instance of ImagePreviewViewController
        let imagePreviewVC = PreviewViewController(mediaItem: mediaItem)
        
        // Push to the navigation stack
        navigationController?.pushViewController(imagePreviewVC, animated: true)
    }
    
}
