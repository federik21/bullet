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
    func engineEndedBag()
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
            print("Empty Bag!")
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
                    }
                }
            }, receiveValue: {[weak self] result in
                self?.delegate?.engineInsertedToken(bullet: result)
            })
    }
}
