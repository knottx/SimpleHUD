//
//  SimpleHUD.swift
//  SimpleHUD
//
//  Created by Visarut Tippun on 13/4/21.
//  Copyright © 2021 knottx. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public enum SimpleHUDType {
    case activityIndicator
    case circleStroke
    case circleRotateChase
    case circleSpinFade
    case threeDots
    case fiveBars
    case progress(value: CGFloat)
    case icon(_ image: UIImage?)
}

public class SimpleHUD: UIView {
    private var contentView: UIVisualEffectView?
    private var animation: UIView?
    private var progressLabel: UILabel?
    private var iconImageView: UIImageView?

    private var progressValue: CGFloat = 0 {
        didSet {
            self.progressLabel?.text = "\(Int(self.progressValue * 100))%"
        }
    }

    private var hudStacked: Int = 0

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }

    public func show(at view: UIView,
                     type: SimpleHUDType = .activityIndicator,
                     tintColor: UIColor = .gray,
                     withBezels: Bool = true,
                     bezelsSize: CGSize = .init(width: 80, height: 80),
                     bezelsBlurEffect: UIBlurEffect.Style = .prominent) {
        switch type {
        case .progress, .icon:
            self.dismissAll()

        default:
            guard self.hudStacked == 0 else {
                self.hudStacked += 1
                return
            }
        }
        self.hudStacked += 1
        if withBezels {
            self.contentView = self.contentView(size: bezelsSize,
                                                bezelsBlurEffect: bezelsBlurEffect)
            self.contentView?.center = view.center
            self.addSubview(self.contentView!)
        }

        switch type {
        case .activityIndicator:
            self.showActivityIndicatorLoading(at: view, tintColor: tintColor)
        case .circleStroke:
            self.showCircleStrokeLoading(at: view, tintColor: tintColor)
        case .circleRotateChase:
            self.showCircleRotateChaseLoading(at: view, tintColor: tintColor)
        case .circleSpinFade:
            self.showCircleSpinFadeLoading(at: view, tintColor: tintColor)
        case .threeDots:
            self.showThreeDotsLoading(at: view, tintColor: tintColor)
        case .fiveBars:
            self.showFiveBarsLoading(at: view, tintColor: tintColor)
        case let .progress(value):
            self.showProgreessLoading(at: view, tintColor: tintColor, value: value)
        case let .icon(image):
            self.showIcon(at: view, image: image, tintColor: tintColor)
        }
    }

    public func dismissAll() {
        self.hudStacked = 0
        self.dismiss()
    }

    public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hudStacked -= 1
            self.hudStacked = self.hudStacked > 0 ? self.hudStacked : 0
            guard self.hudStacked == 0 else { return }
            if self.contentView != nil {
                self.contentView?.removeFromSuperview()
                self.contentView = nil
            }
            if self.animation != nil {
                self.animation?.removeFromSuperview()
                self.animation = nil
            }
            if self.progressLabel != nil {
                self.progressLabel?.removeFromSuperview()
                self.progressLabel = nil
            }
            if self.iconImageView != nil {
                self.iconImageView?.removeFromSuperview()
                self.iconImageView = nil
            }
            self.removeFromSuperview()
        }
    }
}

