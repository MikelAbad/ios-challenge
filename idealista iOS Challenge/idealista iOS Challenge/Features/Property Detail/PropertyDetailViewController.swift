//
//  PropertyDetailViewController.swift
//  idealista iOS Challenge
//
//  Created by Mikel Abad on 06/05/2025.
//

import UIKit
import MapKit

class PropertyDetailViewController: UIViewController {
    private let viewModel: PropertyDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let summaryContainerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let favoriteImageView = UIImageView()
    private let priceContainer = UIStackView()
    private let priceValueLabel = UILabel()
    private let priceSuffixLabel = UILabel()
    private let featuresContainer = UIStackView()
    private let roomsContainer = UIStackView()
    private let roomsIcon = UIImageView()
    private let roomsLabel = UILabel()
    private let bathroomsContainer = UIStackView()
    private let bathroomsIcon = UIImageView()
    private let bathroomsLabel = UILabel()
    private let sizeContainer = UIStackView()
    private let sizeIcon = UIImageView()
    private let sizeLabel = UILabel()
    private let shortDescriptionLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let showMoreButton = UIButton(type: .system)
    private var isFullDescriptionShown = false
    private let basicFeaturesContainer = UIView()
    private let basicFeaturesTitleLabel = UILabel()
    private let basicFeaturesStackView = UIStackView()
    private let buildingFeaturesContainer = UIView()
    private let buildingFeaturesTitleLabel = UILabel()
    private let buildingFeaturesStackView = UIStackView()
    private let energyCertificationContainer = UIView()
    private let energyCertificationTitleLabel = UILabel()
    private let energyCertificationStackView = UIStackView()
    
