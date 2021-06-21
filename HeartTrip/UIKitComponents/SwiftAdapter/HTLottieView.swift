//
//  HTLottieView.swift
//  HeartTrip
//
//  Created by vin on 2020/11/23.
//  Copyright © 2020 BinBear. All rights reserved.
//


import UIKit
import Lottie


@objc class HTLottieView: UIView {
    
    private let animationView = AnimationView()
    private var name = ""
    @objc open var loopAnimation = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.animationView.isUserInteractionEnabled = false;
        self.isUserInteractionEnabled = false;
        self.addSubview(self.animationView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.animationView.frame = self.frame
        self.addSubview(self.animationView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.animationView.frame = self.bounds
    }
    
    @objc public func lottie(name:String){
        self.name = name
        let animation = Animation.named(name)
        self.animationView.animation = animation
        self.animationView.contentMode = .scaleAspectFill
        if self.loopAnimation {
            self.animationView.loopMode = .loop
        }
    }
    
    @objc public func play(){
        self.animationView.play()
    }
    
    @objc public func stop(){
        self.animationView.stop()
    }
    
    @objc public func stopIfAnimationPlaying(){
        if self.animationView.isAnimationPlaying {
            self.animationView.stop()
        }
    }
    
    @objc public func animationDuration() -> Double{
        return self.animationView.animation!.duration
    }
}
