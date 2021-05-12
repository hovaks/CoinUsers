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
		disposeBag = DisposeBag()
	}

	// MARK: - Injection

	var user: User! {
		didSet { configure(with: user) }
	}

	private func configure(with user: User) {
		avatarImageView.kf.setImage(with: user.avatar, placeholder: UIImage(systemName: "person.crop.circle"))
		nameLabel.text = user.fullName
		genderImageView.image = UIImage(named: user.genderSign)
		emailLabel.text = user.email
		phoneLabel.text = user.phone
		addressLabel.text = user.cellAddress

		doBindings()
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
