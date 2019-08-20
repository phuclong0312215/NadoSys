//
//  function.swift
//  SkyWorth
//
//  Created by HappyDragon on 2/24/16.
//  Copyright © 2016 acacy. All rights reserved.
//

import UIKit
import AssetsLibrary

extension UIView{
    func setBorder(radius:CGFloat, color:UIColor = UIColor.clear) -> UIView{
        var roundView:UIView = self
        roundView.layer.cornerRadius = CGFloat(radius)
        roundView.layer.borderWidth = 1
        roundView.layer.borderColor = color.cgColor
        roundView.clipsToBounds = true
        return roundView
    }
}
extension UIImageView {
    
    func setRounded() {
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
extension UIButton {
    
    func setRounded(radius:CGFloat) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }
}
extension UITextField{
    @IBInspectable var placeholderColor: UIColor {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .lightText
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
        }
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension NSMutableData {
     func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension String {
    func toTarget() -> String{
        
        var str = ""
        var unit = ""
        if Double(self)! > 1000000000 {
            let value = Double(self)! / 1000000000
            let target = Decimal(round(10*value)/10)
            return "\(target) tỷ"
        }
        else if Double(self)! > 1000000 {
            let value = Double(self)! / 1000000
            let target = Decimal(round(10*value)/10)
            return "\(target) triệu"
        }
        else  if Double(self)! > 1000 {
            let value = Double(self)! / 1000
            let target = Decimal(round(10*value)/10)
            return "\(target) nghìn"
        }
        return self
        
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isValidContact: Bool {
        let phoneNumberRegex = "^[0]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        return date
    }
    func toDateString() -> String{
        let day = self.subString(startIndex: 0, endIndex: 1)
        let month = self.subString(startIndex: 2, endIndex: 3)
        let year = self.subString(startIndex: 4, endIndex: 7)
        return "\(year)-\(month)-\(day)"
    }
}

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}

extension UIButton {
    func setRounded() {
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
}
extension Date
{
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func getNameOfDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: self)
        return getNameDayVN(dayInWeek)
    }
    
    func getNameDayVN(_ name: String) -> String {
        switch name {
        case "Monday":
            return "T2"
        case "Tuesday":
            return "T3"
        case "Wednesday":
            return "T4"
        case "Thursday":
            return "T5"
        case "Friday":
            return "T6"
        case "Saturday":
            return "T7"
        default:
            return "CN"
        }
    }
    
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute,.month,.year,.day,.hour,.second], from: self)
        let hour = components.hour
        
