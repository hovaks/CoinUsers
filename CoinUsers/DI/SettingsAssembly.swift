//
//  SettingsAssembly.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import Swinject
import SwinjectAutoregistration

final class SettingsAssembly: Assembly {
	func assemble(container: Container) {
		// MARK: - Settings

		container.autoregister(SettingsViewModel.self, initializer: SettingsViewModel.init)
		container.register(SettingsViewController.self) { r in
			let controller = SettingsViewController.instantiate()
			controller.title = MainTab.settings.title
			controller.viewModel = r ~> SettingsViewModel.self
			return controller
		}
	}
}
