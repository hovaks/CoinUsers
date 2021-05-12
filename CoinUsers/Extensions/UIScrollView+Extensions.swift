//
//  UIScrollView+Extensions.swift
//  CoinUsers
//
//  Created by Hovak Davtyan on 12.05.21.
//

import UIKit

extension UIScrollView {
	func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
		return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
	}
}
