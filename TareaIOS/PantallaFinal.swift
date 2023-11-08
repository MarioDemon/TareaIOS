//
//  PantallaFinal.swift
//  TareaIOS
//
//  Created by user208099 on 18/10/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class PantallaFinal: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var TablaBase: UITableView!
    @IBOutlet weak var textoPunt: UILabel!
    @IBOutlet weak var textoresult: UILabel!
    struct Puntuacion {
        var puntos: Int
    }
    
    var puntuaciones = [Puntuacion]()  // Array para almacenar las puntuaciones

        override func viewDidLoad() {
            super.viewDidLoad()
            updateScoreFinal()
            result()
            
            // Configura la fuente de datos y el delegado del UITableView
            TablaBase.dataSource = self
            TablaBase.delegate = self
            
            // Llama a la función para cargar las puntuaciones desde Firebase
            cargarPuntuaciones()
        }

        func updateScoreFinal() {
            textoPunt.text = "Puntuación: \(score)"
        }
            
        func result() {
            if score == 6 {
                textoresult.text = "Has Ganado"
            } else {
                textoresult.text = "Has Perdido"
            }
        }

    func cargarPuntuaciones() {
        // Accede a Firestore y recupera las puntuaciones
        let db = Firestore.firestore()
        let puntuacionesRef = db.collection("puntuaciones")
        
        puntuacionesRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error al obtener las puntuaciones: \(error.localizedDescription)")
            } else {
                // Procesa los documentos obtenidos y agrega las puntuaciones al array
                for document in snapshot!.documents {
                    if let puntos = document.data()["puntos"] as? Int {
                        let puntuacion = Puntuacion(puntos: puntos)
                        self.puntuaciones.append(puntuacion)
                    }
                }
                
                // Ordena el arreglo por la propiedad 'puntos' en orden ascendente
                self.puntuaciones.sort { $0.puntos > $1.puntos }
                
                // Actualiza la tabla para mostrar las puntuaciones ordenadas
                self.TablaBase.reloadData()
            }
        }
    }

        // Implementa los métodos del UITableViewDataSource para configurar la celda
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return puntuaciones.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "puntuacionCell", for: indexPath)
            let puntuacion = puntuaciones[indexPath.row]
            cell.textLabel?.text = "Puntos: \(puntuacion.puntos)"
            return cell
        }
    }

