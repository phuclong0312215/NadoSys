//
//  TabDisplayViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 7/1/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit

class TabDisplayViewController: UIViewController {

    @IBOutlet weak var tabDisplay: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let item1 = UITabBarItem()
//        item1.image = self.makeThumbnailFromText(text: "AQUA")
//        item1.title =  nil
//        let item2 = UITabBarItem()
//        item2.image = self.makeThumbnailFromText(text: "SAMSUNG")
//        item2.title = nil
//        let item3 = UITabBarItem()
//        item3.image = self.makeThumbnailFromText(text: "PANASONIC")
//        item3.title = nil
//        let item4 = UITabBarItem()
//        item4.image = self.makeThumbnailFromText(text: "ELECTROLUX")
//        item4.title = nil
//        let item5 = UITabBarItem()
//        item5.image = self.makeThumbnailFromText(text: "SONY")
//        item5.title = nil
//        tabDisplay.items = [item1,item2,item3,item4,item5]
       // tabBarController.viewControllers = [vc1, vc2]
        // Do any additional setup after loading the view.
    }
    func makeThumbnailFromText(text: String) -> UIImage {
        // some variables that control the size of the image we create, what font to use, etc.
        
        struct LineOfText {
            var string: String
            var size: CGSize
        }
        
        let imageSize = CGSize(width: 100, height: 80)
        let fontSize: CGFloat = 13.0
        let fontName = "Helvetica-Bold"
        let font = UIFont(name: fontName, size: fontSize)!
        let lineSpacing = fontSize * 1.2
        
        // set up the context and the font
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let attributes = [NSAttributedString.Key.font: font]
        
        // some variables we use for figuring out the words in the string and how to arrange them on lines of text
        
        let words = text.components(separatedBy: " ")
        var lines = [LineOfText]()
        var lineThusFar: LineOfText?
        
        // let's figure out the lines by examining the size of the rendered text and seeing whether it fits or not and
        // figure out where we should break our lines (as well as using that to figure out how to center the text)
        
        for word in words {
            let currentLine = lineThusFar?.string == nil ? word : "\(lineThusFar!.string) \(word)"
            let size = currentLine.size(withAttributes: attributes)
            if size.width > imageSize.width && lineThusFar != nil {
                lines.append(lineThusFar!)
                lineThusFar = LineOfText(string: word, size: word.size(withAttributes: attributes))
            } else {
                lineThusFar = LineOfText(string: currentLine, size: size)
            }
        }
        if lineThusFar != nil { lines.append(lineThusFar!) }
        
        // now write the lines of text we figured out above
        
        let totalSize = CGFloat(lines.count - 1) * lineSpacing + fontSize
        let topMargin = (imageSize.height - totalSize) / 2.0
        
        for (index, line) in lines.enumerated() {
            let x = (imageSize.width - line.size.width) / 2.0
            let y = topMargin + CGFloat(index) * lineSpacing
            line.string.draw(at: CGPoint(x: x, y: y), withAttributes: attributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
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
