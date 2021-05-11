//
//  AppStep.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import RxFlow

// MARK: - AppStep

enum AppStep: Step {
	case main
}

// MARK: - RemoteUsersStep

enum RemoteUsersStep: Step {
	case root
}

// MARK: - LocalUsersStep

enum LocalUsersStep: Step {
	case root
}

// MARK: - SettingsStep

enum SettingsStep: Step {
	case root
}
