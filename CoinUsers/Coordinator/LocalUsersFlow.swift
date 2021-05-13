//
//  LocalUsersFlow.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow
import Swinject
import UIKit

final class LocalUsersFlow: NavigationFlow {
	override var assemblies: [Assembly] { [UsersAssembly()] }
	override func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? LocalUsersStep else { return .none }

		switch step {
		case .root:
			return push(to: LocalUsersViewController.self)
		case .details(let user):
			return push(to: UserDetailsViewController.self, with: user)
		}
	}
}
