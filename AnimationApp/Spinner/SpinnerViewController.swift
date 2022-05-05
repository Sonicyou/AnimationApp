//
//  SpinnerViewController.swift
//  AnimationApp
//
//  Created by Artem Frolov on 12.04.2022.
//

import UIKit

final class SpinnerViewController: UIViewController {
    // Спиннер - размер 100
    //    private lazy var spinner: CustomSpinnerSimple = {
    //        let spinner = CustomSpinnerSimple(squareLength: 50, mainBounds: <#T##CGRect#>)
    //        return spinner
    //    }()

    let stackView = UIStackView()
    let squareLengh = Int()
    let spinnerView = UIView()
    let buttonsView = UIView()
    var spinner = CustomSpinnerSimple()
    let delaySlider = UISlider()
    var delayTime = 0.04
    var duplicates = 15
    let shapeSegmentedControl = UISegmentedControl(items: ["Oval","Square","Triangle"])
    let duplicatesStepper = UIStepper()
    let duplicatesLabel = UILabel()
    let duplicatesStackView = UIStackView()


    // Во viewDidLoad добавляю спиннер  и стартую анимацию
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupLayout()
    }

    func setupAppearance() {
        [spinnerView,
         buttonsView].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .vertical
        stackView.spacing = 30.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        spinner = CustomSpinnerSimple(squareLength: 100, mainBounds: spinnerView.bounds, animationShape: .oval)
        spinner.startAnimation(delay: delayTime, replicates: duplicates)

        delaySlider.minimumValue = 0.015
        delaySlider.maximumValue = 0.08
        delaySlider.value = Float(delayTime)
        delaySlider.isContinuous = true
        delaySlider.maximumValueImage = UIImage.init(systemName: "tortoise.fill")
        delaySlider.minimumValueImage = UIImage.init(systemName: "hare.fill")
        delaySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        delaySlider.tintColor = UIColor.systemGreen

        shapeSegmentedControl.selectedSegmentIndex = 0
        shapeSegmentedControl.tintColor = UIColor.systemGreen
        shapeSegmentedControl.selectedSegmentTintColor = .systemGreen
        shapeSegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)

        duplicatesStepper.value = Double(duplicates)
        duplicatesStepper.stepValue = 5
        duplicatesStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)

        duplicatesLabel.translatesAutoresizingMaskIntoConstraints = false
        duplicatesLabel.text = "Duplicates:  \(duplicates)"
        duplicatesLabel.textAlignment = .left
        duplicatesLabel.font = UIFont.systemFont(ofSize: 24)

        duplicatesStackView.axis = .vertical
        duplicatesStackView.addSubview(duplicatesLabel)
        duplicatesStackView.addSubview(duplicatesStepper)


        buttonsView.addSubview(delaySlider)
        buttonsView.addSubview(shapeSegmentedControl)
        buttonsView.addSubview(duplicatesStackView)

        spinnerView.addSubview(spinner)

        view.addSubview(stackView)
    }

    func setupLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        delaySlider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        shapeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(delaySlider.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        duplicatesStackView.snp.makeConstraints {
            $0.top.equalTo(shapeSegmentedControl.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        duplicatesLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        duplicatesStepper.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

    }

    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        delayTime = Double(sender.value)
        spinner.stopAnimation()
        spinner.startAnimation(delay: TimeInterval(sender.value), replicates: duplicates)
    }

    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        spinner.stopAnimation()
        spinner.removeFromSuperview()

        switch sender.selectedSegmentIndex {
        case 0:
            spinner = CustomSpinnerSimple(squareLength: 100, mainBounds: spinnerView.bounds, animationShape: .oval)
        case 1:
            spinner.animationShape = .square
            spinner = CustomSpinnerSimple(squareLength: 100, mainBounds: spinnerView.bounds, animationShape: .square)
        case 2:
            spinner.animationShape = .triangle
            spinner = CustomSpinnerSimple(squareLength: 100, mainBounds: spinnerView.bounds, animationShape: .triangle)
        default:
            return
        }

        spinnerView.addSubview(spinner)

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        spinner.startAnimation(delay: delayTime, replicates: duplicates)
    }

    @objc func stepperValueChanged(_ sender:UIStepper!)
    {
        duplicates = Int(sender.value)
        duplicatesLabel.text = "Duplicates:  \(duplicates)"
        spinner.stopAnimation()
        spinner.startAnimation(delay: delayTime, replicates: duplicates)
    }
}
