//
//  MyBackCardViewController.swift
//  ECE564_HW
//
//  Created by zjy on 4/30/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit
import AVFoundation

/*
 Reference: https://betterprogramming.pub/animate-your-gradient-in-swift-52186b9b14d3
 */
class MyBackCardViewController: UIViewController, CAAnimationDelegate {
    @IBOutlet weak var flipBtn: UIButton!
    var player: AVAudioPlayer?

    /*
     Audio.
     */
    func playSound() {
        if let asset = NSDataAsset(name:"typing") {
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
                player?.numberOfLoops = -1
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    /*
     Attributed text.
     */
    @IBOutlet weak var text: UITextView!
    func setText() {
        let nsShadow = NSShadow()
        nsShadow.shadowBlurRadius = 3
        nsShadow.shadowOffset = CGSize(width: 3, height: 3)
        nsShadow.shadowColor = UIColor.gray
        let attribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 25.0)!,
                          NSAttributedString.Key.shadow: nsShadow ]
        
        text.attributedText = NSAttributedString(string: "Programming...", attributes: attribute)
        view.addSubview(text)
    }
    
    /*
     Animated UIImage.
     */
    func setComputer() {
        let iav = UIImageView()
        iav.frame = CGRect(x: 65, y: 300, width: 250, height: 250)
        
        let i0 = UIImage(named: "0.png")!
        let i1 = UIImage(named: "1.png")!
        let i2 = UIImage(named: "2.png")!
        let i3 = UIImage(named: "3.png")!
        let i4 = UIImage(named: "4.png")!
        let i5 = UIImage(named: "5.png")!
        let i6 = UIImage(named: "6.png")!
        let i7 = UIImage(named: "7.png")!
        
        iav.animationImages = [i0, i1, i2, i3, i4, i5, i6, i7]
        iav.animationDuration = 1
        iav.startAnimating()
        view.addSubview(iav)
    }
    
    /*
     Background.
     */
    let color1: CGColor = UIColor(red: 210/255, green: 110/255, blue: 110/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 10/255, green: 120/255, blue: 230/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
        
    func setGradient(){
        gradientColorSet = [[color1, color2], [color2, color3], [color3, color1]]
        gradient.frame = self.view.bounds
        gradient.colors = gradientColorSet[colorIndex]
        self.view.layer.addSublayer(gradient)
    }
        
    func setBackground() {
        gradient.colors = gradientColorSet[colorIndex]
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 5.0
        
        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradient.add(gradientAnimation, forKey: "colors")
    }
        
    func updateColorIndex(){
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            setBackground()
        }
    }
    
    /*
     UIGraphics.
     */
    func setRects() {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        
        let color: UIColor = UIColor(red: 0.82, green: 0.71, blue: 0.55, alpha: 1.00)
        let bpath: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 467, width: 375, height: 200))
        bpath.lineWidth = 5
        color.setFill()
        bpath.fill()
        
        let color2: UIColor = UIColor(red: 0.55, green: 0.27, blue: 0.07, alpha: 1.00)
        let bpath2: UIBezierPath = UIBezierPath(rect: CGRect(x: 50, y: 100, width: 275, height: 200))
        color2.set()
        bpath2.lineWidth = 30
        bpath2.stroke()
        
        let saveImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let iv = UIImageView()
        iv.frame = frame
        iv.image = saveImage
        iv.backgroundColor = .white
        
        let path = UIBezierPath(rect: self.view.bounds)
        path.append(UIBezierPath(rect: CGRect(x: 50, y: 100, width: 275, height: 200)).reversing())
        let shape = CAShapeLayer()
           
        shape.path = path.cgPath
        iv.layer.mask = shape
        
        view.addSubview(iv)
    }
    
    /*
     UIGraphics.
     */
    func setLines() {
        let frame = CGRect(x: 50, y: 100, width: 275, height: 200)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        
        let color: UIColor = UIColor(red: 0.55, green: 0.27, blue: 0.07, alpha: 1.00)
        color.set()
        
        let bpath: UIBezierPath = UIBezierPath()
        bpath.move(to: CGPoint(x: 0, y: 100))
        bpath.addLine(to: CGPoint(x: 275, y: 100))
        bpath.lineWidth = 10
        bpath.stroke()
        
        let bpath2: UIBezierPath = UIBezierPath()
        bpath2.move(to: CGPoint(x: 137, y: 0))
        bpath2.addLine(to: CGPoint(x: 137, y: 200))
        bpath2.lineWidth = 10
        bpath2.stroke()
        
        let saveImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let iv = UIImageView()
        iv.frame = frame
        iv.image = saveImage
        view.addSubview(iv)
    }
    
    /*
     UIView.
     */
    func setStars() {
        let star1: UIView = Star()
        let star2: UIView = Star()
        let star3: UIView = Star()
        star1.frame = CGRect(x: 60, y: 140, width: 20, height: 20)
        star2.frame = CGRect(x: 130, y: 134, width: 20, height: 20)
        star3.frame = CGRect(x: 105, y: 170, width: 20, height: 20)
        star1.alpha = 0
        star2.alpha = 0
        star3.alpha = 0
        
        view.addSubview(star1)
        view.addSubview(star2)
        view.addSubview(star3)

        UIView.animate(withDuration: 4, delay: 4, options: .curveEaseOut, animations: {
            star1.alpha = 1.0
            star2.alpha = 1.0
            star3.alpha = 1.0
        }, completion: { (value: Bool) in
            UIView.animate(withDuration: 7, animations: {
                star1.alpha = 0
                star2.alpha = 0
                star3.alpha = 0
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        setGradient()
        setBackground()
        setRects()
        setLines()
        setText()
        setComputer()
        setStars()
        playSound()
        view.bringSubviewToFront(flipBtn)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.stop()
    }
}
