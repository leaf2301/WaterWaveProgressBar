//
//  WaterWaveView.swift
//  WaterWaveProgressBar
//
//  Created by Tran Hieu on 01/12/2023.
//

import Foundation
import UIKit

class WaterWaveView: UIView {
    
    private let percentLbl = UILabel()
    
    private let firstLayer = CAShapeLayer()
    private let secondLayer = CAShapeLayer()
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let twoPi: CGFloat = .pi*2
    private var offset: CGFloat = 0
    
    private let width = screenWidth/2
    
    var showSingleWave = false
    private var start = false
    
    var progress: CGFloat = 0.0
    var waveHeight: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

extension WaterWaveView {
    private func setupViews() {
        bounds = .init(x: 0.0, y: 0, width: min(width, width), height: min(width, width))
        clipsToBounds = true
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        waveHeight = 8.0
        firstColor = .cyan
        secondColor = .cyan.withAlphaComponent(0.4)
        
        createFirstLayer()
        
        if !showSingleWave {
            createSecondLayer()
        }
        
        createPercenLbl()
    }
    
    private func createFirstLayer() {
        firstLayer.frame = bounds
        firstLayer.anchorPoint = .zero
        firstLayer.fillColor = firstColor.cgColor
        layer.addSublayer(firstLayer)
    }
    
    private func createSecondLayer() {
        secondLayer.frame = bounds
        secondLayer.anchorPoint = .zero
        secondLayer.fillColor = secondColor.cgColor
        layer.addSublayer(secondLayer)

    }
    
    private func createPercenLbl() {
        percentLbl.font = UIFont.boldSystemFont(ofSize: 35)
        percentLbl.textAlignment = .center
        percentLbl.text = "99%"
        percentLbl.textColor = .darkGray
        addSubview(percentLbl)
        percentLbl.translatesAutoresizingMaskIntoConstraints = false
        percentLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percentLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupProgress(_ pr: CGFloat) {
        progress = pr
        percentLbl.text = String(format: "%ld%%", NSNumber(value: Float(pr*100)).intValue)
        let top: CGFloat = pr*bounds.size.height
//        let top: CGFloat = 1*bounds.size.height/2
        firstLayer.setValue(width-top, forKeyPath: "position.y")
        secondLayer.setValue(width-top, forKeyPath: "position.y")
        
        if !start {
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    
    func percentAnim() {
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 1.5
        anim.fromValue = 0
        anim.toValue = 1.0
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false

        percentLbl.layer.add(anim, forKey: nil)
    }
    
    private func startAnim() {
        start = true
        waterWaveAnim()
    }
    
    private func waterWaveAnim() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        
        let startOffsetY = waveHeight * CGFloat(sinf(Float(offset*twoPi/w)))
        var originOffsetY: CGFloat = 0.0
        
        path.move(to: .init(x: 0.0, y: startOffsetY), transform: .identity)
        bezier.move(to: .init(x: 0.0, y: startOffsetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1) {
            originOffsetY = waveHeight*CGFloat(sinf(Float(twoPi / w * i + offset * twoPi / w)))
            bezier.addLine(to: .init(x: i, y: originOffsetY))
        }
        
        bezier.addLine(to: .init(x: w*1000, y: originOffsetY))
        bezier.addLine(to: .init(x: w*1000, y: h))
        bezier.addLine(to: .init(x: 0.0, y: h))
        bezier.addLine(to: .init(x: 0.0, y: startOffsetY))
        bezier.close()
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w*0.5
        anim.toValue = -w - w*0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        firstLayer.fillColor = firstColor.cgColor
        firstLayer.path = bezier.cgPath
        firstLayer.add(anim, forKey: nil)
        
        if !showSingleWave {
            let bezier = UIBezierPath()

            let startOffsetY = waveHeight * CGFloat(sinf(Float(offset*twoPi/w)))
            var originOffsetY: CGFloat = 0.0
            
            bezier.move(to: .init(x: 0.0, y: startOffsetY))
            
            for i in stride(from: 0.0, to: w*1000, by: 1) {
                originOffsetY = waveHeight*CGFloat(cosf(Float(twoPi / w * i + offset * twoPi / w)))
                bezier.addLine(to: .init(x: i, y: originOffsetY))
            }
            
            bezier.addLine(to: .init(x: w*1000, y: originOffsetY))
            bezier.addLine(to: .init(x: w*1000, y: h))
            bezier.addLine(to: .init(x: 0.0, y: h))
            bezier.addLine(to: .init(x: 0.0, y: startOffsetY))
            bezier.close()

            
            secondLayer.fillColor = secondColor.cgColor
            secondLayer.path = bezier.cgPath
            secondLayer.add(anim, forKey: nil)

        }
    }
}
