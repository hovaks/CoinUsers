//
//  UserDetailsViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import Kingfisher
import MapKit
import MessageUI
import UIKit

import RxCocoa
import RxFlow
import RxSwift

// MARK: - UserDetailsViewController

final class UserDetailsViewController: BaseViewController {
	// MARK: - MVVM

	var viewModel: UserDetailsViewModel!
	override var stepper: Stepper! { viewModel }

	// MARK: - Outlets

	@IBOutlet var avatarImageView: UIImageView! {
		didSet {  avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2 }
	}
	@IBOutlet fileprivate var ageRow: UserDetailRowView!
	@IBOutlet fileprivate var genderRow: UserDetailRowView!
	@IBOutlet fileprivate var emailRow: UserDetailRowView! { didSet { emailRow.delegate = viewModel }}
	@IBOutlet fileprivate var phoneRow: UserDetailRowView! { didSet { phoneRow.delegate = viewModel }}
	@IBOutlet fileprivate var addressRow: UserDetailRowView!
	@IBOutlet fileprivate var mapView: MKMapView!

	lazy var actionButtonItem: UIBarButtonItem = {
		let barButtonItem = UIBarButtonItem()
		navigationItem.rightBarButtonItem = barButtonItem
		return barButtonItem
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		viewModel.user
			.bind(to: rx.user)
			.disposed(by: disposeBag)

		viewModel.isSaved
			.map { isSaved in isSaved ? .heartFill: .heart }
			.bind(to: actionButtonItem.rx.image)
			.disposed(by: disposeBag)

		actionButtonItem.rx.tap
			.bind(to: viewModel.actionTapped)
			.disposed(by: disposeBag)

		viewModel.action
			.withLatestFrom(viewModel.user) { ($0, $1) }
			.subscribe(onNext: { [weak self] action, user in
				switch action {
				case .phone: self?.callTo(phoneNumber: user.phone)
				case .email: self?.emailTo(email: user.email)
				}
			})
			.disposed(by: disposeBag)
	}

	func callTo(phoneNumber: String) {
		if !phoneNumber.isEmpty, let encoded = phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
			if let url = NSURL(string: "tel://" + encoded) {
				if UIApplication.shared.canOpenURL(url as URL) {
					UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
				}
			}
		}
	}

	func emailTo(email: String) {
		if MFMailComposeViewController.canSendMail() {
			let controller = MFMailComposeViewController()
			controller.mailComposeDelegate = self
			controller.setToRecipients([email])
			present(controller, animated: true)
		} else {
			fatalError()
		}
	}
}

// MARK: MFMailComposeViewControllerDelegate

extension UserDetailsViewController: MFMailComposeViewControllerDelegate {
	func mailComposeController(
		_ controller: MFMailComposeViewController,
		didFinishWith result: MFMailComposeResult,
		error: Error?
	) {
		if let error = error { fatalError(error.localizedDescription) }
		controller.dismiss(animated: true)
	}
}

private extension Reactive where Base: UserDetailsViewController {
	var user: Binder<User> {
		Binder(base) { vc, user in
			vc.title = user.fullName
			vc.avatarImageView.kf.setImage(with: user.avatar, placeholder: UIImage.person)
			vc.ageRow.value = String(user.age)
			vc.genderRow.value = user.genderText
			vc.emailRow.value = user.email
			vc.phoneRow.value = user.phone
			vc.addressRow.value = user.addressText
			configure(vc.mapView, with: user)
		}
	}

	private func configure(_ mapView: MKMapView, with user: User) {
		let coordinate = CLLocationCoordinate2D(latitude: user.address.latitude, longitude: user.address.longitude)
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
		let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
		mapView.setRegion(region, animated: false)
	}
}

