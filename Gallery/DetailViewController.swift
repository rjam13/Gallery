//
//  DetailViewController.swift
//  Gallery
//
//  Created by Rey Jairus Marasigan on 9/14/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var picture: PictureCaption?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let pictureToLoad = picture {
            if let pictureData = pictureToLoad.imageData {
                imageView.image = UIImage(data: pictureData)
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Caption", style: .plain, target: self, action: #selector(addCaption))
    }
    
    @objc func addCaption() {
        let ac = UIAlertController(title: "New caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak ac, weak self] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.picture!.caption = answer
            self?.title = answer
        })
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
