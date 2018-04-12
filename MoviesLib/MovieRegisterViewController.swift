//
//  MovieRegisterViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 09/04/18.
//  Copyright © 2018 EricBrito. All rights reserved.
//

import UIKit

class MovieRegisterViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    var movie: Movie?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie != nil {
            tfTitle.text = movie!.title
            tfRating.text = "\(movie?.rating ?? 0)"
            tvSummary.text = movie?.summary
            tfDuration.text = movie?.duration
            if let poster = movie?.poster {
                ivPoster.image = poster
            }
            btAddUpdate.setTitle("Atualizar", for: .normal)
        } else {
            movie = Movie(context: context)            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if movie == nil {
            movie = Movie(context: context)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let categories = movie?.categories {
            lbCategories.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CategoriesViewController {
            vc.movie = movie
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func addPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde voçe quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Bibliotca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUpdateMovie(_ sender: UIButton) {
        
        movie?.title = tfTitle.text
        movie?.rating = Double(tfRating.text!)!
        movie?.duration = tfDuration.text
        movie?.summary = tvSummary.text
        movie?.poster = image
        
        do {
            try context.save()
            close(sender)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

extension MovieRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //self.image = image
            
            //para redimensionar a imagem
            let size = CGSize(width: 640, height: 480)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            ivPoster.image = self.image
        }
        
        dismiss(animated: true, completion: nil)
    }
}