        //Return Hour
        return hour!
    }
    func day() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute,.month,.year,.day,.hour,.second], from: self)
        let day = components.day
        
        //Return Hour
        return day!
    }
    func month() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute,.month,.year,.day,.hour,.second], from: self)
        let month = components.month
        
        //Return Hour
        return month!
    }
    func year() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute,.month,.year,.day,.hour,.second], from: self)
        let year = components.year
        
        //Return Hour
        return year!
    }
    
    func week() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.weekOfYear], from: self)
        let week = components.weekOfYear
        
        //Return Hour
        return week!
    }
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute,.month,.year,.day,.hour,.second], from: self)
        let minute = components.minute
        
        //Return Minute
        return minute!
    }
    func toIntShortDate() -> Int
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let timeString = formatter.string(from: self)
        
        return Int(timeString)!
    }
    
    func to() -> Int
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let timeString = formatter.string(from: self)
        
        return Int(timeString)!
    }
    
    func toLongDate() ->  String
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
        
    }
    func toImageName(_ employeeCode: String) ->  String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var timeString = formatter.string(from: self)
        timeString="\(employeeCode)"+"_IMAGE_"+String(toIntShortDate())+"_"+timeString
        //Return Short Time String
        return timeString
        
        
    }
    func toLongTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func toLongTimeStringUpload() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let timeString = formatter.string(from: self).substring(to: 19)
        
        //Return Short Time String
        return timeString
    }
}
class Function {
    static func firstDay(ofWeek week:Int, year: Int)->Date{
        let Calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dayComponent = DateComponents()
        dayComponent.weekOfYear = week
        dayComponent.weekday = 1
        dayComponent.year = year
        var date = Calendar.date(from: dayComponent)
        
        if(week == 1 && Calendar.components(.month, from: date!).month != 1){
            //print(Calendar.components(.month, from: date!).month)
            dayComponent.year = year - 1
            date = Calendar.date(from: dayComponent)
        }
        return date!
    }
    static func lastDay(ofMonth m: Int, year y: Int) -> Date {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        return cal.date(from: comps)!
       
    }
    static func firstDay(ofMonth m: Int, year y: Int) -> Date {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m,day: 1)
        return cal.date(from: comps)!
        
    }
    static func getJson(_ json: [Dictionary<String, AnyObject>]) -> Data{
        
        var jsonString:String = ""
        
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options:.prettyPrinted)
            jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            
        }
        catch let error as NSError{
            print(error.description)
        }
        print(jsonString)
        return jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        
    }
    
    static func Message(_ title:String,message:String){
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    static func checkTime(timeClient: Date,timeServer: Date) -> Bool{
        let minutes = timeClient.minute() - timeServer.minute()
        let day = timeClient.day() - timeServer.day()
        let hour = timeClient.hour() - timeServer.hour()
        if day == 0 && hour == 0 && minutes > -10 && minutes < 10 {
            return true
        }
        return false

    }
    static func resizeImage(_ image: UIImage!, newWidth: CGFloat,newHeight:CGFloat) -> UIImage {
        var newHeight = newHeight
        
        let scale = newWidth / image.size.width
        if newHeight == 0{
            newHeight = image.size.height * scale
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    static func convertToImage(cadenaImagen: String) -> UIImage? {
        var strings = cadenaImagen.components(separatedBy: ",")
        var bytes = [UInt8]()
        for i in 0 ..< strings.count {
            if let signedByte = Int8(strings[i]){
                bytes.append(UInt8(bitPattern: signedByte))
            }else{
                
            }
        }
        let data: Data = Data()
        let datos: Data = Data(bytes: bytes, count: bytes.count)
        return UIImage(data: datos) // Note it's optional. Don't force unwrap!!!
    }
    
    static func getPath(_ path: String) -> String{
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(path)
    }
    
    func getImageFromPath(_ path: String, onComplete:@escaping ((_ image: UIImage?) -> Void)) {
        let assetsLibrary = ALAssetsLibrary()
        let url = URL(string: path)!
        assetsLibrary.asset(for: url, resultBlock: { (asset) -> Void in
            if((asset) != nil){
                onComplete(UIImage(cgImage: (asset?.defaultRepresentation().fullResolutionImage().takeUnretainedValue())!))
            }
            else{
                onComplete(nil)
            }
        }, failureBlock: { (error) -> Void in
            onComplete(nil)
        })
    }
    
    func fixOrientation(_ image: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if (image.imageOrientation == UIImage.Orientation.up) { return image; }
        
        //println(image.imageOrientation)
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        
        switch (image.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case .up, .upMirrored:
            break
        }
        
        switch (image.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .up, .down, .left, .right:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: ((image.cgImage)?.bitsPerComponent)!, bytesPerRow: 0, space: ((image.cgImage)?.colorSpace!)!, bitmapInfo: ((image.cgImage)?.bitmapInfo.rawValue)!)
        
        ctx?.concatenate(transform);
        
        switch (image.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
            break
            
        default:
            ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            break
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx?.makeImage()
        let img = UIImage(cgImage: cgimg!)
        
        return img
    }
    static func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    static func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
        
    }
    
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    static func sqliteGetString(state:OpaquePointer,column:Int32)-> String{
        
//        let rowData1=sqlite3_column_text(state, column)
        var fieldValue1 = ""
//        if rowData1 != nil {
//            
//            // print(rowData1)
//            fieldValue1 = String(cString: rowData1!)
//            // fieldValue1 = String(CStr : UnsafePointer<CChar>(rowData1!))
//            // print(fieldValue1)
//        }
//        else {
//            fieldValue1=""
//        }
//        
        return fieldValue1
        
    }
    static func getDateFormater() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
   
   
}
