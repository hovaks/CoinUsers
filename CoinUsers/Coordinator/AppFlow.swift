//
//  AppFlow.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Swinject
import SwinjectAutoregistration

import RxFlow
import RxRelay

import UIKit

// MARK: - AppFlow

final class AppFlow: Flow {
	var root: Presentable { rootViewController }

	private let rootViewController: UITabBarController = {
		let tabBarController = UITabBarController()
		tabBarController.tabBar.tintColor = .main1
		return tabBarController
	}()

	private var parentAssembler: Assembler

	init(parentAssembler: Assembler) {
		self.parentAssembler = parentAssembler
	}

	func navigate(to step: Step) -> FlowContributors {
		guard (step as? AppStep) == .main else { return .none }
		return initFlows(for: MainTab.allCases)
	}

	private func initFlows(for tabs: [MainTab]) -> FlowContributors {
		let flowConfigs = tabs.map { [weak self] in self?.config(for: $0) }
		let flows = flowConfigs.compactMap { $0?.0 }
		let flowContributors = flowConfigs.compactMap { $0?.1 }

		Flows.use(flows, when: .created) { vcs in
			tabs.enumerated().forEach { index, tab in
				let item = UITabBarItem(title: tab.title, image: tab.image, selectedImage: tab.selectedImage)
				vcs[index].tabBarItem = item
			}
			self.rootViewController.setViewControllers(vcs, animated: false)
		}

		return .multiple(flowContributors: flowContributors)
	}

	private func config(for tab: MainTab) -> (Flow, FlowContributor) {
		let flow: Flow
		let stepper: Stepper

		switch tab {
		case .remoteUsers:
			flow = parentAssembler.resolver ~> (RemoteUsersFlow.self, argument: parentAssembler)
			stepper = OneStepper(withSingleStep: RemoteUsersStep.root)
		case .localUsers:
			flow = parentAssembler.resolver ~> (LocalUsersFlow.self, argument: parentAssembler)
			stepper = OneStepper(withSingleStep: LocalUsersStep.root)
		case .settings:
			flow = parentAssembler.resolver ~> (SettingsFlow.self, argument: parentAssembler)
			stepper = OneStepper(withSingleStep: SettingsStep.root)
		}

		return (flow, .contribute(withNextPresentable: flow, withNextStepper: stepper))
	}
}

// MARK: - AppStepper

final class AppStepper: Stepper {
	let steps = PublishRelay<Step>()

	func readyToEmitSteps() {
		steps.accept(AppStep.main)
	}
}
