//
//  LocalUsersViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow

final class LocalUsersViewController: BaseViewController {
	var viewModel: LocalUsersViewModel!

	override var stepper: Stepper! { viewModel }
}
