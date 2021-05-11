//
//  MainTab.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 11.05.21.
//

import UIKit

enum MainTab: String, CaseIterable {
	case remoteUsers
	case localUsers
	case settings

	private var symbolName: String {
		switch self {
		case .remoteUsers: return "person.2"
		case .localUsers: return "heart"
		case .settings: return "square.grid.3x1.below.line.grid.1x2"
		}
	}

	var title: String {
		switch self {
		case .remoteUsers: return "Users"
		case .localUsers: return "Saved"
		case .settings: return "Settings"
		}
	}

	var image: UIImage? {
		UIImage(systemName: symbolName)
	}

	var selectedImage: UIImage? {
		switch self {
		case .localUsers, .remoteUsers:
			return UIImage(systemName: symbolName + ".fill")
		case .settings:
			return UIImage(systemName: "square.grid.3x1.fill.below.line.grid.1x2")
		}
	}
}
