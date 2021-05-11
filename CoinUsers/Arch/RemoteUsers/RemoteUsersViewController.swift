//
//  RemoteUsersViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow

final class RemoteUsersViewController: BaseViewController {
	var viewModel: RemoteUsersViewModel!

	override var stepper: Stepper! { viewModel }

	override func viewDidLoad() {
		super.viewDidLoad()

		doBindings()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		viewModel.refresh.accept(())
	}

	private func doBindings() {
		viewModel.users.subscribe(onNext: { [weak self] users in
			print(users)
		})

		viewModel.error.bind(to: error).disposed(by: disposeBag)
	}
}
