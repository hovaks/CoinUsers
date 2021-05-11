//
//  BaseViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import RxFlow
import RxRelay
import RxSwift

class BaseViewModel: Stepper {
	let disposeBag = DisposeBag()
	let steps = PublishRelay<Step>()
	let error = PublishRelay<AlertableError>()

	// MARK: - Error Handler

	public func handle<T>(_ error: Error) -> Single<T> {
		guard let error = error as? AlertableError else { fatalError() }
		self.error.accept(error)
		return .never()
	}

	// MARK: - Deinit

	deinit {
		print("#############")
		print(String(describing: self), "deinited")
		print("#############")
	}
}
