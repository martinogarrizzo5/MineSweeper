//
//  Cell.swift
//  MineSweeper
//
//  Created by Martin on 09/03/22.
//

import UIKit


class Cell {
	var row: Int
	var col: Int
	var button: UIButton
	var isFlagged = false
	var isExplored = false
	var minesCount = 0
	var isMine = false
	let numberColors = [ #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) , #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)]
	
	init(row: Int, col: Int, button: UIButton) {
		self.row = row
		self.col = col
		self.button = button
	}
	
	func showMinesNumber() {
		button.setTitleColor(numberColors[minesCount - 1], for: .normal)
		button.setTitle(String(minesCount), for: .normal)
	}
	
	func toggleFlag() {
		if isExplored {
			return
		}
		
		if isFlagged {
			button.setBackgroundImage(#imageLiteral(resourceName: "bush"), for: .normal)
			isFlagged = false
		} else {
			button.setBackgroundImage(#imageLiteral(resourceName: "flag"), for: .normal)
			isFlagged = true
		}
	}
	
	func cover() {
		button.setBackgroundImage(#imageLiteral(resourceName: "bush"), for: .normal)
		isExplored = false
		isFlagged = false
		minesCount = 0
		button.setTitle("", for: .normal)
	}
	
}
