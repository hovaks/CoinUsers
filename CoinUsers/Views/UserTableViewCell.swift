//
//  UserTableViewCell.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import Kingfisher
import Reusable
import UIKit

import RxGesture
import RxSwift

// MARK: - UserCellDelegate

protocol UserCellDelegate: AnyObject {
	func didTapActionButton(for model: UserTableViewCell.Model)
}

// MARK: - UserTableViewCell

final class UserTableViewCell: UITableViewCell, NibReusable {
	// MARK: - UserCellModel

	struct Model {
		let user: User
		let isSaved: Bool
		let search: String
	}

	// MARK: - Delegate

	weak var delegate: UserCellDelegate?

	// MARK: - Outlets

	@IBOutlet private var avatarImageView: UIImageView! {
		didSet { avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2 }
	}

	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var emailLabel: UILabel!
	@IBOutlet private var phoneLabel: UILabel!
	@IBOutlet private var addressLabel: UILabel!
	@IBOutlet private var genderImageView: UIImageView!
	@IBOutlet private var actionImageView: UIImageView!

	// MARK: - Reuse

	override func prepareForReuse() {
		super.prepareForReuse()

		avatarImageView.kf.cancelDownloadTask()
		avatarImageView.image = nil
		disposeBag = DisposeBag()
	}

	// MARK: - User

	var model: Model! {
		didSet { configure(with: model) }
	}

	private func configure(with model: Model) {
		let user = model.user
		avatarImageView.kf.setImage(with: user.avatar, placeholder: UIImage(systemName: "person.crop.circle"))
		nameLabel.text = user.fullName
		genderImageView.image = UIImage(named: user.genderSign)
		emailLabel.text = user.email
		phoneLabel.text = user.phone
		addressLabel.text = user.addressText
		actionImageView.image = model.isSaved ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")

		highlightSearch(for: model.search)

		doBindings()
	}

	// MARK: - Search

	private lazy var searchLabels = [nameLabel, emailLabel, phoneLabel, addressLabel]

	private func highlightSearch(for query: String) {
		searchLabels.forEach {
			guard let text = $0?.text else { return }
			$0?.attributedText = NSAttributedString(string: text)
		}

		guard
			let labelToHighlight = searchLabels.first(where: { $0?.text?.contains(query) ?? false }),
			let labelText = labelToHighlight?.text
		else { return }

		let attributedString = NSMutableAttributedString(string: labelText)
		let searchRange = (labelText.lowercased() as NSString).range(of: query.lowercased(), options: [.numeric])
		let highlightColor = UIColor.systemYellow.withAlphaComponent(0.5)
		attributedString.addAttribute(.backgroundColor, value: highlightColor, range: searchRange)
		labelToHighlight?.attributedText = attributedString
	}

	// MARK: - Reactive

	private var disposeBag = DisposeBag()

	private func doBindings() {
		actionImageView.rx.tapGesture().when(.recognized)
			.subscribe(onNext: { [weak self] _ in
				guard let self = self else { return }
				self.delegate?.didTapActionButton(for: self.model)
			})
			.disposed(by: disposeBag)
	}
}
