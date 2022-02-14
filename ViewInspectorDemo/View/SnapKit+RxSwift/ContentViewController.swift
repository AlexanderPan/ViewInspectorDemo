//
//  ContentViewController.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/10.
//

import UIKit
import SnapKit

class ContentViewController: UIViewController {

    private let viewModel: ContentRxSwiftViewModel = .init()

    private lazy var topView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var textField: UITextField = {
        let textField: UITextField = .init()
        textField.text = "alex"
        textField.textColor = .white
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button: UIButton = .init()
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.handleSearchButtonClick(button:)), for: .touchUpInside)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let view: UIScrollView = .init()
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view: UIStackView = .init()
        view.alignment = .fill
        view.distribution = .fillEqually
        view.axis = .vertical
        view.spacing = 16
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        view.backgroundColor = .white
        view.addSubview(topView)
        topView.addSubview(textField)
        topView.addSubview(searchButton)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        topView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
        }

        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(searchButton.snp.left).offset(-16)
        }

        searchButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }

        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(self.view)
        }

    }

    @objc func handleSearchButtonClick(button:UIButton) {

        self.viewModel.search(name: self.textField.text).subscribe(onSuccess: { [weak self] viewObjects in
            guard let self = self else { return }

            for arrangedSubview in self.stackView.arrangedSubviews {
                arrangedSubview.removeFromSuperview()
            }

            for viewObject in viewObjects {
                let label = UILabel.init()
                label.numberOfLines = 0
                label.text = viewObject.text
                label.accessibilityIdentifier = viewObject.id
                self.stackView.addArrangedSubview(label)
            }

        }).disposed(by: self.viewModel.disposeBag)

    }

}
