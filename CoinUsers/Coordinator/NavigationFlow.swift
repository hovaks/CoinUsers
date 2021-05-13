//
//  NavigationFlow.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Foundation
import RxFlow
import Swinject
import SwinjectAutoregistration
import UIKit

class NavigationFlow: Flow {
	var root: Presentable { self.rootViewController }
	private let rootViewController: UINavigationController
	private(set) var assembler: Assembler!
	var assemblies: [Assembly] { [] }

	private let parentAssembler: Assembler?

	convenience init(parentAssembler: Assembler) {
		self.init(rootController: .init(), parentAssembler: parentAssembler)
	}

	init(rootController: UINavigationController, parentAssembler: Assembler? = nil) {
		self.rootViewController = rootController
		self.parentAssembler = parentAssembler
		self.assembler = Assembler(self.assemblies, parent: parentAssembler)
	}

	func navigate(to step: Step) -> FlowContributors { .none }

	// MARK: - Push

	func push<C: BaseViewController>(to viewController: C.Type) -> FlowContributors {
		let viewController = self.assembler.resolver ~> viewController.self
		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.stepper))
	}

	func push<C: BaseViewController, Arg>(to viewController: C.Type, with argument: Arg) -> FlowContributors {
		let viewController = self.assembler.resolver ~> (viewController.self, argument: argument)
		self.rootViewController.pushViewController(viewController, animated: true)
		return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.stepper))
	}
}
