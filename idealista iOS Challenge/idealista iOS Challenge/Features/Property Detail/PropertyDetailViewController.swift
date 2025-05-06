//
//  PropertyDetailViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 06/05/2025.
//

import UIKit

class PropertyDetailViewController: UIViewController {
    private let viewModel: PropertyDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let priceLabel = UILabel()
    private let favoriteImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let showMoreButton = UIButton(type: .system)
    private var isFullDescriptionShown = false
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    init(viewModel: PropertyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

private extension PropertyDetailViewController {
    
    func setupUI() {
        view.backgroundColor = .backgroundColor
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .primaryColor
        view.addSubview(activityIndicator)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        priceLabel.textColor = .primaryTextColor
        priceLabel.textAlignment = .natural
        contentView.addSubview(priceLabel)
        
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.image = UIImage(systemName: "heart.fill")
        favoriteImageView.tintColor = .primaryColor
        favoriteImageView.contentMode = .scaleAspectFit
        contentView.addSubview(favoriteImageView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .primaryTextColor
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .justified
        contentView.addSubview(descriptionLabel)
        
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.setTitle("propertyDetail.showMore".localized(), for: .normal)
        showMoreButton.addTarget(self, action: #selector(toggleDescription), for: .touchUpInside)
        showMoreButton.tintColor = .accentColor
        contentView.addSubview(showMoreButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteImageView.leadingAnchor, constant: -16),
            
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 24),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 24),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            showMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            showMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            showMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    func loadData() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        
        Task {
            await viewModel.loadPropertyDetails()
            updateUI()
            activityIndicator.stopAnimating()
            scrollView.isHidden = false
        }
    }
    
    func updateUI() {
        priceLabel.text = viewModel.price
        descriptionLabel.text = viewModel.shortDescription
        showMoreButton.isHidden = viewModel.fullDescription == viewModel.shortDescription
        favoriteImageView.isHidden = !viewModel.isFavorite
    }
    
    @objc func toggleDescription() {
        isFullDescriptionShown.toggle()
        
        if isFullDescriptionShown {
            descriptionLabel.text = viewModel.fullDescription
            descriptionLabel.numberOfLines = 0
            showMoreButton.setTitle("propertyDetail.showLess".localized(), for: .normal)
        } else {
            descriptionLabel.text = viewModel.shortDescription
            descriptionLabel.numberOfLines = 3
            showMoreButton.setTitle("propertyDetail.showMore".localized(), for: .normal)
        }
    }
    
}
