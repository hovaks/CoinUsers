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
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureSearchController()
		doBindings()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		viewModel.refresh.accept(())
	}

	// MARK: - Search

	private func configureSearchController() {
		let searchController = UISearchController(searchResultsController: nil)
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
		navigationItem.searchController?.searchBar.rx.text.orEmpty
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
