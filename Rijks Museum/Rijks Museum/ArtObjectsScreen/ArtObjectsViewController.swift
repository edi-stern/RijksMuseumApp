//
//  ArtObjectsViewController.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import UIKit
import Combine

class ArtObjectsViewController: UIViewController {
	private var collectionView: UICollectionView!
	private var loadingView: UIActivityIndicatorView!
	
	private var viewModel: ArtObjectsViewModel
	
	init(viewModel: ArtObjectsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private var cancellables = Set<AnyCancellable>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Epam - Rijks"
		setupCollectionView()
		setupLoadingView()
		bindViewModel()
		viewModel.fetchArtObjects()
	}

	// MARK: UI Setup
	
	private func setupCollectionView() {
		let layout = UICollectionViewFlowLayout()
		
		let padding: CGFloat = 16
		let itemWidth = view.bounds.width - (padding * 3)
		
		layout.itemSize = CGSize(width: itemWidth / 2, height: 300)
		layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		layout.minimumInteritemSpacing = padding
		layout.minimumLineSpacing = padding
		layout.headerReferenceSize = CGSize(width: view.frame.width, height: 30.0)
		
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(ArtObjectCell.self, forCellWithReuseIdentifier: ArtObjectCell.reuseIdentifier)
		collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
		view.addSubview(collectionView)
	}
	
	private func setupLoadingView() {
		loadingView = UIActivityIndicatorView(style: .large)
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(loadingView)
		
		NSLayoutConstraint.activate([
			loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
	   collectionView?.collectionViewLayout.invalidateLayout()
	}
	
	// MARK: - Binding ViewModel
	
	private func bindViewModel() {
		viewModel.$sectionedArtObjects
			.receive(on: DispatchQueue.main)
			.sink { [weak self] _ in
				self?.collectionView.reloadData()
			}
			.store(in: &cancellables)
		
		viewModel.$errorMessage
			.receive(on: DispatchQueue.main)
			.sink { [weak self] errorMessage in
				if let errorMessage = errorMessage {
					self?.showError(errorMessage)
				}
			}
			.store(in: &cancellables)
		
		viewModel.$isLoading
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isLoading in
				if isLoading {
					self?.loadingView.startAnimating()
				} else {
					self?.loadingView.stopAnimating()
				}
			}
			.store(in: &cancellables)
	}
	
	private func showError(_ message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

// MARK: UICollectionViewDataSource

extension ArtObjectsViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSections
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItemsInSection(section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtObjectCell.reuseIdentifier, for: indexPath) as? ArtObjectCell,
			  let artObject = viewModel.artObject(at: indexPath) else {
			return UICollectionViewCell()
		}
		cell.configure(with: artObject)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView else {
			fatalError("Invalid header view type")
		}
		headerView.titleLabel.text = viewModel.titleForSection(indexPath.section)
		return headerView
	}
	
}

// MARK: UICollectionViewDelegate

extension ArtObjectsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let selectedArtObject = viewModel.artObject(at: indexPath) else {
			return
		}

		let detailViewController = ArtObjectDetailViewController(
			viewModel: .init(
				artObject: selectedArtObject
			)
		)
		navigationController?.pushViewController(
			detailViewController,
			animated: true
		)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height

		if offsetY > contentHeight - 2 * scrollView.frame.height {
			if !viewModel.isLoading {
				viewModel.fetchArtObjects()
			}
		}
	}
}