    private let mapContainer = UIView()
    private let mapTitleLabel = UILabel()
    private let mapView = MKMapView()
    private let locationAnnotation = MKPointAnnotation()
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(PropertyImageCell.self, forCellWithReuseIdentifier: PropertyImageCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let pageIndicatorContainer = UIView()
    private let pageIndicatorLabel = UILabel()
    private var currentPage = 0
    
    private let baseHeight: CGFloat = 200
    private let iPadMultiplier: CGFloat = 2
    private var mapHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? baseHeight * iPadMultiplier : baseHeight
    }
    
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
        setupContentViews()
        setupActivityIndicator()
        setupImagesCollection()
        setupSummaryView()
        setupFavoriteIcon()
        setupDescriptionLabel()
        setupShowMoreButton()
        setupBasicFeaturesSection()
        setupBuildingFeaturesSection()
        setupEnergyCertificationSection()
        setupMapSection()
        setupConstraints()
        setupAccessibilityIdentifiers()
    }
    
    func setupContentViews() {
        view.backgroundColor = .backgroundColor
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .primaryColor
        view.addSubview(activityIndicator)
    }
    
    func setupImagesCollection() {
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imagesCollectionView)
        
        setupPageIndicator()
    }
    
    func setupPageIndicator() {
        pageIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorContainer.backgroundColor = .navigationColor
        pageIndicatorContainer.layer.cornerRadius = 10
        pageIndicatorContainer.layer.masksToBounds = true
        contentView.addSubview(pageIndicatorContainer)
        
        pageIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        pageIndicatorLabel.adjustsFontForContentSizeCategory = true
        pageIndicatorLabel.textColor = .primaryTextColor
        pageIndicatorLabel.textAlignment = .center
        pageIndicatorContainer.addSubview(pageIndicatorLabel)
    }
    
    func setupSummaryView() {
        summaryContainerView.translatesAutoresizingMaskIntoConstraints = false
        summaryContainerView.backgroundColor = .backgroundColor
        contentView.addSubview(summaryContainerView)

        setupTitleLabel()
        setupSubtitleLabel()
        setupPriceContainer()
        setupFeaturesContainer()
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .primaryTextColor
        titleLabel.numberOfLines = 1
        summaryContainerView.addSubview(titleLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textColor = .primaryTextColor
        subtitleLabel.numberOfLines = 1
        summaryContainerView.addSubview(subtitleLabel)
    }
    
    func setupFavoriteIcon() {
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.image = UIImage(systemName: "heart.fill")
        favoriteImageView.tintColor = .primaryColor
        favoriteImageView.contentMode = .scaleAspectFit
        contentView.addSubview(favoriteImageView)
    }
    
    func setupPriceContainer() {
        priceContainer.translatesAutoresizingMaskIntoConstraints = false
        priceContainer.axis = .horizontal
        priceContainer.alignment = .firstBaseline
        priceContainer.spacing = 2
        summaryContainerView.addSubview(priceContainer)
        
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        priceValueLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        priceValueLabel.adjustsFontForContentSizeCategory = true
        priceValueLabel.textColor = .primaryTextColor
        priceContainer.addArrangedSubview(priceValueLabel)
        
        priceSuffixLabel.translatesAutoresizingMaskIntoConstraints = false
        priceSuffixLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        priceSuffixLabel.adjustsFontForContentSizeCategory = true
        priceSuffixLabel.textColor = .primaryTextColor
        priceContainer.addArrangedSubview(priceSuffixLabel)
    }
    
    func setupFeaturesContainer() {
        featuresContainer.translatesAutoresizingMaskIntoConstraints = false
        featuresContainer.axis = .horizontal
        featuresContainer.alignment = .firstBaseline
        featuresContainer.spacing = 16
        summaryContainerView.addSubview(featuresContainer)
        
        setupRoomContainer()
        setupBathroomContainer()
        setupSizeContainer()
        setupShortPropertyDescriptionLabel()
    }
    
    func setupRoomContainer() {
        roomsContainer.translatesAutoresizingMaskIntoConstraints = false
        roomsContainer.axis = .horizontal
        roomsContainer.spacing = 4
        featuresContainer.addArrangedSubview(roomsContainer)
        
        roomsIcon.translatesAutoresizingMaskIntoConstraints = false
        roomsIcon.image = UIImage(systemName: "bed.double")
        roomsIcon.contentMode = .scaleAspectFit
        roomsIcon.tintColor = .secondaryColor
        roomsContainer.addArrangedSubview(roomsIcon)
        
        roomsLabel.translatesAutoresizingMaskIntoConstraints = false
        roomsLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        roomsLabel.adjustsFontForContentSizeCategory = true
        roomsLabel.textColor = .secondaryTextColor
        roomsContainer.addArrangedSubview(roomsLabel)
    }
    
    func setupBathroomContainer() {
        bathroomsContainer.translatesAutoresizingMaskIntoConstraints = false
        bathroomsContainer.axis = .horizontal
        bathroomsContainer.spacing = 4
        featuresContainer.addArrangedSubview(bathroomsContainer)
        
        bathroomsIcon.translatesAutoresizingMaskIntoConstraints = false
        bathroomsIcon.image = UIImage(systemName: "shower")
        bathroomsIcon.contentMode = .scaleAspectFit
        bathroomsIcon.tintColor = .secondaryColor
        bathroomsContainer.addArrangedSubview(bathroomsIcon)
        
        bathroomsLabel.translatesAutoresizingMaskIntoConstraints = false
        bathroomsLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        bathroomsLabel.adjustsFontForContentSizeCategory = true
        bathroomsLabel.textColor = .secondaryTextColor
        bathroomsContainer.addArrangedSubview(bathroomsLabel)
    }
    
    func setupSizeContainer() {
        sizeContainer.translatesAutoresizingMaskIntoConstraints = false
        sizeContainer.axis = .horizontal
        sizeContainer.spacing = 4
        featuresContainer.addArrangedSubview(sizeContainer)
        
        sizeIcon.translatesAutoresizingMaskIntoConstraints = false
        sizeIcon.image = UIImage(systemName: "ruler")
        sizeIcon.contentMode = .scaleAspectFit
        sizeIcon.tintColor = .secondaryColor
        sizeContainer.addArrangedSubview(sizeIcon)
        
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        sizeLabel.adjustsFontForContentSizeCategory = true
        sizeLabel.textColor = .secondaryTextColor
        sizeContainer.addArrangedSubview(sizeLabel)
    }
    
    func setupShortPropertyDescriptionLabel() {
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        shortDescriptionLabel.adjustsFontForContentSizeCategory = true
        shortDescriptionLabel.textColor = .secondaryTextColor
        shortDescriptionLabel.numberOfLines = 1
        featuresContainer.addArrangedSubview(shortDescriptionLabel)
    }
    
    func setupDescriptionLabel() {
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        descriptionTitleLabel.adjustsFontForContentSizeCategory = true
        descriptionTitleLabel.textColor = .primaryTextColor
        descriptionTitleLabel.numberOfLines = 1
        contentView.addSubview(descriptionTitleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .primaryTextColor
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .justified
        contentView.addSubview(descriptionLabel)
    }
    
    func setupShowMoreButton() {
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreButton.setTitle("propertyDetail.showMore".localized(), for: .normal)
        showMoreButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        showMoreButton.titleLabel?.adjustsFontForContentSizeCategory = true
        showMoreButton.addTarget(self, action: #selector(toggleDescription), for: .touchUpInside)
        showMoreButton.tintColor = .accentColor
        contentView.addSubview(showMoreButton)
    }
    
    func setupBasicFeaturesSection() {
        basicFeaturesContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(basicFeaturesContainer)
        
        basicFeaturesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        basicFeaturesTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        basicFeaturesTitleLabel.adjustsFontForContentSizeCategory = true
        basicFeaturesTitleLabel.textColor = .primaryTextColor
        basicFeaturesTitleLabel.text = "propertyDetail.basicFeatures".localized()
        basicFeaturesContainer.addSubview(basicFeaturesTitleLabel)
        
        basicFeaturesStackView.translatesAutoresizingMaskIntoConstraints = false
        basicFeaturesStackView.axis = .vertical
        basicFeaturesStackView.spacing = 8
        basicFeaturesStackView.alignment = .leading
        basicFeaturesContainer.addSubview(basicFeaturesStackView)
    }
    
    func setupBuildingFeaturesSection() {
        buildingFeaturesContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buildingFeaturesContainer)
        
        buildingFeaturesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buildingFeaturesTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        buildingFeaturesTitleLabel.adjustsFontForContentSizeCategory = true
        buildingFeaturesTitleLabel.textColor = .primaryTextColor
        buildingFeaturesTitleLabel.text = "propertyDetail.buildingFeatures".localized()
        buildingFeaturesContainer.addSubview(buildingFeaturesTitleLabel)
        
        buildingFeaturesStackView.translatesAutoresizingMaskIntoConstraints = false
        buildingFeaturesStackView.axis = .vertical
        buildingFeaturesStackView.spacing = 8
        buildingFeaturesStackView.alignment = .leading
        buildingFeaturesContainer.addSubview(buildingFeaturesStackView)
    }
    
    func setupEnergyCertificationSection() {
        energyCertificationContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(energyCertificationContainer)
        
        energyCertificationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        energyCertificationTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        energyCertificationTitleLabel.adjustsFontForContentSizeCategory = true
        energyCertificationTitleLabel.textColor = .primaryTextColor
        energyCertificationTitleLabel.text = viewModel.energyCertificateTitle
        energyCertificationContainer.addSubview(energyCertificationTitleLabel)
        
        energyCertificationStackView.translatesAutoresizingMaskIntoConstraints = false
        energyCertificationStackView.axis = .vertical
        energyCertificationStackView.spacing = 8
        energyCertificationStackView.alignment = .leading
        energyCertificationContainer.addSubview(energyCertificationStackView)
    }
    
    func setupConstraints() {
        [roomsIcon, bathroomsIcon, sizeIcon].forEach { icon in
            icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        }
        
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
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalTo: imagesCollectionView.widthAnchor, multiplier: 0.75),
            
            pageIndicatorContainer.trailingAnchor.constraint(equalTo: imagesCollectionView.trailingAnchor, constant: -16),
            pageIndicatorContainer.bottomAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: -16),
            
            pageIndicatorLabel.topAnchor.constraint(equalTo: pageIndicatorContainer.topAnchor, constant: 4),
            pageIndicatorLabel.leadingAnchor.constraint(equalTo: pageIndicatorContainer.leadingAnchor, constant: 8),
            pageIndicatorLabel.trailingAnchor.constraint(equalTo: pageIndicatorContainer.trailingAnchor, constant: -8),
            pageIndicatorLabel.bottomAnchor.constraint(equalTo: pageIndicatorContainer.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            summaryContainerView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor),
            summaryContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            summaryContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: summaryContainerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryContainerView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryContainerView.trailingAnchor, constant: -16),
            
            priceContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            priceContainer.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 16),
            priceContainer.trailingAnchor.constraint(lessThanOrEqualTo: summaryContainerView.trailingAnchor, constant: -16),
            
            favoriteImageView.topAnchor.constraint(equalTo: summaryContainerView.topAnchor, constant: 12),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 24),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 24),
            
            featuresContainer.topAnchor.constraint(equalTo: priceContainer.bottomAnchor, constant: 4),
            featuresContainer.leadingAnchor.constraint(equalTo: summaryContainerView.leadingAnchor, constant: 16),
            featuresContainer.trailingAnchor.constraint(lessThanOrEqualTo: summaryContainerView.trailingAnchor, constant: -16),
            featuresContainer.bottomAnchor.constraint(equalTo: summaryContainerView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            basicFeaturesContainer.topAnchor.constraint(equalTo: summaryContainerView.bottomAnchor, constant: 12),
            basicFeaturesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicFeaturesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            basicFeaturesTitleLabel.topAnchor.constraint(equalTo: basicFeaturesContainer.topAnchor),
            basicFeaturesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            basicFeaturesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            basicFeaturesStackView.topAnchor.constraint(equalTo: basicFeaturesTitleLabel.bottomAnchor, constant: 12),
            basicFeaturesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            basicFeaturesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            basicFeaturesStackView.bottomAnchor.constraint(equalTo: basicFeaturesContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buildingFeaturesContainer.topAnchor.constraint(equalTo: basicFeaturesContainer.bottomAnchor, constant: 24),
            buildingFeaturesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buildingFeaturesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buildingFeaturesTitleLabel.topAnchor.constraint(equalTo: buildingFeaturesContainer.topAnchor),
            buildingFeaturesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buildingFeaturesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            buildingFeaturesStackView.topAnchor.constraint(equalTo: buildingFeaturesTitleLabel.bottomAnchor, constant: 12),
            buildingFeaturesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buildingFeaturesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buildingFeaturesStackView.bottomAnchor.constraint(equalTo: buildingFeaturesContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            energyCertificationContainer.topAnchor.constraint(equalTo: buildingFeaturesContainer.bottomAnchor, constant: 24),
            energyCertificationContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            energyCertificationContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            energyCertificationTitleLabel.topAnchor.constraint(equalTo: energyCertificationContainer.topAnchor),
            energyCertificationTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            energyCertificationTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            energyCertificationStackView.topAnchor.constraint(equalTo: energyCertificationTitleLabel.bottomAnchor, constant: 12),
            energyCertificationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            energyCertificationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            energyCertificationStackView.bottomAnchor.constraint(equalTo: energyCertificationContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: energyCertificationContainer.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            showMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            showMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            mapContainer.topAnchor.constraint(equalTo: showMoreButton.bottomAnchor, constant: 24),
            mapContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            mapTitleLabel.topAnchor.constraint(equalTo: mapContainer.topAnchor),
            mapTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mapView.topAnchor.constraint(equalTo: mapTitleLabel.bottomAnchor, constant: 12),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: mapHeight),
            mapView.bottomAnchor.constraint(equalTo: mapContainer.bottomAnchor)
        ])
    }
    
    func setupAccessibilityIdentifiers() {
        view.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.mainView
        
        imagesCollectionView.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.imagesCollection
        pageIndicatorLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.pageIndicator
        
        titleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.titleLabel
        subtitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.subtitleLabel
        priceValueLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.priceLabel
        favoriteImageView.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.favoriteIcon
        
        roomsLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.roomsLabel
        bathroomsLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.bathroomsLabel
        sizeLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.sizeLabel
        shortDescriptionLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.shortDescriptionLabel
        
        descriptionLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.descriptionLabel
        showMoreButton.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.showMoreButton
        
        basicFeaturesTitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.basicFeaturesTitle
        buildingFeaturesTitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.buildingFeaturesTitle
        energyCertificationTitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.energyCertificationTitle
        
        mapTitleLabel.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.mapTitle
        mapView.accessibilityIdentifier = AccessibilityIdentifiers.PropertyDetail.mapView
    }
    
    func loadData() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
        
        Task {
            await viewModel.loadPropertyDetails()
            await MainActor.run {
                updateUI()
                activityIndicator.stopAnimating()
                scrollView.isHidden = false
            }
        }
    }
    
    func updateUI() {
        imagesCollectionView.reloadData()
        updatePageIndicator()
        
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        favoriteImageView.isHidden = !viewModel.isFavorite
        priceValueLabel.text = viewModel.price
        priceSuffixLabel.text = viewModel.currencySuffix
        
        roomsLabel.text = viewModel.rooms
        bathroomsLabel.text = viewModel.bathrooms
        sizeLabel.text = viewModel.size
        shortDescriptionLabel.text = viewModel.shortPropertyDescription
        
        updateFeaturesUI()
        
        descriptionTitleLabel.text = viewModel.descriptionTitle
        descriptionLabel.text = viewModel.shortDescription
        showMoreButton.isHidden = viewModel.fullDescription == viewModel.shortDescription
        
        updateMapView()
    }
    
    func updateFeaturesUI() {
        basicFeaturesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buildingFeaturesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for feature in viewModel.basicFeatures {
            let featureItem = createFeatureItem(text: feature)
            basicFeaturesStackView.addArrangedSubview(featureItem)
        }
        
        for feature in viewModel.buildingFeatures {
            let featureItem = createFeatureItem(text: feature)
            buildingFeaturesStackView.addArrangedSubview(featureItem)
        }
        
        for feature in viewModel.energyCertificationItems {
            let featureItem = createFeatureItem(text: feature)
            energyCertificationStackView.addArrangedSubview(featureItem)
        }
    }
    
    func updatePageIndicator() {
        let pageWidth = imagesCollectionView.frame.width
        currentPage = Int(imagesCollectionView.contentOffset.x / pageWidth) + 1
        
        if viewModel.imagesCount > 0 {
            pageIndicatorLabel.text = "\(currentPage)/\(viewModel.imagesCount)"
            pageIndicatorContainer.isHidden = false
        } else {
            pageIndicatorContainer.isHidden = true
        }
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

private extension PropertyDetailViewController {
    
    func setupMapSection() {
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapContainer)
        
        mapTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mapTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        mapTitleLabel.adjustsFontForContentSizeCategory = true
        mapTitleLabel.textColor = .primaryTextColor
        mapTitleLabel.text = "propertyDetail.location".localized()
        mapContainer.addSubview(mapTitleLabel)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 8
        mapView.clipsToBounds = true
        mapView.showsUserLocation = false
        mapContainer.addSubview(mapView)
    }
    
    func updateMapView() {
        guard let details = viewModel.propertyDetails else { return }
        
        let latitude = details.ubication.latitude
        let longitude = details.ubication.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        locationAnnotation.coordinate = coordinate
        locationAnnotation.title = viewModel.title
        locationAnnotation.subtitle = viewModel.subtitle
        
        mapView.addAnnotation(locationAnnotation)
        
        let regionRadius: CLLocationDistance = 500
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: false)
    }
    
}

