//
//  Star.swift
//  ECE564_HW
//
//  Created by zjy on 5/1/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit

class Star: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let rn = rect.width / 2 * 0.95

        var cangle: Double = 54
        for i in 1 ... 5 {
            let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))
            let p = CGPoint(x: cc.x, y: cc.y)

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }
            cangle += 144
        }

        path.close()
        UIColor(red: 0.99, green: 0.85, blue: 0.05, alpha: 1.00).setFill()
        path.fill()
    }
}