extension SimpleHUD {
    private func contentView(size: CGSize, bezelsBlurEffect: UIBlurEffect.Style) -> UIVisualEffectView {
        let view: UIVisualEffectView = .init(frame: CGRect(origin: .zero, size: size))
        view.effect = UIBlurEffect(style: bezelsBlurEffect)
        view.layer.cornerRadius = 16
        if #available(iOS 13.0, *) {
            view.layer.cornerCurve = .continuous
        }
        view.layer.masksToBounds = true
        return view
    }

    private func showActivityIndicatorLoading(at view: UIView, tintColor: UIColor) {
        let animation = UIActivityIndicatorView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        if #available(iOS 13.0, *) {
            animation.center = CGPoint(x: view.center.x + 1.5, y: view.center.y + 1.5)
            animation.style = .large
        } else {
            animation.center = view.center
            animation.style = .gray
            animation.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }
        animation.color = tintColor
        animation.hidesWhenStopped = true
        animation.startAnimating()
        self.animation = animation

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    private func showCircleStrokeLoading(at view: UIView, tintColor: UIColor) {
        let width = CGFloat(40)
        let height = CGFloat(40)

        let beginTime = 0.5
        let durationStart = 1.2
        let durationStop = 0.7

        let animationRotation: CABasicAnimation = .init(keyPath: "transform.rotation")
        animationRotation.byValue = 2 * Float.pi
        animationRotation.timingFunction = CAMediaTimingFunction(name: .linear)

        let animationStart: CABasicAnimation = .init(keyPath: "strokeStart")
        animationStart.duration = durationStart
        animationStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
        animationStart.fromValue = 0
        animationStart.toValue = 1
        animationStart.beginTime = beginTime

        let animationStop: CABasicAnimation = .init(keyPath: "strokeEnd")
        animationStop.duration = durationStop
        animationStop.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)
        animationStop.fromValue = 0
        animationStop.toValue = 1

        let animation: CAAnimationGroup = .init()
        animation.animations = [animationRotation, animationStop, animationStart]
        animation.duration = durationStart + beginTime
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        let path: UIBezierPath = .init(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: width / 2,
                                       startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        layer.path = path.cgPath
        layer.fillColor = nil
        layer.strokeColor = tintColor.cgColor
        layer.lineWidth = 3
        layer.add(animation, forKey: "animation")

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.animation?.center = view.center
        self.animation?.layer.addSublayer(layer)

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    private func showCircleRotateChaseLoading(at view: UIView, tintColor: UIColor) {
        let width = CGFloat(40)
        let height = CGFloat(40)

        let spacing: CGFloat = 3
        let radius = (width - 4 * spacing) / 3.5
        let radiusX = (width - radius) / 2

        let duration: CFTimeInterval = 1.5

        let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2),
                                radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

        let pathPosition = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2),
                                        radius: radiusX, startAngle: 1.5 * .pi, endAngle: 3.5 * .pi, clockwise: true)

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.animation?.center = view.center

        for i in 0..<5 {
            let rate = Float(i) * 1 / 5
            let fromScale = 1 - rate
            let toScale = 0.2 + rate
            let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)

            let animationScale = CABasicAnimation(keyPath: "transform.scale")
            animationScale.duration = duration
            animationScale.repeatCount = HUGE
            animationScale.fromValue = fromScale
            animationScale.toValue = toScale

            let animationPosition = CAKeyframeAnimation(keyPath: "position")
            animationPosition.duration = duration
            animationPosition.repeatCount = HUGE
            animationPosition.path = pathPosition.cgPath

            let animation = CAAnimationGroup()
            animation.animations = [animationScale, animationPosition]
            animation.timingFunction = timeFunc
            animation.duration = duration
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false

            let layer = CAShapeLayer()
            layer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
            layer.path = path.cgPath
            layer.fillColor = tintColor.cgColor
            layer.add(animation, forKey: "animation")
            self.animation?.layer.addSublayer(layer)
        }

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    private func showCircleSpinFadeLoading(at view: UIView, tintColor: UIColor) {
        let width = CGFloat(40)

        let spacing: CGFloat = 3
        let radius = (width - 4 * spacing) / 3.5
        let radiusX = (width - radius) / 2

        let duration = 1.0
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.84, 0.72, 0.6, 0.48, 0.36, 0.24, 0.12, 0]

        let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
        animationScale.keyTimes = [0, 0.5, 1]
        animationScale.values = [1, 0.4, 1]
        animationScale.duration = duration

        let animationOpacity = CAKeyframeAnimation(keyPath: "opacity")
        animationOpacity.keyTimes = [0, 0.5, 1]
        animationOpacity.values = [1, 0.3, 1]
        animationOpacity.duration = duration

        let animation = CAAnimationGroup()
        animation.animations = [animationScale, animationOpacity]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2),
                                radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: width)))
        self.animation?.center = view.center

        for i in 0..<8 {
            let angle = .pi / 4 * CGFloat(i)

            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = tintColor.cgColor
            layer.backgroundColor = nil
            layer.frame = CGRect(x: radiusX * (cos(angle) + 1), y: radiusX * (sin(angle) + 1), width: radius, height: radius)

            animation.beginTime = beginTime - beginTimes[i]

            layer.add(animation, forKey: "animation")
            self.animation?.layer.addSublayer(layer)
        }

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    private func showThreeDotsLoading(at view: UIView, tintColor: UIColor) {
        let width = CGFloat(40)
        let height = CGFloat(40)

        let spacing: CGFloat = 3
        let radius: CGFloat = (width - spacing * 2) / 3
        let ypos: CGFloat = (height - radius) / 2

        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.36, 0.24, 0.12]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.3, 1]
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        let path = UIBezierPath(arcCenter: CGPoint(x: radius / 2, y: radius / 2),
                                radius: radius / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.animation?.center = view.center

        for i in 0..<3 {
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: (radius + spacing) * CGFloat(i), y: ypos, width: radius, height: radius)
            layer.path = path.cgPath
            layer.fillColor = tintColor.cgColor

            animation.beginTime = beginTime - beginTimes[i]

            layer.add(animation, forKey: "animation")
            self.animation?.layer.addSublayer(layer)
        }

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    private func showFiveBarsLoading(at view: UIView, tintColor: UIColor) {
        let width = CGFloat(40)
        let height = CGFloat(24)

        let lineWidth = width / 9

        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.5, 0.4, 0.3, 0.2, 0.1]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.68, 0.18, 1.08)

        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.4, 1]
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lineWidth, height: height), cornerRadius: width / 2)

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.animation?.center = view.center

        for i in 0..<5 {
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: lineWidth * 2 * CGFloat(i), y: 0, width: lineWidth, height: height)
            layer.path = path.cgPath
            layer.backgroundColor = nil
            layer.fillColor = tintColor.cgColor

            animation.beginTime = beginTime - beginTimes[i]

            layer.add(animation, forKey: "animation")
            self.animation?.layer.addSublayer(layer)
        }

        self.addSubview(self.animation!)
        view.addSubview(self)
    }

    func showProgreessLoading(at view: UIView, tintColor: UIColor, value: CGFloat) {
        let width = CGFloat(50)
        let height = CGFloat(50)

        let center = CGPoint(x: width / 2, y: height / 2)
        let radiusCircle = width / 2
        let radiusProgress = width / 2 - 3

        let pathCircle = UIBezierPath(arcCenter: center, radius: radiusCircle, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)
        let pathProgress = UIBezierPath(arcCenter: center, radius: radiusProgress, startAngle: -0.5 * .pi, endAngle: 1.5 * .pi, clockwise: true)

        self.animation = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.animation?.center = view.center

        let layerCircle = CAShapeLayer()
        let layerProgress = CAShapeLayer()
        layerCircle.path = pathCircle.cgPath
        layerCircle.fillColor = UIColor.clear.cgColor
        layerCircle.lineWidth = 3
        layerCircle.strokeColor = tintColor.cgColor

        layerProgress.path = pathProgress.cgPath
        layerProgress.fillColor = UIColor.clear.cgColor
        layerProgress.lineWidth = 5
        layerProgress.strokeColor = tintColor.cgColor
        layerProgress.strokeEnd = 0

        self.animation?.layer.addSublayer(layerCircle)
        self.animation?.layer.addSublayer(layerProgress)

        self.progressLabel = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        self.progressLabel?.center = view.center
        self.progressLabel?.textColor = tintColor
        self.progressLabel?.textAlignment = .center
        self.progressLabel?.font = .systemFont(ofSize: 12)

        self.addSubview(self.animation!)
        self.addSubview(self.progressLabel!)
        view.addSubview(self)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.2
        animation.fromValue = self.progressValue > value ? 0 : self.progressValue
        animation.toValue = value
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        layerProgress.add(animation, forKey: "animation")
        self.progressValue = value
    }

    func showIcon(at view: UIView, image: UIImage?, tintColor: UIColor) {
        self.iconImageView = .init(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        self.iconImageView?.image = image
        self.iconImageView?.tintColor = tintColor
        self.iconImageView?.contentMode = .scaleAspectFit
        self.iconImageView?.center = view.center

        self.addSubview(self.iconImageView!)
        view.addSubview(self)
    }
}

#endif
