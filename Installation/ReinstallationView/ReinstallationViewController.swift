//
//  ReinstallationViewController.swift
//  Installation
//
//  Created by Zehra on 1.08.2022.
//

import UIKit

class ReinstallationViewController: UIViewController {

    @IBOutlet weak var imeiLabel: UITextField!
    
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designView()
        
        if let code = code {
            imeiLabel.text = code
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func openScannerBtn(_ sender: Any) {
        performSegue(withIdentifier: "toScanner", sender: nil)
    }
    
    @IBAction func controlImeiBtn(_ sender: Any) {
        
    }
    
    @IBAction func removeDeviceBtn(_ sender: Any) {
        
    }
}

// Helper
extension ReinstallationViewController {
    
    func designView() {
        
        [imeiLabel].forEach {
            $0?.delegate = self
            if #available(iOS 13.0, *) {
                $0?.overrideUserInterfaceStyle = .light
            }
        }
        
        navigationItem.hidesBackButton = true
        
        let navController = navigationController!
        let image = UIImage(named: "vektor")
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        let imageView = UIImageView(frame: CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
}

