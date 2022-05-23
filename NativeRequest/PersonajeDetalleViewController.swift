//
//  PersonajeDetalleViewController.swift
//  NativeRequest
//
//  Created by DISMOV on 14/05/22.
//

import UIKit

class PersonajeDetalleViewController: UIViewController {
    
    var personajeRecibido = [String: Any]()
    @IBOutlet weak var imagenPersonaje: UIImageView!
    @IBOutlet weak var nombrePersonaje: UILabel!
    @IBOutlet weak var especiePersonaje: UILabel!
    @IBOutlet weak var statusPersonaje: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(personajeRecibido)
        nombrePersonaje.text = personajeRecibido["name"] as? String
        especiePersonaje.text = personajeRecibido["species"] as? String
        statusPersonaje.text = personajeRecibido["status"] as? String
        
        let urlImage = personajeRecibido["image"] as! String
        if let url = URL(string: urlImage){
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, urlResponse, error in
                if error != nil {
                    print("Algo salió mal \(error?.localizedDescription ?? "")")
                    return
                }
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.imagenPersonaje.image = UIImage(data: imageData)
                    }
                }
            })
            task.resume()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
