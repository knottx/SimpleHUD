//
//  SimpleToast.swift
//  SimpleHUD
//
//  Created by Visarut Tippun on 22/7/21.
//  Copyright © 2021 knottx. All rights reserved.
//

import UIKit

public class SimpleToast: UIView {
    
    private var toastView: UIVisualEffectView?
    private var toastLabel: UILabel?
    private var toastIconImageView: UIImageView?
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tap)
    }
    
    public func toast(at view: UIView, message: String?, image: UIImage?, tintColor: UIColor = .gray) {
        guard message != nil || image != nil else { return }
        
        if let image = image {
            self.toastIconImageView = .init(frame: CGRect(origin: .zero, size: CGSize(width: 56, height: 56)))
            self.toastIconImageView?.tintColor = tintColor
            self.toastIconImageView?.contentMode = .scaleAspectFit
            self.toastIconImageView?.image = image
        }
        
        if let message = message {
            self.toastLabel = .init(frame: CGRect(origin: .zero, size: CGSize(width: 140, height: 40)))
            self.toastLabel?.textColor = tintColor
            self.toastLabel?.textAlignment = .center
            self.toastLabel?.numberOfLines = 2
            self.toastLabel?.adjustsFontSizeToFitWidth = true
            self.toastLabel?.font = .boldSystemFont(ofSize: 17)
            self.toastLabel?.text = message
        }
        
        if image != nil, message != nil {
            self.toastView = self.toastView(size: CGSize(width: 160, height: 160))
            self.toastIconImageView?.center = CGPoint(x: view.center.x, y: view.center.y - 10)
            self.toastLabel?.center = CGPoint(x: view.center.x, y: view.center.y + 40)
        }else if image != nil {
            self.toastView = self.toastView(size: CGSize(width: 160, height: 160))
            self.toastIconImageView?.center = view.center
        }else if message != nil {
            self.toastView = self.toastView(size: CGSize(width: 160, height: 60))
            self.toastLabel?.center = view.center
        }else{
            return
        }
        
        self.toastView?.center = view.center
        self.addSubview(self.toastView!)
        
        if self.toastIconImageView != nil {
            self.addSubview(self.toastIconImageView!)
        }
        
        if self.toastLabel != nil {
            self.addSubview(self.toastLabel!)
        }
        
        view.addSubview(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.dismiss()
        }
    }
    
    @objc public func dismiss() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.toastView != nil {
                self.toastView?.removeFromSuperview()
                self.toastView = nil
            }
            if self.toastLabel != nil {
                self.toastLabel?.removeFromSuperview()
                self.toastLabel = nil
            }
            if self.toastIconImageView != nil {
                self.toastIconImageView?.removeFromSuperview()
                self.toastIconImageView = nil
            }
            self.removeFromSuperview()
        }
    }
    
    private func toastView(size:CGSize = CGSize(width: 160, height: 160)) -> UIVisualEffectView {
        let view:UIVisualEffectView = .init(frame: CGRect(origin: .zero, size: size))
        view.effect = UIBlurEffect(style: .prominent)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }
}
