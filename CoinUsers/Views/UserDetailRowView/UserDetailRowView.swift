//
//  UserDetailRowView.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import Reusable
import UIKit

// MARK: - UserDetailRowViewDelegate

protocol UserDetailRowViewDelegate: AnyObject {
	func didSelectAction(_ action: UserDetailRowView.Action)
}

// MARK: - UserDetailRowView

final class UserDetailRowView: UIView, NibOwnerLoadable {
	// MARK: - Action

	enum Action: String {
		case email
		case phone = "phone number"
	}

	private var action: Action? {
		didSet {
			switch action {
			case .email?:
				actionButton.setImage(.arrow, for: .normal)
				actionButton.isHidden = false
			case .phone?:
				actionButton.setImage(.phone, for: .normal)
				actionButton.isHidden = false
			case .none:
				actionButton.isHidden = true
			}
		}
	}

	// MARK: - Init

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadNibContent()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		loadNibContent()
	}

	// MARK: - Outlets

	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var actionButton: UIButton!

	// MARK: - Inspectables

	@IBInspectable var title: String! {
		didSet {
			titleLabel.text = title + ":"
			action = Action(rawValue: title.lowercased())
		}
	}

	var value: String {
		get { valueLabel.text ?? "" }
		set { valueLabel.text = newValue }
	}

	// MARK: - Delegate

	weak var delegate: UserDetailRowViewDelegate?

	@IBAction private func actionTapped(_ sender: UIButton) {
		if let action = action {
			delegate?.didSelectAction(action)
		}
	}
}
