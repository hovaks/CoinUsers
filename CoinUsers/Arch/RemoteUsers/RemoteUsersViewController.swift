//
//  RemoteUsersViewController.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 10.05.21.
//

import Reusable
import UIKit

import RxFlow
import RxSwift

// MARK: - RemoteUsersViewController

final class RemoteUsersViewController: BaseViewController {
	// MARK: - MVVM

	var viewModel: RemoteUsersViewModel!
	override var stepper: Stepper! { viewModel }

	// MARK: - Outlets

	@IBOutlet private var tableView: UITableView! {
		didSet { configureTableView() }
	}

	private func configureTableView() {
		tableView.separatorInset = .zero
		tableView.tableFooterView = UIView()
		tableView.register(cellType: UserTableViewCell.self)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureSearchController()
		doBindings()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		navigationItem.searchController?.isActive = false
		viewModel.refresh.accept(())
	}

	// MARK: - Search

	private var searchBar: UISearchBar? {
		navigationItem.searchController?.searchBar
	}

	private func configureSearchController() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.barTintColor = .main1
		searchController.searchBar.placeholder = "Search by name, email, phone, location"
		searchController.automaticallyShowsCancelButton = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.enablesReturnKeyAutomatically = true
		searchController.hidesNavigationBarDuringPresentation = false
		navigationItem.searchController = searchController
	}

	// MARK: - Reactive

	private func doBindings() {
		// SearchBar
		searchBar?.rx.text.orEmpty
			.bind(to: viewModel.search)
			.disposed(by: disposeBag)

		// TableView
		viewModel.users
			.bind(to: tableView.rx.items) { [viewModel] tv, row, model in
				let indexPath = IndexPath(row: row, section: 0)
				let cell: UserTableViewCell = tv.dequeueReusableCell(for: indexPath)
				cell.model = model
				cell.delegate = viewModel
				return cell
			}
			.disposed(by: disposeBag)

		Observable.zip(
			tableView.rx.modelSelected(UserTableViewCell.Model.self),
			tableView.rx.itemSelected
		)
		.do(onNext: { [weak self] _, indexPath in
			self?.searchBar?.endEditing(true)
			self?.tableView?.deselectRow(at: indexPath, animated: true)
		})
		.map { UserDetailsViewModel.Context(user: $0.0.user, isSaved: $0.0.isSaved) }
		.bind(to: viewModel.openUserDetails)
		.disposed(by: disposeBag)

		// LoadMore
		tableView.rx.contentOffset
			.flatMap { [weak self] _ -> Observable<Void> in
				guard let self = self else { return .empty() }
				return self.tableView.isNearBottomEdge() ? .just(()) : .empty()
			}
			.bind(to: viewModel.loadMore)
			.disposed(by: disposeBag)

		// Error
		viewModel.error.bind(to: error).disposed(by: disposeBag)
	}
}

extension RemoteUsersViewController: UIScrollViewDelegate {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		DispatchQueue.main.async { [weak self] in
			self?.navigationItem.searchController?.isActive = false
		}
	}
}
