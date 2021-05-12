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
	func didTapSaveButton(user: User)
}

// MARK: - UserTableViewCell

final class UserTableViewCell: UITableViewCell, NibReusable {
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
	@IBOutlet private var heartImageView: UIImageView!

	// MARK: - Reuse

	override func prepareForReuse() {
		super.prepareForReuse()

		avatarImageView.kf.cancelDownloadTask()
		avatarImageView.image = nil
		disposeBag = DisposeBag()
	}

	// MARK: - User

	var user: User! {
		didSet { configure(with: user) }
	}

	private func configure(with user: User) {
		avatarImageView.kf.setImage(with: user.avatar, placeholder: UIImage(systemName: "person.crop.circle"))
		nameLabel.text = user.fullName
		genderImageView.image = UIImage(named: user.genderSign)
		emailLabel.text = user.email
		phoneLabel.text = user.phone
		addressLabel.text = user.addressText

		doBindings()
	}

	// MARK: - Search

	private lazy var searchLabels = [nameLabel, emailLabel, phoneLabel, addressLabel]

	var search: String? { didSet { highlightSearch() } }

	private func highlightSearch() {
		searchLabels.forEach {
			guard let text = $0?.text else { return }
			$0?.attributedText = NSAttributedString(string: text)
		}

		let search = self.search ?? ""

		guard
			let labelToHighlight = searchLabels.first(where: { $0?.text?.contains(search) ?? false }),
			let labelText = labelToHighlight?.text
		else { return }

		let attributedString = NSMutableAttributedString(string: labelText)
		let searchRange = (labelText.lowercased() as NSString).range(of: search.lowercased(), options: [.numeric])
		let highlightColor = UIColor.systemYellow.withAlphaComponent(0.5)
		attributedString.addAttribute(.backgroundColor, value: highlightColor, range: searchRange)
		labelToHighlight?.attributedText = attributedString
	}

	// MARK: - Reactive

	private var disposeBag = DisposeBag()

	private func doBindings() {
		heartImageView.rx.tapGesture().when(.recognized)
			.subscribe(onNext: { [weak self] _ in
				guard let self = self else { return }
				self.delegate?.didTapSaveButton(user: self.user)
			})
			.disposed(by: disposeBag)
	}
}
