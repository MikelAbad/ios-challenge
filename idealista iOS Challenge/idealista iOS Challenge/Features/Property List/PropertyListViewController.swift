//
//  PropertyListViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 30/04/2025.
//

import UIKit
import SwiftUI

class PropertyListViewController: UIViewController {
    private let viewModel: PropertyListViewModel
    
    @IBOutlet weak var propertyListTableView: UITableView!
    
    init(viewModel: PropertyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PropertyListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        updateUI()
    }
}

extension PropertyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let property = viewModel.properties[indexPath.row]
        let hostingController = createPropertyCellController(for: property, at: indexPath.row)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            hostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectProperty(at: indexPath.row)
    }
}

private extension PropertyListViewController {
    
    func setupUI() {
        title = "property_list_title".localized()
    }
    
    func updateUI() {
        propertyListTableView.reloadData()
    }
    
    func configureTableView() {
        propertyListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PropertyCell")
        
        propertyListTableView.delegate = self
        propertyListTableView.dataSource = self
        propertyListTableView.separatorStyle = .none
        propertyListTableView.backgroundColor = .backgroundColor
        
        propertyListTableView.estimatedRowHeight = 100
        propertyListTableView.rowHeight = UITableView.automaticDimension
    }
    
    func createPropertyCellController(for property: Property, at index: Int) -> UIViewController {
        let propertyView = PropertyCellView(
            property: property
        )
        
        let hostingController = UIHostingController(rootView: propertyView)
        hostingController.view.backgroundColor = .backgroundColor
        
        return hostingController
    }
    
}
