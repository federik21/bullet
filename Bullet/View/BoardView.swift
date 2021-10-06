//
//  ViewController.swift
//  Game of Squares
//
//  Created by Piccirilli Federico on 10/04/2021.
//

import UIKit

protocol TapActionDelegate: AnyObject {
    func userTapped(index: Int)
    func clear(bullet: BulletViewModel)
}

class BoardViewUI: UIView {
    var rows: Int
    var columns: Int
    var tapAction: ((Int) -> Void)?
    weak var tapActionDelegate: TapActionDelegate?

    var columnWidth: CGFloat { return CGFloat(self.frame.width / CGFloat(columns))}
    var rowHeight: CGFloat { return CGFloat(self.frame.height / CGFloat(rows))}

    init(rows: Int, columns: Int, action: ((Int) -> Void)? = nil) {
        self.rows = rows
        self.columns = columns
        self.tapAction = action
        super.init(frame: .zero)
        setUpGrid()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpGrid() {
        // The first row is aligned at the top of the container
        var top: UIView = self
        var topAttr: NSLayoutConstraint.Attribute = .top

        for row in 0...rows - 1 {
            // The first column is aligned at the leading of the container
            var leading: UIView = self
            var leadingAttr: NSLayoutConstraint.Attribute = .leading

            for col in 0...columns - 1 {
                let button = UIButton(frame: .zero)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tag = col + (row * columns)

                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.black.cgColor
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

                self.addSubview(button)

                let constraints = getBlockConstraints(button: button, leading: leading, leadingAttr: leadingAttr, top: top, topAttr: topAttr)

                if col == columns - 1 {
                    // Preparing constraint for the next row
                    leading = self
                    leadingAttr = .leading

                    // Next row's buttons will have a top constraint equal to the bottom of the last button
                    top = button
                    topAttr = .bottom
                } else {
                    // Every column after the first has a leading constraint matching the trailing of the previous
                    leading = button
                    leadingAttr = .trailing
                }
                self.addConstraints(constraints)
            }
        }
    }

    private func getBlockConstraints(button: UIButton,
                                    leading: UIView,
                                    leadingAttr: NSLayoutConstraint.Attribute,
                                    top: UIView,
                                    topAttr: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        let leadingConstraint = NSLayoutConstraint(item: button,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: leading,
                                                   attribute: leadingAttr,
                                                   multiplier: 1.0,
                                                   constant: 0)

        let topConstraint = NSLayoutConstraint(item: button,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: top,
                                               attribute: topAttr,
                                               multiplier: 1.0,
                                               constant: 0)

        let dimWConstraint = NSLayoutConstraint(item: button,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .width,
                                               multiplier: CGFloat(1.0 / CGFloat(columns)),
                                               constant: 0)
        let dimHConstraint = NSLayoutConstraint(item: button,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .height,
                                               multiplier: CGFloat(1.0 / CGFloat(rows)),
                                               constant: 0)
        return [leadingConstraint, topConstraint, dimWConstraint, dimHConstraint]
    }

    func setImageForIndex(_ index: Int, image: UIImage) {
        let view = self.subviews[index]
        let imageView: UIImageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            view.addConstraints([NSLayoutConstraint(item: imageView,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: view.safeAreaLayoutGuide,
                                                    attribute: .leading,
                                                    multiplier: 1.0,
                                                    constant: 0),
                                 NSLayoutConstraint(item: imageView,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: view.safeAreaLayoutGuide,
                                                    attribute: .trailing,
                                                    multiplier: 1.0,
                                                    constant: 0),
                                 NSLayoutConstraint(item: imageView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: view.safeAreaLayoutGuide,
                                                    attribute: .top,
                                                    multiplier: 1.0,
                                                    constant: 0),
                                 NSLayoutConstraint(item: imageView,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: view.safeAreaLayoutGuide,
                                                    attribute: .bottom,
                                                    multiplier: 1.0,
                                                    constant: 0),
            ])
    }


    @objc func buttonAction(sender: UIButton!) {
        let index = sender.tag
        let row = index / columns
        _ = index - (row * columns)
        guard index <= self.subviews.count else {
            return
        }
        // Selected Block
        _ = self.subviews[index]
        tapAction?(index)
        tapActionDelegate?.userTapped(index: index)
    }

    fileprivate func prepareBoardForReuse() {
        for sv in self.subviews {
            sv.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }

    fileprivate func disableBoard() {
        for sv in self.subviews {
            sv.isUserInteractionEnabled = false
        }
    }
}

protocol GameBoardView: UIView {
    func render(bullet: BulletViewModel)
}

class GameBoard: BoardViewUI, GameBoardView {
    fileprivate func addSprite(_ token: BulletViewModel, view: UIView) {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = token.value
        view.backgroundColor = token.color
        
        view.addSubview(label)
        view.addConstraints([NSLayoutConstraint(item: label,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .centerX,
                                                multiplier: 1.0,
                                                constant: 0),
                             NSLayoutConstraint(item: label,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: view.safeAreaLayoutGuide,
                                                attribute: .centerY,
                                                multiplier: 1.0,
                                                constant: 0),
        ])
    }

    func render(bullet: BulletViewModel) {
        let view = self.subviews[bullet.col + (bullet.row * columns)]
        addSprite(bullet, view: view)
    }

    func clear(bullet: BulletViewModel) {
        let view = self.subviews[bullet.col + (bullet.row * columns)]
        for v in view.subviews { v.removeFromSuperview() }
    }
}
