//
//  AddWishCell.swift
//  maprozorskiyPW2
//
//  Created by Михаил Прозорский on 11.11.2023.
//

import UIKit

final class AddWishCell: UITableViewCell {
    static let reuseId: String = "AddCell"
    
    private var btnAdd = UIButton()
    private var txtInput = UITextView()
    
    var delegate: wishDelegate!
    
    private enum Constants {
        static let wrapColor: UIColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        static let wrapRadius: CGFloat = 16
        static let height: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
        static let diff = 0.5
        static let zero = 0.0
        static let textSize = 18.0
        static let buttonTextSize = 24.0
        static let coeff = 0.2
        static let two = 2.0
        
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(txtInput)
        
        txtInput.font = .systemFont(ofSize: Constants.textSize, weight: .regular)
        let color = UIColor(
            red: ((backColor.cgColor.components![0] >= Constants.diff) ? backColor.cgColor.components![0] - Constants.diff : backColor.cgColor.components![0] + Constants.diff),
            green: ((backColor.cgColor.components![1] >= Constants.diff) ? backColor.cgColor.components![1] - Constants.diff : backColor.cgColor.components![1] + Constants.diff),
            blue: ((backColor.cgColor.components![2] >= Constants.diff) ? backColor.cgColor.components![2] - Constants.diff : backColor.cgColor.components![2] + Constants.diff),
            alpha: 1)
        txtInput.textColor = color
        txtInput.backgroundColor = .clear
        txtInput.pinHeight(to: contentView, Constants.diff)
        txtInput.pinHorizontal(to: contentView, Constants.wrapOffsetH)
        
        contentView.addSubview(btnAdd)
        
        btnAdd.backgroundColor = .white
        btnAdd.pinRight(to: contentView)
        btnAdd.pinWidth(to: contentView)
        btnAdd.pinHeight(to: contentView, Constants.coeff)
        btnAdd.pinCenterX(to: contentView)
        btnAdd.pinBottom(to: contentView)
        btnAdd.setTitle("Add your dream", for: .normal)
        btnAdd.titleLabel?.font = .systemFont(ofSize: Constants.buttonTextSize, weight: .bold)
        btnAdd.setTitleColor(.black, for: .normal)
        
        btnAdd.layer.cornerRadius = Constants.wrapRadius
        btnAdd.layer.borderWidth = Constants.two
        btnAdd.layer.borderColor = UIColor.black.cgColor
        btnAdd.clipsToBounds = true
        
        btnAdd.addTarget(self, action: #selector(onClickAddButton(_:)),
                         for: .touchUpInside)
        btnAdd.isEnabled = true
    }
    
    @objc
    func onClickAddButton(_ sender: Any) {
        if let txt = txtInput.text, !txt.isEmpty {
            delegate.wishAdd(wish: txt)
            txtInput.text = ""
        }
    }
}
