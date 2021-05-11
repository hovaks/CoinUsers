//
//  BaseViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow
import RxRelay

class BaseViewModel: Stepper {
	let steps = PublishRelay<Step>()
}
