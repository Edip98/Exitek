//
//  MoviesVC.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit
import OrderedCollections


class MoviesVC: UIViewController {
    
    private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites" }
    
    let titleTextField = CustomTextField(placeholder: "Title")
    let yearTextField = CustomTextField(placeholder: "Year")
    let addButton = CustomButton(backgroundColor: .systemBlue, title: "Add")
    let tableView = UITableView()
    
    var movies: OrderedSet<String> = []
    var textFieldPlaceholder = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleTextField()
        configureYearTextFieldd()
        configureAddButton()
        configureTableView()
        createDismissKeyboardGesture()
        if let data = defaults.object(forKey: Keys.favorites) as? [String] {
            movies.append(contentsOf: data)
        }
    }
    
    private func configureTitleTextField() {
        view.addSubview(titleTextField)
        titleTextField.delegate = self
        titleTextField.set(tag: 0, returnKeyType: .continue)
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureYearTextFieldd() {
        view.addSubview(yearTextField)
        yearTextField.delegate = self
        yearTextField.set(tag: 1, returnKeyType: .done)
        
        NSLayoutConstraint.activate([
            yearTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            yearTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            yearTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            yearTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: yearTextField.bottomAnchor, constant: 10),
            addButton.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func addButtonTapped() {
        guard let title = titleTextField.text, let year = yearTextField.text else { return }
        
        if title == "" || year == "" {
            presentAlertOnMainThread(title: "Please fill out all fields.", message: nil)
            return
        }
        
        if !movies.contains("\(title) \(year)") {
            
            movies.append("\(title) \(year)")
            defaults.set(Array(movies), forKey: Keys.favorites)
            
            let indexPath = IndexPath(row: movies.count - 1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            clearTextFields()
        } else {
            movies.append("\(title) \(year)")
            clearTextFields()
        }
    }
    
    private func clearTextFields() {
        titleTextField.text = ""
        yearTextField.text = ""
        yearTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: padding)
        ])
    }
    
    private func createDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}


extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseID, for: indexPath) as? MovieCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.set(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        movies.remove(at: indexPath.row)
        defaults.set(Array(movies), forKey: Keys.favorites)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
