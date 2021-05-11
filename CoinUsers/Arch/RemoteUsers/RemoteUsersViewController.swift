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
}
