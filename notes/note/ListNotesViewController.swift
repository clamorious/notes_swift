//
//  ListNotesViewController.swift
//  notes
//
//  Created by Douglas Gelsleichter on 08/01/20.
//  Copyright © 2020 Douglas Gelsleichter. All rights reserved.
//

import Foundation
import PureLayout

class ListNotesViewController: UIViewController {
    
    private lazy var tableView: UITableView = UITableView.newAutoLayout()
    var items: [Note] = []
    
    private var buttonAdd: UIButton = {
        let view = UIButton.newAutoLayout()
        view.backgroundColor = .blue
        view.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        view.setTitle("+", for: .normal)
        
        return view
    }()
    
    func setupLayout() {
        buttonAdd.autoSetDimension(ALDimension.height, toSize:40)
        buttonAdd.autoMatch(ALDimension.width, to: .width, of: view)
        buttonAdd.autoPinEdge(toSuperviewMargin: .bottom)
    }
    
    override func viewDidLoad() {
        view.addSubview(buttonAdd)
        setupLayout()
        addTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadNotes()
    }
    
    func loadNotes() {
        NoteInteractor.fetchNotes(completationHandler: { [weak self] (noteList) in
            DispatchQueue.main.async {
                self?.items = noteList ?? []
                self?.tableView.reloadData()
            }
        })
    }
    
    @objc func addNote() {
        navigationController?.pushViewController(InsertViewController(), animated: true)
    }
    
    private func addTableView() {
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)

        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 70
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)

        tableView.autoPinEdge(toSuperviewEdge: .top)
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoPinEdge(.bottom, to:.top, of: buttonAdd)
        
        view.backgroundColor = .white   
    }
}

//MARK: - ListNotes  UITableViewDataSource
extension ListNotesViewController:  UITableViewDataSource {
    
    private var identifier: String {
        return "ListNotesViewController.identifier"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let note = self.items[indexPath.row]
        
        let text =  note.text ?? ""
        cell.textLabel?.text = text
        
        return cell
    }
    
    
}

//MARK: - ListNotes  UITableViewDelegate
extension ListNotesViewController:  UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.items[indexPath.row]
        
        let vc = InsertViewController(note)
        navigationController?.pushViewController(vc, animated: true)
    }
}
