//
//  ArtObjectDetailViewController.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//

import Foundation
import UIKit
import Kingfisher

class ArtObjectDetailViewController: UIViewController {
	lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 24)
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	lazy var authorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 18)
		label.numberOfLines = 1
		label.textAlignment = .center
		return label
	}()
	
	lazy var urlLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 16)
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = .blue
		label.isUserInteractionEnabled = true
		label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openURL)))
		return label
	}()
	
	private var viewModel: ArtObjectDetailViewModel
	
	init(viewModel: ArtObjectDetailViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		configureView()
	}
	
	private func setupViews() {
		view.backgroundColor = .white
		view.addSubview(imageView)
		view.addSubview(titleLabel)
		view.addSubview(authorLabel)
		view.addSubview(urlLabel)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
			
			titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			urlLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
			urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			urlLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
		])
	}
	
	private func configureView() {
		let artObject = viewModel.getArtObject()
		
		title = artObject.title
		
		guard let url = artObject.webImage?.url,
			  let imageUrl = URL(string: url) else {
			imageView.image = nil
			return
		}
		
		imageView.kf.setImage(
			with: imageUrl,
			placeholder: UIImage(
				named: "placeholder"
			)
		)
		
		titleLabel.text = "Title:\(artObject.title)"
		authorLabel.text = "Author: \(artObject.principalOrFirstMaker)"
		if let url = URL(string: artObject.links.web) {
			urlLabel.text = "Link: \(url)"
		}
	}
	
	@objc func openURL() {
		let urlString = viewModel.getArtObject().links.web
		guard let url = URL(string: urlString) else {
			return
		}
		UIApplication.shared.open(url)
	}
}
