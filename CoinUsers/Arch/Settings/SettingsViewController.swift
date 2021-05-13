//
//  SettingsViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow

final class SettingsViewController: BaseViewController {
	var viewModel: SettingsViewModel!

	override var stepper: Stepper! { viewModel }
}
