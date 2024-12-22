//
//  SelectMediaTypeViewController.swift
//  iTunesMediaApp
//
//  Created by balamuruganc on 21/12/24.
//
import UIKit

protocol SelectMediaTypeDelegate: AnyObject {
    func didSelectMediaTypes(_ mediaTypes: [MediaType])
}

class SelectMediaTypeViewController: UIViewController {

    var selectedMediaTypes: [MediaType] = [] // Pre-selected media types
    private let viewModel: MediaViewModel
    
    weak var delegate: SelectMediaTypeDelegate?

    private let mediaTypeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mediaTypeTableView.delegate = self
        mediaTypeTableView.dataSource = self
    }

    private func setupUI() {
        view.backgroundColor = .black
        mediaTypeTableView.backgroundColor = .black
        view.addSubview(mediaTypeTableView)

        // Register UITableViewCell class for the table view
        mediaTypeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaTypeCell")

        NSLayoutConstraint.activate([
            mediaTypeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaTypeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaTypeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaTypeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension SelectMediaTypeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MediaType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTypeCell", for: indexPath)
        let mediaType = MediaType.allCases[indexPath.row]
        cell.backgroundColor = .black
        // Setup the cell with media type name and checkmark if selected
        cell.textLabel?.text = mediaType.displayName
        cell.textLabel?.textColor = .white
        // Show checkmark if selected
        if selectedMediaTypes.contains(mediaType) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaType = MediaType.allCases[indexPath.row]
        
        // Toggle selection
        if let index = selectedMediaTypes.firstIndex(of: mediaType) {
            selectedMediaTypes.remove(at: index) // Deselect
        } else {
            selectedMediaTypes.append(mediaType) // Select
        }
        delegate?.didSelectMediaTypes(selectedMediaTypes)
        tableView.reloadRows(at: [indexPath], with: .automatic) // Reload the row for updated selection
    }
}
