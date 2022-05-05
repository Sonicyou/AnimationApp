//
//  CustomSpinnerView.swift
//  AnimationApp
//
//  Created by Artem Frolov on 12.04.2022.
//

import UIKit

final class CustomSpinnerSimple: UIView {
    enum Shape {
        case oval
        case square
        case triangle
    }

    // MARK: - Properties
    /// Объявляем нужные нам переменные для CAReplicatorLayer
    private lazy var replicatorLayer: CAReplicatorLayer = {
        let caLayer = CAReplicatorLayer()
        return caLayer
    }()

    /// и CAShapeLayer:
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()

    /// Переменная для названия анимации (используем ниже)
    private let keyAnimation = "opacityAnimation"
    var animationShape: Shape?
    let imageLayer = CALayer()


    // MARK: - Init

    convenience init(squareLength: CGFloat, mainBounds: CGRect, animationShape: Shape) {
        let rect = CGRect(origin: CGPoint(x: (mainBounds.width-squareLength)/2,
                                          y: (mainBounds.height-squareLength)/2),
                          size: CGSize(width: squareLength, height: squareLength))
        self.init(frame: rect)
        self.animationShape = animationShape
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // добавляем replicatorLayer на слой нашего класса:
        layer.addSublayer(replicatorLayer)

        // добавляем shapeLayer на replicatorLayer:
        replicatorLayer.addSublayer(imageLayer)
        replicatorLayer.addSublayer(shapeLayer)

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = min(bounds.width/2, bounds.height/2)
        let rect = CGRect(x: size/4, y: size/4, width: size/4, height: size/4)
        var path = UIBezierPath()
        switch animationShape {
        case .oval:
            path = UIBezierPath(ovalIn: rect)
            shapeLayer.path = path.cgPath
        case .square:
            path = UIBezierPath(rect: rect)
            shapeLayer.path = path.cgPath
//            let image = UIImage(systemName: "bolt.fill")
//            shapeLayer.fillColor = UIColor(patternImage: image!).cgColor

            imageLayer.contents =  UIImage(systemName: "bolt.fill")?.cgImage // Assign your image
            imageLayer.frame = rect
//
            imageLayer.mask = shapeLayer // Set the mask

        case .triangle:
            let tX = bounds.width/4
            let tY = bounds.height/4

            let pathTriangle = CGMutablePath()
            let startPoint = CGPoint(x: bounds.width/8, y: bounds.width/8)
            pathTriangle.move(to: startPoint)

            let point0 = startPoint.applying(.init(translationX: 0, y: tY / 2))
            pathTriangle.move(to: point0)

            let point1 = startPoint.applying(.init(translationX: tX, y: 0))
            pathTriangle.addLine(to: point1)

            let point2 = startPoint.applying(.init(translationX: tX, y: tY))
            pathTriangle.addLine(to: point2)

            pathTriangle.addLine(to: point0)
            shapeLayer.path = pathTriangle
        case .none:
            return
        }

        // Устанавливаем размеры для replicatorLayer
        replicatorLayer.frame = bounds
        replicatorLayer.position = CGPoint(x: size, y:  size)
    }

    // MARK: - Animation's public functions

    /// Функция для запуска анимации
    /// - Parameters:
    ///   - delay: Время анимации, чем меньше значение,
    /// тем быстрее будет анимация
    ///   - replicates: количество реплик, то есть экземляров класса replicatorLayer
    func startAnimation(delay: TimeInterval, replicates: Int) {
        replicatorLayer.instanceCount = replicates
        replicatorLayer.instanceDelay = delay
        // Определяем преобразование для реплики - следующая реплика будет
        // повернута на угол angle, относительно предыдущей
        let angle = CGFloat(2.0 * Double.pi) / CGFloat(replicates)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)

        // А далее сама анимация для нашего shapeLayer:
        shapeLayer.opacity = 0 // начальное значение прозрачности
        // анимация прозрачности:
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        // от какого значения (1 - непрозрачно, 0 полностью прозрачно)
        opacityAnimation.fromValue = 0.1
        opacityAnimation.toValue = 0.8 // до какого значения

        // продолжительность:
        opacityAnimation.duration = Double(replicates) * delay
        // повторять бесконечно:
        opacityAnimation.repeatCount = Float.infinity
        // добавляем анимацию к слою по ключу keyAnimation:
        shapeLayer.add(opacityAnimation, forKey: keyAnimation)
    }

    /// Функция остановки анимации - удаляем ее по ключу keyAnimation с нашего слоя
    func stopAnimation() {
        guard shapeLayer.animation(forKey: keyAnimation) != nil else {
            return
        }
        shapeLayer.removeAnimation(forKey: keyAnimation)
    }

    // MARK: - Deinit
    /// Останавливаем анимацию при деините экземпляра
    deinit {
        stopAnimation()
    }
}
