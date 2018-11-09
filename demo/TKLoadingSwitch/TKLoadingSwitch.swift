//
//  TKLoadingSwitch.swift
//  TKLoadingSwitch
//
//  Created by Tungkay on 2018/11/8.
//  Copyright © 2018年 Tungkay. All rights reserved.
//

import UIKit

@IBDesignable
class TKLoadingSwitch: UIControl {
    
    fileprivate let width: CGFloat = 51
    fileprivate let height: CGFloat = 31
    fileprivate let thumbOffFrame: CGRect = CGRect(x: 1.5, y: 1.5, width: 28, height: 28)
    fileprivate let thumbOnFrame: CGRect = CGRect(x: 51 - 1.5 - 28 , y: 1.5, width: 28, height: 28)
    fileprivate let thumbTouchOffFrame: CGRect = CGRect(x: 1.5, y: 1.5, width: 28 + 7, height: 28)
    fileprivate let thumbTouchOnFrame: CGRect = CGRect(x: 51 - 1.5 - 28 - 7, y: 1.5, width: 28 + 7, height: 28)
    fileprivate let animExpandFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: 51, height: 31).insetBy(dx: 1, dy: 1)
    fileprivate let animShrinkOnFrame: CGRect = CGRect(x: 51 - 1.5 - 28 , y: 1.5, width: 28, height: 28).insetBy(dx: 14, dy: 14)
    fileprivate let animShrinkOffFrame: CGRect = CGRect(x: 1.5, y: 1.5, width: 28, height: 28).insetBy(dx: 14, dy: 14)
    fileprivate var isAnimated: Bool = false
    fileprivate var touchBeganOn: Bool = false
    fileprivate var onIsChanged: Bool = false
    fileprivate var thumbColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    fileprivate var pressBeginPoint: CGPoint = CGPoint.zero
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        view.layer.cornerRadius = height / 2
        return view
    }()
    
    fileprivate lazy var animView: UIView = {
        let view = UIView(frame: animExpandFrame)
        view.layer.cornerRadius = animExpandFrame.size.height / 2
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    fileprivate lazy var thumbView: UIView = {
        let view = UIView(frame: thumbOffFrame)
        view.backgroundColor = thumbColor
        view.layer.cornerRadius = thumbOffFrame.size.height / 2
        view.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return indicator
    }()
    
    @IBInspectable var onTintColor: UIColor = #colorLiteral(red: 0.5, green: 0.7921568627, blue: 0.4666666667, alpha: 1) {
        didSet {
            if on {
                self.bgView.backgroundColor = onTintColor
            }
        }
    }
    @IBInspectable var offTintColor: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) {
        didSet {
            if !on {
                self.bgView.backgroundColor = offTintColor
            }
        }
    }
    
    var isOn: Bool {
        get {
            return on
        }
    }
    
    
   @IBInspectable var on: Bool = false {
        
        didSet {
            if isAnimated {
                return
            }
            if on {
                onState()
            }
            else {
                offState()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        print("frame = \(frame)")
    }
    
    override init(frame: CGRect) {
        var rect = frame
        rect.size = CGSize(width: width, height: height)
        super.init(frame: rect)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        setup()
    }
    
    func startLoading() {
        self.indicator.startAnimating()
    }
    
    func stopLoading() {
        self.indicator.stopAnimating()
    }
    
    func resumeState() {
        isAnimated = true
        on = !on
        isAnimated = false
        self.animatingState(beginState: onState, endState: offState, duration: 0.2)
    }
    
    fileprivate func setup() {
        setupGestures()
        self.addSubview(self.bgView)
        self.addSubview(self.animView)
        self.addSubview(self.thumbView)
        offState()
        let offset = self.thumbView.frame.size.width - self.indicator.frame.size.width
        self.indicator.frame.origin = CGPoint(x: offset / 2, y: offset / 2)
        self.thumbView.addSubview(self.indicator)
        stopLoading()
    }
    
    fileprivate func offState() {
        self.bgView.backgroundColor = self.offTintColor
        self.animView.frame = self.animExpandFrame
        self.thumbView.frame = self.thumbOffFrame
    }
    
    fileprivate func onState() {
        self.bgView.backgroundColor = self.onTintColor
        self.animView.frame = self.animShrinkOnFrame
        self.thumbView.frame = self.thumbOnFrame
    }
    
    fileprivate func touchOffState() {
        self.bgView.backgroundColor = self.offTintColor
        self.animView.frame = self.animShrinkOffFrame
        self.thumbView.frame = self.thumbTouchOffFrame
    }
    
    fileprivate func touchOnState() {
        self.bgView.backgroundColor = self.onTintColor
        self.animView.frame = self.animShrinkOnFrame
        self.thumbView.frame = self.thumbTouchOnFrame
    }
    
    fileprivate func animatingState(beginState:@escaping ()->(), endState:@escaping ()->(), duration: TimeInterval) {
        
        UIView.animate(withDuration: duration) {
            self.on ? beginState() : endState()
        }
    }
    
    fileprivate func setupGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(gesture:)))
        self.addGestureRecognizer(tap)
        let press: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pressAction(gesture:)))
        press.minimumPressDuration = 0.1
        self.addGestureRecognizer(press)
    }
    
    @objc fileprivate func tapAction(gesture: UITapGestureRecognizer) {
        guard !self.indicator.isAnimating else {
            return
        }
        isAnimated = true
        self.on = !self.on
        isAnimated = false
        animatingState(beginState: onState, endState: offState, duration: 0.2)
        self.sendActions(for: .valueChanged)
    }
    
    @objc fileprivate func pressAction(gesture: UILongPressGestureRecognizer) {
        guard !self.indicator.isAnimating else {
            return
        }
        let point = gesture.location(in: self)
        
        switch gesture.state {
        case UIGestureRecognizerState.began:
            touchBeganOn = on
            onIsChanged = false
            isAnimated = true
            pressBeginPoint = point
            animatingState(beginState: touchOnState, endState: touchOffState, duration: 0.2)
        case UIGestureRecognizerState.changed:
            let offset = abs(point.x - pressBeginPoint.x)
            if on == touchBeganOn && offset < 15 {
                break
            }
            on = point.x > width / 2
            if on != touchBeganOn && !onIsChanged {
                onIsChanged = true
            }
            animatingState(beginState: touchOnState, endState: touchOffState, duration: 0.2)
        case UIGestureRecognizerState.ended:
            if on == touchBeganOn && !onIsChanged {
                on = !on
            }
            isAnimated = false
            if touchBeganOn != on {
                self.sendActions(for: .valueChanged)
            }
            animatingState(beginState: onState, endState: offState, duration: 0.2)
        default:
            isAnimated = false
            animatingState(beginState: onState, endState: offState, duration: 0.2)
        }
    }
}

