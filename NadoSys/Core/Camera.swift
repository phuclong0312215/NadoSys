//
//  Camera.swift
//  Aqua
//
//  Created by PHUCLONG on 7/19/17.
//  Copyright © 2017 PHUCLONG. All rights reserved.
//

import UIKit
protocol cameraProtocol {
    func ditReceiveImageUrl(imgUrl: String,imgName: String,imgData: Data,imgType: String,comment: String,latitude: Double,longitude: Double)
}

class Camera :NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var delegate: cameraProtocol?
    var picker = UIImagePickerController()
    var vController = UIViewController()
    var imgName: String = ""
    var imgType: String = ""
    var employeeCode: String = ""
    var comment: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    override init() {
        
    }
    init(view: UIViewController,comment: String,imgType: String,employeeCode: String,latitude: Double,longitude: Double) {
        self.vController = view
        self.imgType = imgType
        self.employeeCode = employeeCode
        self.comment = comment
        self.latitude = latitude
        self.longitude = longitude
    }
    func startCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let img=UIImagePickerController()
            img.sourceType = .camera
            
            img.delegate = self
            
            self.picker = img
            self.vController.present(self.picker, animated: true,completion:nil)
            
            
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
       
        let compressedJPGImage =  resizeImage(image: pickedImage,newWidth: 600)
        let imageData = Function().fixOrientation(compressedJPGImage)
        let data =  imageData.jpegData(compressionQuality: 0.5)
        let imgName = self.imgType + "_" + Date().toImageName(employeeCode) + ".jpg"
        let imageUrl = saveImageDocumentDirectory(imgName, imgData: data!)
        delegate?.ditReceiveImageUrl(imgUrl: imageUrl,imgName:imgName,imgData: data!,imgType: self.imgType,comment: comment, latitude: self.latitude, longitude: self.longitude)
        
        self.vController.dismiss(animated: true, completion: nil)

    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func saveImageDocumentDirectory(_ imgName: String,imgData: Data) -> String{
        let fileManager = FileManager.default
        
        let directory = createDirectory()
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directory + "/" + imgName)
        //print(paths)
        fileManager.createFile(atPath: paths as String, contents: imgData, attributes: nil)
        return "ImageUpload/"+String(Date().toIntShortDate())+"/"+imgName
    }
    func createDirectory() -> String{
        let fileManager = FileManager.default
        let directory = "ImageUpload/"+String(Date().toIntShortDate())
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(directory)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
        return directory
    }

    
}
