//
//  RevlumFilterViewController.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

class RevlumFilterViewController: UIViewController {
    private let iOSButton = UIButton()
    private let webButton = UIButton()

    init() {
        super.init(nibName: nil, bundle: nil)
        setUpViews()
        setUpConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }

    private func setUpViews() {
        iOSButton.setTitle("iOS", for: .normal)
        webButton.setTitle("Web", for: .normal)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            iOSButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            iOSButton.widthAnchor.constraint(equalToConstant: 100),
            iOSButton.heightAnchor.constraint(equalToConstant: 40),
            iOSButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            webButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            webButton.widthAnchor.constraint(equalToConstant: 100),
            webButton.heightAnchor.constraint(equalToConstant: 40),
            webButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
