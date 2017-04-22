//
//  ViewController.swift
//  Open Library
//
//  Created by Alejandro on 09/04/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var code: UITextField!
   
    @IBOutlet weak var isbn: UILabel!
    @IBOutlet weak var portada: UILabel!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!

    
    
    override func viewDidLoad() {
       
        code.delegate = self
        self.code.tag = 0

       
                super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
   
    
    }
    
    @IBAction func textFieldDoneEditing(sender : UITextField)
    {
        sender.resignFirstResponder()
    
    }

    @IBAction func backgroundTap(sender: UIControl){
        code.resignFirstResponder()
        portada.resignFirstResponder()}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    private func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            recuperaDatosISBN(isbn: textField.text!)
        default: break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let currentTextField = textField
        
        currentTextField.becomeFirstResponder()
        
        recuperaDatosISBN(isbn: textField.text!)
        
        return true
    }

    func recuperaDatosISBN(isbn : String){
        
        
        var texto : String? = nil
        let urlStr = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        let url = NSURL(string: urlStr)
        if (url != nil){
            let datos:NSData? = NSData(contentsOf: url! as URL)
            
       
            do{
                let json = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let diccionarioDatos = json as! NSDictionary
                if ((diccionarioDatos["ISBN:"+isbn]) != nil){
                    let diccionarioDatosISBN = diccionarioDatos["ISBN:"+isbn] as! NSDictionary
                    
                    
                    let tituloLibro = diccionarioDatosISBN["title"] as! NSString
                    
                    texto = "Titulo: " + (tituloLibro as String) + "\n\r"
                    
                    let arrayDatosAutores : Array<NSDictionary> = diccionarioDatosISBN["authors"] as! Array<NSDictionary>
                    for i in 0 ..< arrayDatosAutores.count  {
                        texto = texto! + "Autor: " + (arrayDatosAutores[i]["name"] as! String) + "\n\r"
                    }
                    

                    if ((diccionarioDatosISBN["cover"]) != nil){
                        let diccionarioPortadaLibro = diccionarioDatosISBN["cover"] as! NSDictionary
                        let portadaPequenia = diccionarioPortadaLibro["large"] as! String
                        let url = URL(string: portadaPequenia)
                        let data = try? Data(contentsOf: url!)
                        self.image.image = UIImage(data: data!)
                    } else {
                        self.image.image = nil
                    }
                    
                }
            } catch _ {
            }
            
            if (texto == nil){
                texto = "No se ha podido establecer conexión con el servidor. Intentelo mas tarde."
                self.image.image = nil
            } else if (texto == "{}" || texto == ""){
                texto = "No se han encontrado coincidencias"
                self.image.image = nil            }
        } else {
            texto = "No se ha podido establecer conexión con el servidor. Intentelo mas tarde."
            self.image.image = nil
        }
        
        
        
        self.name.text = texto as String!
    }
    


}

