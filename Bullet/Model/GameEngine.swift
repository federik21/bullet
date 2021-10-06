//
//  GameEngine.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

import Combine

protocol GameEngineDelegate {
    func engineInsertedToken(bullet: BulletResult)
    func engineClearedToken(bullet: BulletResult)
    func enginePlayerHit()
    func enginePlayerDefeted()
    func engineEndedBag()
    func engineUpdateIntensity()
    func engineReadyForNextRound()
}

class GameEngine {
    var center: Bag = Bag(bullets: GameComponents.Bullets.center)
    var player: Player!
    var intensityLevel: Int = 7

    var delegate: GameEngineDelegate?

    var observable: [AnyCancellable] = []

    func addPlayer()  {
        let player = Player(center: center)
        self.player = player
    }

    func playerDraws() {
        guard let extractedBullet = player.bag.drawBullet() else {
            self.delegate?.engineEndedBag()
            return
        }
        _ = player.sight.insert(bullet: extractedBullet)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("OK")
                case .failure(let error):
                    if let err = error as? SightError, err == .playerHit {
                        print("Hit!")
                        self.player.lives -= 1
                        if self.player.lives == 0 {
                            self.delegate?.enginePlayerDefeted()
                        }
                        self.delegate?.enginePlayerHit()
                    }
                }
            }, receiveValue: {[weak self] result in
                self?.delegate?.engineInsertedToken(bullet: result)
            })
    }

    func prepareNextRound() {
        for _ in 0...intensityLevel {
            player.bag.addBullet(center.drawBullet()!)
        }
        intensityLevel += 1
        delegate?.engineReadyForNextRound()
    }

    func increaseIntensity() {

    }
}
