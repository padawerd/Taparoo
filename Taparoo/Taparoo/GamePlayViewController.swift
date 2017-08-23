//
//  GamePlayViewController.swift
//  Taparoo
//
//  Created by david padawer on 8/15/17.
//  Copyright © 2017 DPad Studios. All rights reserved.
//

import Foundation
import UIKit
import Skillz

class GamePlayViewController : UIViewController {
    var model = GamePlayModel()
    let gameLoop = GameLoop(frameInterval: 1, onTick: {() in })
    var progressBar = [UIView]()
    var ticks = 0
    var gameTimer : Timer!


    func setup() {
        let gameplayView = self.view as! GamePlayView
        self.progressBar = [gameplayView.firstBar,
                            gameplayView.secondBar,
                            gameplayView.thirdBar,
                            gameplayView.fourthBar,
                            gameplayView.fifthBar,
                            gameplayView.sixthBar,
                            gameplayView.seventhBar,
                            gameplayView.eighthBar,
                            gameplayView.ninthBar]

        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

        self.gameLoop.onTick = {() in

            //move existing notes
            self.moveAllNotes()
            self.ticks += 1

            //create new note
            if (self.ticks == 8) {
                self.ticks = 0
                let note = Note()
                var randomNum =  Int(Skillz.getRandomNumber(withMin: 0, andMax: 7))
                //var randomNum = Int(arc4random_uniform(7))
                //not the same note as the previous one
                if let mostRecentNote = self.model.currentNotes.last {
                    if (randomNum >= mostRecentNote.type.rawValue) {
                        randomNum += 1
                    }
                }

                note.setup(type: NoteType(rawValue: randomNum)!)
                self.renderNote(note: note);

            }
        }
    }