extension PropertyDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyImageCell.reuseIdentifier, for: indexPath) as? PropertyImageCell else {
            return UICollectionViewCell()
        }
        
        let imageURL = viewModel.imageURL(at: indexPath.item)
        let accessibilityLabel = viewModel.imageAccessibilityLabel(at: indexPath.item)
        
        cell.configure(with: imageURL, accessibilityLabel: accessibilityLabel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imagesCollectionView {
            updatePageIndicator()
        }
    }
}

private extension PropertyDetailViewController {
    
    func createFeatureItem(text: String) -> UIStackView {
        let itemStack = UIStackView()
        itemStack.axis = .horizontal
        itemStack.spacing = 8
        itemStack.alignment = .center
        
        let bulletView = UIView()
        bulletView.translatesAutoresizingMaskIntoConstraints = false
        bulletView.backgroundColor = .secondaryColor
        bulletView.layer.cornerRadius = 3
        
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .body)
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textColor = .primaryTextColor
        textLabel.text = text
        textLabel.numberOfLines = 1
        
        itemStack.addArrangedSubview(bulletView)
        itemStack.addArrangedSubview(textLabel)
        
        NSLayoutConstraint.activate([
            bulletView.widthAnchor.constraint(equalToConstant: 6),
            bulletView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        return itemStack
    }
    
}
