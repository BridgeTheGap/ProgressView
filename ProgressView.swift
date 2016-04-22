//
//  Progress View
//  Progress View
//
//  Created by Joshua Park on 4/20/16.
//  Copyright © 2016 Joshua Park. All rights reserved.
//

import UIKit

enum ProgressBarDirection {
    case Horizontal
    case Vertical
}

extension UIView {
    func addProgressBar(value: Double, color: UIColor, name: String?, direction: ProgressBarDirection) {
        self.layer.masksToBounds = true
        
        let progressLayer = CALayer()
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        if direction == .Horizontal {
            progressLayer.frame = CGRectMake(0.0, 0.0, width * CGFloat(value), height)
        } else {
            let barHeight = height * CGFloat(value)
            progressLayer.frame = CGRectMake(0.0, height - barHeight, width, barHeight)
        }
        progressLayer.backgroundColor = color.CGColor
        progressLayer.name = name
        
        self.layer.addSublayer(progressLayer)
    }
    
    func setCompleted(completed: Int, achievement: Int, direction: ProgressBarDirection) {
        self.addProgressBar(Double(completed) / 100.0, color: UIColor(rgba: 160, 230, 255, 1), name: "completed", direction: direction)
        self.addProgressBar(Double(achievement) / 100.0, color: UIColor(rgba: 57, 213, 121, 1), name: "achievement", direction: direction)
    }
    
    func getProgressBar(name: String) -> CALayer? {
        if let layer = self.layer.sublayerWithName(name) {
            return layer
        }
        return nil
    }
    
    func setProgressBarColor(locked: Bool, selected: Bool) {
        if let achievement = self.getProgressBar("achievement"), let completed = self.getProgressBar("completed") {
            if locked {
                if selected {
                    achievement.backgroundColor = UIColor(rgba: 190, 245, 200, 1).CGColor
                    completed.backgroundColor = UIColor(rgba: 220, 250, 255, 1).CGColor
                } else {
                    achievement.backgroundColor = UIColor(rgba: 246, 250, 231, 1).CGColor
                    completed.backgroundColor = UIColor(rgba: 236, 246, 251, 1).CGColor
                }
            } else {
                achievement.backgroundColor = UIColor(rgba: 57, 213, 121, 1).CGColor
                completed.backgroundColor = UIColor(rgba: 160, 230, 255, 1).CGColor
            }
        }
    }
    
    func setProgressValue(progress: CGFloat, name: String, direction: ProgressBarDirection) {
        assert(progress <= 1.0, "Invalid progress value. Progress value must be <= 1.0")
        guard let bar = self.getProgressBar(name) else {
            fatalError("Invalid name for progress bar: \(name)")
        }
        
        if direction == .Horizontal {
            bar.frame = CGRectMake(0.0, 0.0, self.bounds.width * progress, self.bounds.height)
        } else {
            let height = self.bounds.size.height * progress
            let y = self.bounds.height - height
            
            bar.frame = CGRectMake(0.0, y, self.bounds.width, height)
        }
        
        if name == "completed" { self.layer.insertSublayer(bar, atIndex: 0) }
        else { self.layer.insertSublayer(bar, atIndex: 1) }
    }
}

extension CALayer {
    func sublayerWithName(name: String) -> CALayer? {
        if let sublayers = self.sublayers {
            for layer in sublayers {
                if layer.name == name {
                    return layer
                }
            }
        }
        return nil
    }
}