    func updateTime() {
        if (self.model.secondsLeft > 0) {
            self.model.secondsLeft -= 1
            let gamePlayView = self.view as! GamePlayView
            if (self.model.secondsLeft > 9) {
                gamePlayView.timeLeft.text = "0:" + String(self.model.secondsLeft)
            } else {
                gamePlayView.timeLeft.text = "0:0" + String(self.model.secondsLeft)
            }
        } else {
            self.endGame()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    func manageProgressBar() {
        if (self.model.streak % 10 != 0) {
            self.progressBar[(self.model.streak % 10) - 1].backgroundColor = UIColor.green
        } else {
            if (self.model.streak != 0) {
                self.model.currentMultiplier += 1
                let gamePlayView = self.view as! GamePlayView
                gamePlayView.multiplier.text = "Multiplier: " + String(self.model.currentMultiplier) + "x"
                gamePlayView.levelUp.alpha = 1.0;
                UIView.animate(withDuration: 1.0, animations: {() in gamePlayView.levelUp.alpha = 0.0})
            }
            for bar in self.progressBar {
                bar.backgroundColor = UIColor.clear
            }
        }

    }

    func renderNote(note: Note) {
        let renderedNote = Bundle.main.loadNibNamed("Note", owner: nil, options: nil)!.first as! Note
        renderedNote.setup(type: note.type)
        let gamePlayView = self.view as! GamePlayView
        renderedNote.isEnabled = false
        renderedNote.onClick = {() in
            self.model.currentNotes = self.model.currentNotes.filter({$0 != renderedNote})
            renderedNote.button.removeFromSuperview()
            self.model.streak += 1
            self.model.score += self.model.currentMultiplier
            self.manageProgressBar()
            gamePlayView.score.text = "Score: " + String(self.model.score)
            let score = NSNumber(integerLiteral: self.model.score)
            Skillz.skillzInstance().updatePlayersCurrentScore(score)
        }

        renderedNote.frame.size = CGSize(width: 50, height: 50)


        //another switch
        //put them in the corners  at first
        //on completion, start their timers to disappear.
        //on completion, enable the button

        switch note.type! {
        case NoteType.TopLeft:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.topLeft.frame.origin.x - 100, y: gamePlayView.topLeft.frame.origin.y - 100)
            renderedNote.button.backgroundColor = UIColor.red
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.topLeft.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.topLeft.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x + CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y + CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.TopMiddle:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.topMiddle.frame.origin.x,
                                                y: gamePlayView.topMiddle.frame.origin.y - 100)
            renderedNote.button.backgroundColor = UIColor.green
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.topMiddle.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.y - gamePlayView.topMiddle.frame.origin.y) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x,
                                                        y: renderedNote.frame.origin.y + CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.TopRight:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.topRight.frame.origin.x + 100,
                                                y: gamePlayView.topRight.frame.origin.y - 100)
            renderedNote.button.backgroundColor = UIColor.blue
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.topRight.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.topRight.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x - CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y + CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.MiddleLeft:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.middleLeft.frame.origin.x - 100,
                                                y: gamePlayView.middleLeft.frame.origin.y)
            renderedNote.button.backgroundColor = UIColor.purple
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.middleLeft.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.middleLeft.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x + CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y)
                }
            }
        case NoteType.BottomLeft:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.bottomLeft.frame.origin.x - 100,
                                                y: gamePlayView.bottomLeft.frame.origin.y + 100)
            renderedNote.button.backgroundColor = UIColor.orange
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.bottomLeft.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.bottomLeft.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x + CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y - CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.BottomMiddle:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.bottomMiddle.frame.origin.x,
                                                y: gamePlayView.bottomMiddle.frame.origin.y + 100)
            renderedNote.button.backgroundColor = UIColor.magenta
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.bottomMiddle.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.y - gamePlayView.bottomMiddle.frame.origin.y) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x,
                                                        y: renderedNote.frame.origin.y - CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.BottomRight:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.bottomRight.frame.origin.x + 100,
                                                y: gamePlayView.bottomRight.frame.origin.y + 100)
            renderedNote.button.backgroundColor = UIColor.cyan
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.bottomRight.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.bottomRight.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x - CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y - CGFloat(self.model.gameSpeed))
                }
            }
        case NoteType.MiddleRight:
            renderedNote.frame.origin = CGPoint(x: gamePlayView.middleRight.frame.origin.x + 100,
                                                y: gamePlayView.middleRight.frame.origin.y)
            renderedNote.button.backgroundColor = UIColor.black
            renderedNote.move = {() in
                if (renderedNote.frame.origin == gamePlayView.middleRight.frame.origin) {
                    if (renderedNote.ticksOnPoint > self.model.ticksUntilGone) {
                        self.removeRenderedNote(note: renderedNote)
                    } else {
                        renderedNote.ticksOnPoint += 1
                    }
                } else {
                    if (abs(renderedNote.frame.origin.x - gamePlayView.middleRight.frame.origin.x) == CGFloat(self.model.hitSlop)) {
                        renderedNote.isEnabled = true
                    }
                    renderedNote.frame.origin = CGPoint(x: renderedNote.frame.origin.x - CGFloat(self.model.gameSpeed),
                                                        y: renderedNote.frame.origin.y)
                }
            }
        }
        self.view.addSubview(renderedNote)
        self.model.currentNotes.append(renderedNote)
    }

    func removeRenderedNote(note: Note) {
        self.model.streak = 0;
        self.model.currentMultiplier = 1
        self.updateMultiplierText()
        self.model.currentNotes = self.model.currentNotes.filter({$0 != note})
        note.removeFromSuperview()
        self.manageProgressBar()
    }

    func updateMultiplierText() {
        let gameplayView = self.view as! GamePlayView
        gameplayView.multiplier.text = "Multiplier: " + String(self.model.currentMultiplier) + "x"
    }

    func moveAllNotes() {
        for note in self.model.currentNotes {
            note.move()
        }
        self.view.layoutSubviews()
    }

    func endGame() {
        let gamePlayView = self.view as! GamePlayView
        self.gameLoop.stop()
        self.gameTimer.invalidate()
        self.gameTimer = nil
        gamePlayView.gameOverScreen.isHidden = false
        gamePlayView.gameOverText.text = "Game Over\n Your Score: " + String(self.model.score)
        for note in self.model.currentNotes {
            note.removeFromSuperview()
        }
        let score = NSNumber(integerLiteral: self.model.score)
        Skillz.skillzInstance().displayTournamentResults(withScore: score, withCompletion: {() in })
    }
}
