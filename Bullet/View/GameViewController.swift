//
//  GameView.swift
//  FantasticHero
//
//  Created by Piccirilli Federico on 20/07/21.
//

import UIKit

protocol GameView {
    var presenter: GamePresenter? { get set }
    func showGameBoard()
    func insert(bullet: BulletViewModel)
    func clear(bullet: BulletViewModel)
    func updateLives(_ livesLeft: Int)
}

class GameViewController: UIViewController, GameView {
    weak var presenter: GamePresenter?

    lazy var board: GameBoard = {
        let dimensions = presenter?.getBoardDimension() ?? (0,0)
        let boardView = GameBoard(rows: dimensions.0, columns: dimensions.1, action: buttonAction)
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.backgroundColor = .gray
        return boardView
    }()

    lazy var lifeCounterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()

    lazy var drawButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("draw", for: .normal)
        button.addTarget(self, action: #selector(draw), for: .touchUpInside)
        return button
    }()

    var buttonAction: ((Int) -> Void)? = { index in
        print("index: \(index)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }

    internal func showGameBoard() {
        cleanViews()
        let stackView = UIStackView(arrangedSubviews: [lifeCounterLabel, board, drawButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        stackView.axis = .vertical
        view.addSubview(stackView)
        view.addConstraints([NSLayoutConstraint(item: stackView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .top,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: stackView,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .centerX,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: stackView,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .centerX,
                                                multiplier: 1.0,
                                                constant: 0),
        ])
        board.addConstraint(NSLayoutConstraint(item: board,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: board,
                                               attribute: .width,
                                               multiplier: 1.0,
                                               constant: 0))
        view.addConstraints([NSLayoutConstraint(item: board,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .leading,
                                                multiplier: 1.0,
                                                constant: 16),
        ])
    }

    @objc func draw() {
        presenter?.userWantsToDraw()
    }

    private func cleanViews() {
        for v in view.subviews {
            v.removeFromSuperview()
        }
    }

    func updateLives(_ livesLeft: Int) {
        lifeCounterLabel.text = "LIFE: \(livesLeft)"
    }
}

extension GameViewController {
    func insert(bullet: BulletViewModel) {
        board.render(bullet: bullet)
    }
    func clear(bullet: BulletViewModel) {
        board.clear(bullet: bullet)
    }
}
