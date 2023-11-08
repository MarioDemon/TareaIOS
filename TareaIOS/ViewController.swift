//
//  ViewController.swift
//  TareaIOS
//
//  Created by user208099 on 18/10/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


var score = 0
class ViewController: UIViewController {

    var currentIndex = 0
    var imageTagsInOrder: [Int] = [1, 2, 3, 4, 5, 6]
    var expectedImageTag: Int = 1
    
    //Texto de puntuacion
    @IBOutlet weak var scoreLabel: UILabel!
    
    //Botones de elegir orden
    @IBOutlet weak var boton1: UIButton!
    @IBOutlet weak var boton2: UIButton!
    @IBOutlet weak var boton3: UIButton!
    @IBOutlet weak var boton4: UIButton!
    @IBOutlet weak var boton5: UIButton!
    @IBOutlet weak var boton6: UIButton!
    
    //Boton de play
    @IBOutlet weak var boton7: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            FirebaseApp.configure()//Inicia la base de datos
            updateScoreLabel()//Actualiza los puntos
            randomizeImageViewOrder()//Randomizar Orden Img

            // Deshabilita los botones usando las propiedades @IBOutlet
            boton1.isEnabled = false
            boton2.isEnabled = false
            boton3.isEnabled = false
            boton4.isEnabled = false
            boton5.isEnabled = false
            boton6.isEnabled = false
            boton7.isEnabled = true
        }
    func randomizeImageViewOrder() {//Randomizar las imagenes
        
        imageTagsInOrder = imageTagsInOrder.shuffled()
        for (index, tag) in imageTagsInOrder.enumerated() {
            if let imageView = view.viewWithTag(tag) as? UIImageView {
                imageView.frame = calculateImageViewFrame(at: index)
            }
        }
        expectedImageTag = imageTagsInOrder.first ?? 1
        
    }

    func calculateImageViewFrame(at index: Int) -> CGRect {//Carlcular el tamaño de imagen para ponerlas en fila
        let imageSize = CGSize(width: 60, height: 60)
        let spacing = CGFloat(3)
        let totalWidth = CGFloat(imageTagsInOrder.count) * (imageSize.width + spacing) - spacing
        let xOrigin = (self.view.frame.width - totalWidth) / 2 + (imageSize.width + spacing) * CGFloat(index)
        let yOffset: CGFloat = 150
        return CGRect(origin: CGPoint(x: xOrigin, y: yOffset), size: imageSize)
    }

    @IBAction func reorganizeImagesButtonTapped(_ sender: UIButton) {//Boton de play
        for tag in 1...6 {//Selecciona imagenes del tag 1 al 6
                if let imageView = view.viewWithTag(tag) as? UIImageView {
                    imageView.isHidden = true
                }
            }
                boton1.isEnabled = true
                boton2.isEnabled = true
                boton3.isEnabled = true
                boton4.isEnabled = true
                boton5.isEnabled = true
                boton6.isEnabled = true
                boton7.isEnabled = false
    }

    @IBAction func buttonTapped(_ sender: UIButton) {//Conectar botones con imagenes
        if sender.tag == expectedImageTag {
            score += 1
            currentIndex += 1
            if currentIndex < imageTagsInOrder.count {
                expectedImageTag = imageTagsInOrder[currentIndex]
            } else {                                            //Si llegas a 6 puntos
                let db = Firestore.firestore()
                        let puntuacion = score // puntuación que deseas guardar
                        let puntuacionesRef = db.collection("puntuaciones")
                        
                        puntuacionesRef.addDocument(data: ["puntos": puntuacion]) { (error) in
                            if let error = error {
                                print("Error al guardar la puntuación: \(error.localizedDescription)")
                            } else {
                                print("Puntuación guardada con éxito")
                            }
                        }
                
                for tag in 1...6 {//Selecciona imagenes del tag 1 al 6
                        if let imageView = view.viewWithTag(tag) as? UIImageView {
                            imageView.isHidden = false
                        }
                    }
                performSegue(withIdentifier: "Cambio", sender: self)
            }
            updateScoreLabel()
            
        }else{                                                    //Si fallas
            
            for tag in 1...6 {//Selecciona imagenes del tag 1 al 6
                    if let imageView = view.viewWithTag(tag) as? UIImageView {
                        imageView.isHidden = false
                    }
                }
                    boton1.isEnabled = false
                    boton2.isEnabled = false
                    boton3.isEnabled = false
                    boton4.isEnabled = false
                    boton5.isEnabled = false
                    boton6.isEnabled = false
            
            let db = Firestore.firestore()//Guardar la puntucaion en la base de datos
                    let puntuacion = score // puntuación que deseas guardar
                    let puntuacionesRef = db.collection("puntuaciones")
                    
                    puntuacionesRef.addDocument(data: ["puntos": puntuacion]) { (error) in
                        if let error = error {
                            print("Error al guardar la puntuación: \(error.localizedDescription)")
                        } else {
                            print("Puntuación guardada con éxito")
                        }
                    }
            performSegue(withIdentifier: "Cambio", sender: self)
            
        }
    }
    func updateScoreLabel() {//Actualizar el score
        scoreLabel.text = "Puntuación: \(score)"
    }
    @IBAction func botonvolver(_ sender: UIButton) {//Boton volver a jugar
        currentIndex = 0
        randomizeImageViewOrder()
        score = 0
        updateScoreLabel()
        boton7.isEnabled = true
        boton1.isEnabled = false
        boton2.isEnabled = false
        boton3.isEnabled = false
        boton4.isEnabled = false
        boton5.isEnabled = false
        boton6.isEnabled = false
        for tag in 1...6 {//Selecciona imagenes del tag 1 al 6
                if let imageView = view.viewWithTag(tag) as? UIImageView {
                    imageView.isHidden = false
                }
            }
    }
}

    
    




