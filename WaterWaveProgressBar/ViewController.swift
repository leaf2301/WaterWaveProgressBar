//
//  ViewController.swift
//  WaterWaveProgressBar
//
//  Created by Tran Hieu on 01/12/2023.
//

import UIKit

let screenWidth: CGFloat = 400


class ViewController: UIViewController {

    let waterWaveView = WaterWaveView()
    
    let dr: TimeInterval = 10.0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(waterWaveView)
        waterWaveView.setupProgress(waterWaveView.progress)
        waterWaveView.layer.cornerRadius = screenWidth/4
        
        NSLayoutConstraint.activate([
            waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth/2),
            waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth/2),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            
            let dr = CGFloat(1.0/(self.dr/0.01))
            
            self.waterWaveView.progress += dr
            self.waterWaveView.setupProgress(self.waterWaveView.progress)
            
            if self.waterWaveView.progress >= 1 {
                self.timer?.invalidate()
                self.timer = nil
//                self.waterWaveView.backgroundColor = .cyan
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.waterWaveView.percentAnim()
                }
            }
            print(self.waterWaveView.progress)
        })
    }
}

