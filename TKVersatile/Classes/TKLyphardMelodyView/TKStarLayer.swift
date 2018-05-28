//
//  TKStarLayer.swift
//  Pods-TKVersatile_Example
//
//  Created by zhengxianda on 2018/5/16.
//

import UIKit

public class TKStarLayer: CAShapeLayer {
    
    let kStarAnimationKey: String = "TKStarAnimationKey"
    
    /// 星星风格
    public var starStyle: round = .round {
        didSet {
            path = TKStarPath(style: starStyle, size: frame.size).cgPath
        }
    }
    
    /// 星星位置、尺寸
    public override var frame: CGRect {
        didSet {
            path = TKStarPath(style: starStyle, size: frame.size).cgPath
        }
    }
    
    /// 星星闪烁频率
    public var frequency: Float = 5 {
        didSet {
            restart()
        }
    }
    
    /// 星星初始直径
    public var fromDiameter: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 星星目标直径
    public var toDiameter: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 星星初始透明度
    public var fromOpacity: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 星星目标透明度
    public var toOpacity: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 星星颜色
    public var color: CGColor = UIColor.white.cgColor {
        didSet {
            fillColor = color
            strokeColor = color.copy(alpha: 0.5)
        }
    }
    
    /// 初始化星星图层
    ///
    /// - Parameters:
    ///   - starStyle: 星星风格
    ///   - frame: 星星位置、尺寸
    ///   - frequency: 星星闪烁频率
    ///   - fromDiameter: 星星初始直径
    ///   - toDiameter: 星星目标直径
    ///   - fromOpacity: 星星初始透明度
    ///   - toOpacity: 星星目标透明度
    ///   - color: 星星颜色
    public convenience init(starStyle: TKStarPath.Style,
                            frame: CGRect,
                            frequency: Float = 5,
                            fromDiameter: Float = 0,
                            toDiameter: Float = 5,
                            fromOpacity: Float = 0,
                            toOpacity: Float = 0.6,
                            color: CGColor = UIColor.white.cgColor) {
        self.init()
        
        self.frame = CGRect(x: frame.midX - 0.5, y: frame.midY - 0.5, width: 1, height: 1)
        self.starStyle = starStyle
        self.frequency = frequency
        self.fromDiameter = fromDiameter
        self.toDiameter = toDiameter
        self.fromOpacity = fromOpacity
        self.toOpacity = toOpacity
        self.color = color
        
        path = TKStarPath(style: starStyle, size: self.frame.size).cgPath
        start()
        
        fillColor = color
    }
    
}

extension TKStarLayer {
    
    public func start() {
        guard animation(forKey: kStarAnimationKey) == nil else { return }
        add(TKFlickerAnimationGroup(frequency: frequency, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                                    fromScale: fromDiameter, toScale: toDiameter,
                                    fromOpacity: fromOpacity, toOpacity: toOpacity),
            forKey: kStarAnimationKey)
    }
    
    public func pause() {
        guard speed > 0.0 else { return }
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    public func resume() {
        guard timeOffset > 0.0 else { return }
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
    public func stop() {
        removeAnimation(forKey: kStarAnimationKey)
    }
    
    public func restart() {
        stop()
        start()
    }
}