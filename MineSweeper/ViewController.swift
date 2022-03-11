//
//  ViewController.swift
//  MineSweeper
//
//  Created by Martin on 08/03/22.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var flowerBedView: UIStackView!
	@IBOutlet weak var discoverButton: UIButton!
	@IBOutlet weak var flagButton: UIButton!
	@IBOutlet weak var playAgainButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	
	enum Actions {
		case flag
		case discover
	}
	
	var grid: [[Cell]] = []
	var isGameOver = false
	var action = Actions.discover
	var minesPositions: [(Int, Int)] = []
	var exploredCells = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.font = UIFont(name: "FredokaOne-Regular", size: 60)
		flowerBedView.spacing = 3
		discoverButton.titleLabel?.font = UIFont(name: "FredokaOne-Regular", size: 36)
		flagButton.titleLabel?.font = UIFont(name: "FredokaOne-Regular", size: 36)
		discoverButton.layer.cornerRadius = 30
		playAgainButton.titleLabel?.font = UIFont(name: "FredokaOne-Regular", size: 36)
		playAgainButton.layer.cornerRadius = 30
		flagButton.layer.cornerRadius = 30
		playAgainButton.isHidden = true
		setButtonAsActive(button: discoverButton)
		
		for i in 0..<9 {
			var gridRow: [Cell] = []
			let bushesRow = UIStackView()
			
			bushesRow.distribution = .equalSpacing
			bushesRow.alignment = .fill
			bushesRow.spacing = 3
			
			for j in 0..<9 {
				let newBush = UIButton()
				// button's constraints
				newBush.addConstraint(NSLayoutConstraint(item: newBush, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70))
				newBush.addConstraint(NSLayoutConstraint(item: newBush, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70))
				newBush.setBackgroundImage(#imageLiteral(resourceName: "bush"), for: .normal)
				// connect action
				newBush.addTarget(self, action: #selector(clickBush), for: .touchUpInside)
				newBush.titleLabel?.font = UIFont(name: "FredokaOne-Regular", size: 36)
				
				// add reference row-col
				newBush.accessibilityLabel = "\(i)-\(j)"
				// add cell to rows
				bushesRow.addArrangedSubview(newBush)
				gridRow.append(Cell(row: i, col: j, button: newBush))
			}
			// add row to grid
			flowerBedView.addArrangedSubview(bushesRow)
			grid.append(gridRow)
		}
		
		setupMines()
	}
	
	func setupMines() {
		minesPositions = []
		var minesToAdd = 10
		
		while minesToAdd > 0 {
			let randomX = Int.random(in: 0..<grid.count)
			let randomY = Int.random(in: 0..<grid.count)
			let cell = grid[randomX][randomY]
			
			if !cell.isMine {
				minesToAdd -= 1
				cell.isMine = true
				minesPositions.append((randomX, randomY))
			}
		}
	}
	
	@objc func clickBush(sender: UIButton) {
		if isGameOver {
			return
		}
		
		let buttonPos = sender.accessibilityLabel!.split(separator: "-")
		let row = Int(buttonPos[0])!
		let col = Int(buttonPos[1])!
		let cell = grid[row][col]
		
		if action == .flag {
			cell.toggleFlag()
			return
		}
		if cell.isFlagged {
			return
		}
		
		if cell.isMine && !cell.isFlagged {
			gameLost()
		} else {
			self.discoverBush(row: row, col: col)
		}
		
		// check if remained cells are only mines
		if grid.count * grid.count - exploredCells == minesPositions.count {
			gameWon()
		}
	}
	
	func discoverBush(row: Int, col: Int) {
		let cell = grid[row][col]
		
		if cell.isExplored || cell.isMine {
			return
		}
		
		cell.isExplored = true
		exploredCells += 1
		cell.button.setBackgroundImage(nil, for: .normal)
		
		cell.minesCount = countAreaMines(row: row, col: col)
		if cell.minesCount > 0 {
			cell.showMinesNumber()
			return
		}
		
		// explore all directions
		for i in -1...1 {
			for j in -1...1 {
				if isInGrid(row: row + i, col: col + j) {
					discoverBush(row: row + i, col: col + j)
				}
			}
		}
	}
	
	func countAreaMines(row: Int, col: Int) -> Int {
		var count = 0
		for i in -1...1 {
			for j in -1...1 {
				if isInGrid(row: row + i, col: col + j) && grid[row + i][col + j].isMine {
					count += 1
				}
			}
		}
		return count
	}
	
	func isInGrid(row: Int, col: Int) -> Bool {
		var isValid = false
		if row >= 0 && row < grid.count && col >= 0 && col < grid.count {
			isValid = true
		}
		return isValid
	}
	
	func gameLost() {
		endGame()
		showAllMines()
		titleLabel.text = "You Lost!"
	}
	
	func gameWon() {
		endGame()
		titleLabel.text = "You Won!"
	}
	
	func endGame() {
		isGameOver = true
		playAgainButton.isHidden = false
		flagButton.isHidden = true
		discoverButton.isHidden = true
	}
	
	@IBAction func playAgain(_ sender: Any) {
		isGameOver = false
		resetCells()
		setupMines()
		playAgainButton.isHidden = true
		flagButton.isHidden = false
		discoverButton.isHidden = false
		titleLabel.text = "Mine Sweeper"
		exploredCells = 0
	}
	
	func showAllMines() {
		for pos in minesPositions {
			grid[pos.0][pos.1].button.setBackgroundImage(#imageLiteral(resourceName: "flower2"), for: .normal)
		}
	}
	
	func resetCells() {
		for row in grid {
			for cell in row {
				cell.cover()
				cell.isMine = false
			}
		}
	}
	
	@IBAction func useFlag(_ sender: Any) {
		if action == .flag {
			action = .discover
			setButtonAsActive(button: discoverButton)
			setButtonAsDeactivated(button: flagButton)
		} else {
			action = .flag
			setButtonAsActive(button: flagButton)
			setButtonAsDeactivated(button: discoverButton)
		}
	}
	
	@IBAction func useDiscover(_ sender: Any) {
		if action == .discover {
			action = .flag
			setButtonAsActive(button: flagButton)
			setButtonAsDeactivated(button: discoverButton)
		} else {
			action = .discover
			setButtonAsActive(button: discoverButton)
			setButtonAsDeactivated(button: flagButton)
		}
	}
	
	func setButtonAsActive(button: UIButton) {
		button.backgroundColor = UIColor.white
		button.setTitleColor(UIColor.orange, for: .normal)
	}
	
	func setButtonAsDeactivated(button: UIButton) {
		button.backgroundColor = UIColor.orange
		button.setTitleColor(UIColor.white, for: .normal)
	}
}

