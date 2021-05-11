//
//  FlowAssembly.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Swinject
import SwinjectAutoregistration

final class FlowAssembly: Assembly {
	func assemble(container: Container) {
		// MARK: - App

		container.register(AppFlow.self) { (_, assembler: Assembler) in
			AppFlow(parentAssembler: assembler)
		}

		// MARK: - Remote

		container.autoregister(
			RemoteUsersFlow.self,
			argument: Assembler.self,
			initializer: RemoteUsersFlow.init
		)

		// MARK: - Local

		container.autoregister(
			LocalUsersFlow.self,
			argument: Assembler.self,
			initializer: LocalUsersFlow.init
		)

		// MARK: - Settings

		container.autoregister(
			SettingsFlow.self,
			argument: Assembler.self,
			initializer: SettingsFlow.init
		)
	}
}
