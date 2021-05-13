//
//  UserDetailsViewModel.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import RxRelay
import RxSwift

// MARK: - UserDetailsViewModel

final class UserDetailsViewModel: BaseViewModel {
	// MARK: - Context

	struct Context {
		let user: User
		let isSaved: Bool
	}

	// MARK: - Inputs

	let actionTapped = PublishRelay<Void>()
	let delete = PublishRelay<User>()

	// MARK: - Outputs

	let user: BehaviorRelay<User>
	let action = PublishRelay<UserDetailRowView.Action>()
	let isSaved: BehaviorRelay<Bool>

	// MARK: - Services

	private let realmService: RealmServiceProtocol

	// MARK: - Init

	init(realmService: RealmServiceProtocol, context: Context) {
		self.realmService = realmService
		self.user = BehaviorRelay(value: context.user)
		self.isSaved = BehaviorRelay(value: context.isSaved)
		super.init()

		doBindings()
	}

	// MARK: - Reactive

	private func doBindings() {
		actionTapped
			.withLatestFrom(user)
			.withLatestFrom(isSaved) { ($0, $1) }
			.flatMap { [realmService] user, isSaved in
				isSaved ? realmService.delete(user: user) : realmService.save(user: user)
			}
			.withLatestFrom(isSaved).map { !$0 }
			.bind(to: isSaved)
			.disposed(by: disposeBag)
	}
}

// MARK: UserDetailRowViewDelegate

extension UserDetailsViewModel: UserDetailRowViewDelegate {
	func didSelectAction(_ action: UserDetailRowView.Action) {
		self.action.accept(action)
	}
}
