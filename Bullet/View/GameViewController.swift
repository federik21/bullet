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
        view.addSubview(board)
        view.addSubview(drawButton)
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
                             NSLayoutConstraint(item: board,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .top,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: board,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .centerX,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: drawButton,
                                                attribute: .topMargin,
                                                relatedBy: .equal,
                                                toItem: board,
                                                attribute: .bottomMargin,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: drawButton,
                                                attribute: .topMargin,
                                                relatedBy: .equal,
                                                toItem: board,
                                                attribute: .bottomMargin,
                                                multiplier: 1.0,
                                                constant: 0),
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
}

extension GameViewController {
    func insert(bullet: BulletViewModel) {
        board.render(bullet: bullet)
    }
    func clear(bullet: BulletViewModel) {
        board.clear(bullet: bullet)
    }
}
