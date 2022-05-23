//
//  ViewController.swift
//  NativeRequest
//
//  Created by DISMOV on 13/05/22.
//

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let dict = personajes[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String ?? "Un personaje"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "personajeR&M", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personajeR&M"{
            // Get the new view controller using segue.destination.
            let destination = segue.destination as? PersonajeDetalleViewController
            // Pass the selected object to the new view controller.
            destination?.personajeRecibido = personajes[tableView.indexPathForSelectedRow!.row]
        }
    }
}

class ViewController: UIViewController {
    
    var tableView = UITableView()
    var personajes = [[String:Any]]()
    var reuseIdentifier = "reuseId"

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = InternetStatus.instance
        // Do any additional setup after loading the view.
        tableView.frame = self.view.bounds
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if InternetStatus.instance.internetType == .none {
            let alert = UIAlertController(title: "ERROR!", message: "No hay conexión a internet", preferredStyle: .alert)
            let boton = UIAlertAction(title: "OK", style: .default) {alert in
                exit(666)
            }
            alert.addAction(boton)
            self.present(alert, animated: true)
        } else if InternetStatus.instance.internetType == .cellular {
            let alert = UIAlertController(title: "Advertencia!", message: "Solo hay conexión con datos móviles, seguro que quieres continuar?", preferredStyle: .alert)
            let botonSi = UIAlertAction(title: "Sí", style: .default) {alert in
                self.descargar()
            }
            let botonNo = UIAlertAction(title: "No", style: .cancel)
            alert.addAction(botonSi)
            alert.addAction(botonNo)
            self.present(alert, animated: true)
        } else {
            self.descargar()
        }
    }

    func descargar() {
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            let task = sesion.dataTask(with: url, completionHandler: { data, urlResponse, error in
                if error != nil {
                    print("Algo salió mal \(error?.localizedDescription ?? "")")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as! [String : Any]
                    print(json)
                    self.personajes = json["results"] as! [[String: Any]]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Algo salió mal con el JSON \(error.localizedDescription)")
                }
            })
            task.resume()
        }
    }

}
