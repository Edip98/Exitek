//
//  MoviesVC.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit
import OrderedCollections

class MoviesVC: UIViewController {
    
    let titleTextField = CustomTextField(placeholder: "Title")
    let yearTextField = CustomTextField(placeholder: "Year")
    let addButton = CustomButton(backgroundColor: .systemBlue, title: "Add")
    let tableView = UITableView()
    
    var textFieldPlaceholder = ""
    var movies: OrderedSet<Movie> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTitleTextField()
        configureYearTextFieldd()
        configureAddButton()
        configureTableView()
        createDismissKeyboardGesture()
        movies = OrderedSet(CoreDataManager.shared.fetchMovie())
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
        inputValidationAndSaveMovie()
        titleTextField.text = ""
        yearTextField.text = ""
    }
    
    private func inputValidationAndSaveMovie() {
        guard let title = titleTextField.text, let year = yearTextField.text else { return }
        
        if title == "" || year == "" {
            titleTextField.text = title
            yearTextField.text = year
            presentAlertOnMainThread(title: "Please fill out all fields.", message: nil)
            return
        }

        CoreDataManager.shared.createMovie(title: title, year: Int(year) ?? 0)
        movies = OrderedSet(CoreDataManager.shared.fetchMovie())
        tableView.reloadSections([0], with: .automatic)
        
//        let indexPath = IndexPath(row: movies.count - 1, section: 0)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
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
    
            let movie = movies[indexPath.row]
            CoreDataManager.shared.deleteMovie(movie: movie, title: movie.title)
    
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
}


extension MoviesVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldPlaceholder = textField.placeholder ?? ""
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = textFieldPlaceholder
    }
}
