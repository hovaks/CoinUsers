//
//  BaseViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Reusable
import UIKit

import RxFlow
import RxRelay
import RxSwift

class BaseViewController: UIViewController, StoryboardBased {
	let disposeBag = DisposeBag()
	var stepper: Stepper! { nil }
	let error = PublishRelay<AlertableError>()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		error
			.subscribe(onNext: { [weak self] in self?.showErrorAlert($0) })
			.disposed(by: disposeBag)
	}

	// MARK: - Alerts

	private func showErrorAlert(_ error: AlertableError) {
		let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
		alert.addAction(.init(title: "Ok", style: .default))
		present(alert, animated: true)
	}

	// MARK: - Deinit

	deinit {
		print("#############")
		print(String(describing: self), "deinited")
		print("#############")
	}
}
