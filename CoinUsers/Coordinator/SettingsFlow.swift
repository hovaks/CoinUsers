//
//  SettingsFlow.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow
import Swinject
import UIKit

final class SettingsFlow: NavigationFlow {
	override var assemblies: [Assembly] { [SettingsAssembly()] }
	override func navigate(to step: Step) -> FlowContributors {
		guard let step = step as? SettingsStep else { return .none }

		switch step {
		case .root:
			return push(to: SettingsViewController.self)
		}
	}
}
