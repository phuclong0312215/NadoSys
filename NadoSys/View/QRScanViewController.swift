//
//  QRScanViewController.swift
//  NadoSys
//
//  Created by Nguyen Phuc Long on 6/22/19.
//  Copyright © 2019 Nguyen Phuc Long. All rights reserved.
//

import UIKit
protocol scanBarcodeDelegate {
    func getBarCode(_ barcode: String)
}
class QRScanViewController: UIViewController {

    var _delegate: scanBarcodeDelegate?
    var _barcode: String = ""
    @IBOutlet weak var qrscan: QRScannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrscan.delegate = self
        // Do any additional setup after loading the view.
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
extension QRScanViewController: QRScannerViewDelegate{
    func qrScanningDidFail() {
        Function.Message("Info", message: "Scan barcode fail")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self._barcode = str!
        _delegate?.getBarCode(self._barcode)
        guard(navigationController?.popViewController(animated: true)) != nil
            else{
                dismiss(animated: true, completion: nil)
                return
        }
    }
    
    func qrScanningDidStop() {
        
    }
    
    
}

