//
//  ViewController.swift
//  test3
//
//  Created by Huy Vu on 10/2/23.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {

    @IBOutlet weak var imgUI2: UIImageView!
    var optionalString: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileManager = FileManager.default
            guard let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
             print("FVHBVFJVNJNFVF\(documentsFolderURL)")
    }

    @IBAction func button4(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary // You can use .camera for the camera
          imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Do something with the selected image
            imgUI2.image = selectedImage
            
            // Lưu ảnh vào Documents folder
            let fileManager = FileManager.default
            guard let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
//            let imageFileName = "selectedImage.jpg" // Tên tệp ảnh
            
            let imageFileNameBase = "selectedImage"
                    var imageFileName = "\(imageFileNameBase).jpg"
                    var count = 0
                    
                    // Kiểm tra nếu tệp ảnh đã tồn tại, tăng số thứ tự
            while fileManager.fileExists(atPath: documentsFolderURL.appendingPathComponent(imageFileName).path) {
                count += 1
                imageFileName = "\(imageFileNameBase)_\(count).jpg"
            }
    
            let imageURL = documentsFolderURL.appendingPathComponent(imageFileName)
            
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: imageURL)
                    print("Lưu ảnh thành công tại: \(imageURL)")
                    optionalString = imageURL.absoluteString
                    let userDefaults = UserDefaults(suiteName: "group.huy.test1")
                    
                    guard let text = optionalString, !text.isEmpty else {
                        return
                    }
                    
                    userDefaults?.setValue(text, forKey: "text")
                    WidgetCenter.shared.reloadAllTimelines()
                } catch {
                    print("Lỗi khi lưu ảnh: \(error.localizedDescription)")
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
