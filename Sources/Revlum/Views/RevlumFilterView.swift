//
//  RevlumFilterView.swift
//  
//
//  Created by Filip Varda on 20.06.2023..
//

import UIKit

protocol RevlumFilterDelegate: AnyObject {
    func filterSelected(type: FilterType)
    func sortSelected(sort: SortType)
}

enum FilterType {
    case ios
    case web
}

enum SortType {
    case highToLow
    case lowToHigh
}

class RevlumFilterView: UIView {
    private let iOSButton = UIButton()
    private let webButton = UIButton()

    weak var delegate: RevlumFilterDelegate?

    init(filterType: FilterType = .ios, sortType: SortType = .highToLow) {
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("Revlum does not support this initializer")
    }

    private func setUpViews() {
        iOSButton.setTitle("iOS", for: .normal)
        webButton.setTitle("Web", for: .normal)

        iOSButton.addTarget(self, action: #selector(iosButtonTapped), for: .touchUpInside)
        webButton.addTarget(self, action: #selector(webButtonTapped), for: .touchUpInside)

        iOSButton.translatesAutoresizingMaskIntoConstraints = false
        webButton.translatesAutoresizingMaskIntoConstraints = false

        addSubviews(iOSButton, webButton)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            iOSButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            iOSButton.widthAnchor.constraint(equalToConstant: 100),
            iOSButton.heightAnchor.constraint(equalToConstant: 40),
            iOSButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            webButton.topAnchor.constraint(equalTo: iOSButton.bottomAnchor, constant: 20),
            webButton.widthAnchor.constraint(equalToConstant: 100),
            webButton.heightAnchor.constraint(equalToConstant: 40),
            webButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func iosButtonTapped() {
        filterSelected(type: .ios)
    }

    @objc private func webButtonTapped() {
        filterSelected(type: .web)
    }

    private func filterSelected(type: FilterType) {
        switch type {
        case .ios:
            print("ios selected")
        case .web:
            print("web selected")
        }
        delegate?.filterSelected(type: type)
    }

    func closeFilter() {
        guard let superview = superview else { return }

        UIView.animate(withDuration: 0.5, animations: {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 290).isActive = true
            superview.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
