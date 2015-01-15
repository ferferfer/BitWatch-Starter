//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Fernando Garcia Corrochano on 15/1/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import WatchKit
import Foundation
import BitWatchKit

class InterfaceController: WKInterfaceController {
	@IBOutlet weak var priceLabel: WKInterfaceLabel!
	@IBOutlet weak var lastUpdatedLabel: WKInterfaceLabel!
	@IBOutlet weak var image: WKInterfaceImage!
	
	let tracker = Tracker()
	var updating = false
	
	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)
		updatePrice(tracker.cachedPrice())
		image.setHidden(true)
		updateDate(tracker.cachedDate())
	}
	override func willActivate() {//is like viewWillAppear
		// This method is called when watch view controller is about to be visible to
		super.willActivate()
		update()
	}
	
	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}
	
	@IBAction func refreshTapped() {
		update()
	}
	
	private func updatePrice(price: NSNumber) {
		priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
	}
	
	private func update() {
  // 1
		if !updating {
			updating = true
			// 2
			let originalPrice = tracker.cachedPrice()
			// 3
			tracker.requestPrice { (price, error) -> () in
				// 4
				if error == nil {
					self.updatePrice(price!)
					self.updateDate(NSDate())
					self.updateImage(originalPrice, newPrice: price!)
				}
				self.updating = false
			}
		}
	}
	
	private func updateDate(date: NSDate) {
		self.lastUpdatedLabel.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
	}
	
	private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
		if originalPrice.isEqualToNumber(newPrice) {
			// 1
			image.setHidden(true)
		} else {
			// 2
			if newPrice.doubleValue > originalPrice.doubleValue {
				image.setImageNamed("Up")
			} else {
				image.setImageNamed("Down")
			}
			image.setHidden(false)
		}
	}
	
}
