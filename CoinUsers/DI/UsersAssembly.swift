//
//  UsersAssembly.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Swinject
import SwinjectAutoregistration

final class UsersAssembly: Assembly {
	func assemble(container: Container) {
		// MARK: - Remote

		container.autoregister(RemoteUsersViewModel.self, initializer: RemoteUsersViewModel.init)
		container.register(RemoteUsersViewController.self) { r in
			let controller = RemoteUsersViewController.instantiate()
			controller.title = MainTab.remoteUsers.title
			controller.viewModel = r ~> RemoteUsersViewModel.self
			return controller
		}

		// MARK: - Local

		container.autoregister(LocalUsersViewModel.self, initializer: LocalUsersViewModel.init)
		container.register(LocalUsersViewController.self) { r in
			let controller = LocalUsersViewController.instantiate()
			controller.title = MainTab.localUsers.title
			controller.viewModel = r ~> LocalUsersViewModel.self
			return controller
		}
	}
}
