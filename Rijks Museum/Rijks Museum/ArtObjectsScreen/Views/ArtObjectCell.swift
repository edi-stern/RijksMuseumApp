//
//  ArtObjectCell.swift
//  Rijks Museum
//
//  Created by Eduard Stern (Ideologiq) on 30.05.2024.
//
import UIKit
import Kingfisher

class ArtObjectCell: UICollectionViewCell {
	static let reuseIdentifier = "ArtObjectCell"
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .bold)
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	private func setupViews() {
		let stackView = UIStackView(
			arrangedSubviews: [
				imageView,
				titleLabel
			]
		)
		stackView.axis = .vertical
		stackView.spacing = 8
		
		contentView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 250)
		])
	}
	
	func configure(with artObject: ArtObject) {
		
		imageView.image = nil
		titleLabel.text = ""
		titleLabel.text = artObject.title
		
		guard let url = artObject.webImage?.url,
			  let imageUrl = URL(string: url) else {
			imageView.image = nil
			return
		}
		
		imageView.kf.setImage(
			with: imageUrl,
			placeholder: UIImage(named: "placeholder"),
			options: [
				.processor(DownsamplingImageProcessor(size: imageView.frame.size)),
				.cacheOriginalImage
			])
	}
}
