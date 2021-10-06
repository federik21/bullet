//
//  GamePresenter.swift
//  FantasticHero
//
//  Created by Piccirilli Federico on 26/07/21.
//

/* In a MVP architecture, the presenter acts in the middle between views and models.
 gameEngine is used to interact with model.
 */

import Combine

protocol GamePresenter: AnyObject {
    var gameEngine: GameEngine {get set}
    func getBoardDimension() -> (Int, Int)

    func userWantsToStart()
    func userWantsToDraw()
    func userWantsToPlayNextRound()
}

class GamePresenterImpl: GamePresenter {

    private var view: GameView?
    internal var gameEngine: GameEngine

    init(view: GameView, gameEngine: GameEngine) {
        self.view = view
        self.gameEngine = gameEngine
        self.view?.presenter = self
        gameEngine.delegate = self
    }

    func getBoardDimension() -> (Int, Int) {
        return (gameEngine.player.sight.rows,
                gameEngine.player.sight.columns)
    }

    func userWantsToStart() {
        gameEngine.addPlayer()
        view?.showGameBoard()
        self.view?.updateLives(gameEngine.player.lives)
        self.view?.updateIntensity(gameEngine.intensityLevel)
    }

    func userWantsToDraw() {
        gameEngine.playerDraws()
    }

    func userWantsToPlayNextRound() {
        gameEngine.prepareNextRound()
    }
}

extension GamePresenterImpl: GameEngineDelegate {
    func engineUpdateIntensity() {
        view?.updateIntensity(gameEngine.intensityLevel)
    }

    func enginePlayerDefeted() {
        view?.playerDefeated()
    }

    func enginePlayerHit() {
        view?.updateLives(gameEngine.player.lives)
    }

    func engineEndedBag() {
        view?.roundEnd()
    }

    func engineReadyForNextRound() {
        view?.startNextRound()
        self.view?.updateIntensity(gameEngine.intensityLevel)
    }

    func engineInsertedToken(bullet: BulletResult) {
        let bulletViewModel = BulletViewModel(bulletResult: bullet)
        view?.insert(bullet: bulletViewModel)
    }

    func engineClearedToken(bullet: BulletResult) {
        let bulletViewModel = BulletViewModel(bulletResult: bullet)
        view?.clear(bullet: bulletViewModel)
    }
}
