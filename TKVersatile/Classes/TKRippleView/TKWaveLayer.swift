//
//  TKWaveLayer.swift
//  Pods-TKVersatile_Example
//
//  Created by zhengxianda on 2018/5/28.
//

import Foundation

public class TKWaveLayer: CAShapeLayer {
    
    let kWaveAnimationKey: String = "TKWaveAnimationKey"
    
    /// 水波风格
    public var waveStyle: TKWaveStyle = .round {
        didSet {
            path = TKWavePath(style: waveStyle, size: frame.size).cgPath
        }
    }
    
    /// 水波位置、尺寸
    public override var frame: CGRect {
        didSet {
            path = TKWavePath(style: waveStyle, size: frame.size).cgPath
        }
    }
    
    /// 水波闪烁持续时间
    public var durationTime: Float = 5 {
        didSet {
            restart()
        }
    }
    
    /// 水波初始直径
    public var fromDiameter: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 水波目标直径
    public var toDiameter: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 水波初始透明度
    public var fromOpacity: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 水波目标透明度
    public var toOpacity: Float = 0 {
        didSet {
            restart()
        }
    }
    
    /// 水波颜色
    public var color: CGColor = UIColor.white.cgColor {
        didSet {
            fillColor = color
        }
    }
    
    /// 初始化水波图层
    ///
    /// - Parameters:
    ///   - waveStyle: 水波风格
    ///   - frame: 水波位置、尺寸
    ///   - durationTime: 水波闪烁持续时间
    ///   - fromDiameter: 水波初始直径
    ///   - toDiameter: 水波目标直径
    ///   - fromOpacity: 水波初始透明度
    ///   - toOpacity: 水波目标透明度
    ///   - color: 水波颜色
    public convenience init(waveStyle: TKWaveStyle,
                            frame: CGRect,
                            durationTime: Float = 5,
                            fromDiameter: Float = 0,
                            toDiameter: Float = 5,
                            fromOpacity: Float = 0,
                            toOpacity: Float = 0.6,
                            color: CGColor = UIColor.white.cgColor) {
        self.init()
        
        self.frame = CGRect(x: frame.midX - 0.5, y: frame.midY - 0.5, width: 1, height: 1)
        self.waveStyle = waveStyle
        self.durationTime = durationTime
        self.fromDiameter = fromDiameter
        self.toDiameter = toDiameter
        self.fromOpacity = fromOpacity
        self.toOpacity = toOpacity
        self.color = color
        
        path = TKWavePath(style: waveStyle, size: self.frame.size).cgPath
        start()
        
        fillColor = color
    }
    
}

extension TKWaveLayer {
    
    public func start() {
        guard animation(forKey: kWaveAnimationKey) == nil else { return }
        let animate = TKDiffusionAnimationGroup(durationTime: durationTime, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                                fromScale: fromDiameter, toScale: toDiameter,
                                                fromOpacity: fromOpacity, toOpacity: toOpacity)
        animate.delegate = self
        add(animate, forKey: kWaveAnimationKey)
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
        removeAnimation(forKey: kWaveAnimationKey)
    }
    
    public func restart() {
        stop()
        start()
    }
}

extension TKWaveLayer: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag && animation(forKey: kWaveAnimationKey) == anim {
            removeFromSuperlayer()
        }
    }
}
