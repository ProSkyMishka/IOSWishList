//
//  WishStoringViewController.swift
//  maprozorskiyPW2
//
//  Created by Михаил Прозорский on 10.11.2023.
//

import UIKit

final class WishStoringViewController: UIViewController
{
    enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: Double = 20
        static let diff = 0.1
        static let zero: CGFloat = 0
        static let count = 2
        static let one = 1
        static let width = 3.0
        static let coeff1 = 0.93
        static let coeff2 = 50.0
        static let lenght = 40.0
        static let wishesKey: String = ""
    }
    
    private let defaults = UserDefaults.standard
    private var wishArray: [String] = []
    private let table: UITableView = UITableView(frame: .zero)
    private let popUp = UIView()
    private let text = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishArray = (defaults.array(forKey: Constants.wishesKey) as? [String] ?? [])
        view.backgroundColor = backColor
        configureTable()
    }
    
    private func configureTable() {
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        view.addSubview(table)
        table.backgroundColor = UIColor(
            red: ((backColor.cgColor.components![0] != Constants.zero) ? backColor.cgColor.components![0] - Constants.diff : Constants.diff),
            green: ((backColor.cgColor.components![1] != Constants.zero) ? backColor.cgColor.components![1] - Constants.diff : Constants.diff),
            blue: ((backColor.cgColor.components![2] != Constants.zero) ? backColor.cgColor.components![2] - Constants.diff : Constants.diff),
            alpha: 1)
        table.keyboardDismissMode = .onDrag
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        table.pin(to: view, Constants.tableOffset)
    }
    
    private func handleDelete(indexPath: IndexPath) {
        wishArray.remove(at: indexPath.row)
        defaults.set(wishArray, forKey: Constants.wishesKey)
        table.reloadData()
    }
    
    var variant: IndexPath = []
    private func handleEdit(indexPath: IndexPath) {
        variant = indexPath
        let row = wishArray[indexPath.row]
        text.text = row
        self.view.addSubview(popUp)
        popUp.backgroundColor = .white
        popUp.layer.borderColor = UIColor.black.cgColor
        popUp.layer.borderWidth = Constants.width
        popUp.clipsToBounds = true
        popUp.layer.cornerRadius = Constants.tableCornerRadius
        popUp.pinCenterX(to: self.view)
        popUp.pinWidth(to: self.view, Double(Constants.one))
        popUp.pinHeight(to: self.view, Constants.coeff1)
        popUp.pinBottom(to: self.view)
        
        popUp.addSubview(text)
        text.pinCenterX(to: popUp)
        text.pinTop(to: popUp, Constants.coeff2)
        text.pinHorizontal(to: popUp, Constants.width)
        let ok = UIButton()
        let back = UIButton()
        ok.setTitle("ok", for: .normal)
        back.setTitle("back", for: .normal)
        popUp.addSubview(ok)
        popUp.addSubview(back)
        ok.backgroundColor = .green
        back.backgroundColor = .red
        ok.layer.cornerRadius = Constants.tableCornerRadius
        back.layer.cornerRadius = Constants.tableCornerRadius
        ok.setHeight(Constants.lenght)
        ok.setWidth(Constants.lenght)
        back.setHeight(Constants.lenght)
        back.setWidth(Constants.lenght)
        ok.pinTop(to: popUp, Constants.width)
        ok.pinRight(to: popUp, Constants.width)
        back.pinTop(to: popUp, Constants.width)
        back.pinLeft(to: popUp, Constants.width)
        popUp.isHidden = false
        ok.addTarget(self, action: #selector(buttonOkWasPressed), for: .touchUpInside)
        ok.isEnabled = true
        back.addTarget(self, action: #selector(buttonBackWasPressed), for: .touchUpInside)
        back.isEnabled = true
    }
    
    @objc
    func buttonOkWasPressed() {
        popUp.isHidden = true
        wishArray[variant.row] = text.text!
        defaults.set(wishArray, forKey: Constants.wishesKey)
        table.reloadData()
    }
    
    @objc
    func buttonBackWasPressed() {
        popUp.isHidden = true
    }
}

extension WishStoringViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in
            self?.handleEdit(indexPath: indexPath)
            completion(true)
        }
        editAction.image = UIImage(
            systemName: "square.and.pencil",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        editAction.backgroundColor = UIColor(red: 0.6, green: 1, blue: 0.6, alpha: 1)
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}

extension WishStoringViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        if (section == 0) {
            return "What are you dreaming about?"
        }
        else if (section == 1) {
            return "Here is a list of your dreams"
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return Constants.one
        }
        else {
            return wishArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == Int(Constants.zero)) {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddWishCell.reuseId,
                for: indexPath
            )
            guard let wishCell = cell as? AddWishCell else { return cell }
            wishCell.delegate = self
            return wishCell
        }
        let note = wishArray[indexPath.row]
        if let noteCell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as? WrittenWishCell {
            noteCell.configure(with: note)
            return noteCell
        }
        return UITableViewCell()
    }
}

protocol wishDelegate {
    func wishAdd(wish: String)
}

extension WishStoringViewController: wishDelegate {
    func wishAdd(wish: String) {
        wishArray.insert(wish, at: 0)
        defaults.set(wishArray, forKey: Constants.wishesKey)
        table.reloadData()
    }
}
