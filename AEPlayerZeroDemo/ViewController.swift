//
//  ViewController.swift
//  AEPlayerZeroDemo
//
//  Created by rajeshwariu on 01/09/26.
//

import UIKit
import FirebaseCrashlytics

class ViewController: UIViewController {

    private struct CrashOption {
        let title: String
        let action: () -> Void
    }

    private lazy var crashOptions: [CrashOption] = [
        CrashOption(title: "Force Unwrap Nil", action: Self.crashForceUnwrap),
        CrashOption(title: "Array Out of Bounds", action: Self.crashArrayOutOfBounds),
        CrashOption(title: "Fatal Error", action: Self.crashFatalError),
        CrashOption(title: "Force Cast Failure", action: Self.crashForceCast),
        CrashOption(title: "Divide By Zero", action: Self.crashDivideByZero)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupButtons()
    }

    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])

        for (index, option) in crashOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            button.backgroundColor = .systemRed
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.tag = index
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.addTarget(self, action: #selector(crashButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc
    private func crashButtonTapped(_ sender: UIButton) {
        crashOptions[sender.tag].action()
    }

    private nonisolated static func crashForceUnwrap() {
        let value: Int? = nil
        guard let unwrappedValue = value else {
            Crashlytics.crashlytics().log("crashForceUnwrap: optional value was nil; skipped force unwrap")
            return
        }
        _ = unwrappedValue
    }

    private nonisolated static func crashArrayOutOfBounds() {
        let array = [1, 2, 3]
        _ = array[10]
    }

    private nonisolated static func crashFatalError() {
        fatalError("Manual crash triggered from button tap")
    }

    private nonisolated static func crashForceCast() {
        let value: Any = "not a number"
        _ = value as! Int
    }

    private nonisolated static func crashDivideByZero() {
        let numerator = 10
        // Route through an array so the compiler can't constant-fold the zero divisor.
        let zeroValues = [0]
        let denominator = zeroValues[0]
        _ = numerator / denominator
    }
}
