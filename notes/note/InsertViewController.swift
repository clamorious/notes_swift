//
//  InsertViewController.swift
//  notes
//
//  Created by Douglas Gelsleichter on 07/01/20.
//  Copyright © 2020 Douglas Gelsleichter. All rights reserved.
//

import Foundation
import PureLayout

class InsertViewController: UIViewController {
    
   var didSetupConstraints = false

    private var mainContentView: UIView = {
        let view = UIView.newAutoLayout()
        
        return view
    }()
    
    private var line: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .black
        
        return view
    }()
    
    private var line2: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .black
        
        return view
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView.newAutoLayout()
        textView.isScrollEnabled = false
        return textView
    } ()
    
    private let button: UIButton = {
        let button = UIButton.newAutoLayout()
        button.layer.cornerRadius = 4
        button.backgroundColor = .blue
        
        button.setTitle("Salvar", for: .normal)
        
        return button
    }()
    
    var note:Note?
    convenience init(_ note:Note) {
        self.init()
        
        self.note = note
    }
    
    func setupAutoLayout() {
        mainContentView.autoAlignAxis(toSuperviewAxis: .horizontal)
        mainContentView.autoAlignAxis(toSuperviewAxis: .vertical)
        
        mainContentView.autoMatch(ALDimension.height, to: .height, of: view, withMultiplier: 0.9)
        mainContentView.autoMatch(ALDimension.width, to: .width, of: view, withMultiplier: 0.9)
    
        noteTextView.autoMatch(ALDimension.width, to: .width, of: mainContentView)
        noteTextView.autoPinEdge(toSuperviewMargin: .top)
        noteTextView.autoPinEdge(toSuperviewEdge: .left)
        noteTextView.autoPinEdge(toSuperviewEdge: .right)
       
        line.autoPinEdge(.top, to: .bottom, of: noteTextView)
        line.autoSetDimension(.height, toSize: 1.0)
        line.autoMatch(ALDimension.width, to: .width, of: noteTextView)
        
        button.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                               left: 10.0,
                                                               bottom: 10.0, right: 10.0), excludingEdge: .top)
        
       
        view.backgroundColor = .white
        
        let id = self.note?.id ?? 0
        if (id > 0) {
            navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(action))
        }
    }
    
    @objc func action(sender: UIBarButtonItem) {
        NoteInteractor.delete(self.note?.id ?? 0, completationHandler: { [weak self] (token) in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    override func viewDidLoad() {
        view.addSubview(mainContentView)
        
        mainContentView.addSubview(noteTextView)
        mainContentView.addSubview(line)
        mainContentView.addSubview(button)
        
        setupAutoLayout()
        
        noteTextView.text = self.note?.text
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
        
    @objc func login() {
        let note = noteTextView.text
        
        if note?.isEmpty ?? false {
            let alert = UIAlertController(title: "Alert", message: "Nota vazia", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if self.note != nil {
                NoteInteractor.update(self.note?.id ?? 0, note, completationHandler: { [weak self] (token) in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            } else {
                NoteInteractor.save(note, completationHandler: { [weak self] (token) in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
}
