//
//  HomeViewController.swift
//  Installation
//
//  Created by Zehra on 27.07.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModel.session)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewInstallation" {
            if let session = sender as? Session {
                let destinationVC = segue.destination as! NewInstallationViewController
                destinationVC.viewModel.session = session
            }
        }
    }
    
    @IBAction func newInstallationBtn(_ sender: Any) {
        performSegue(withIdentifier: "toNewInstallation", sender: viewModel.session)
    }
    
    @IBAction func faultInterventionBtn(_ sender: Any) {
        performSegue(withIdentifier: "toReinstallation", sender: nil)
    }
    
    @IBAction func reinstallationBtn(_ sender: Any) {
        performSegue(withIdentifier: "toReinstallation", sender: nil)
    }
    
    @IBAction func smsCommandBtn(_ sender: Any) {
        
    }
    
    @IBAction func exitTapped(_ sender: Any) {
        viewModel.userDefaults.removeObject(forKey: "username")
        viewModel.userDefaults.removeObject(forKey: "password")
        
        exit(-1)
    }

}
