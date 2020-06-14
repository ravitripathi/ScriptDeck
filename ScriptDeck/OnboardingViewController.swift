//
//  OnboardingViewController.swift
//  ScriptDeck
//
//  Created by Ravi Tripathi on 14/06/20.
//

import Cocoa

class OnboardingViewController: NSPageController, NSPageControllerDelegate {

    private var imagesUrls = ["https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step1.pdf",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step2.png",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step3.png",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step4.gif",
    "https://github.com/ravitripathi/ScriptDeck/raw/master/RemoteAssets/step5.png"]
    @IBOutlet weak var imageView: NSImageView!
    
    
//    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
//        <#code#>
//    }
//
//    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
//        <#code#>
//    }
//
//    //Gets an object from arranged objects
//    func pageController(pageController: NSPageController, identifierForObject object: AnyObject) -> String {
//        let image = object as! NSImage
//        let image_name = image.name()!
//        let temp = pageController.indexOf({$0.name == image_name})
//        return "\(temp!)"
//    }
//
//    func pageController(pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
//        let controller = NSViewController()
//        let imageView = NSImageView(frame: imageView.frame)
//        let intid = Int(identifier)
//        let intid_u = intid!
//        imageView.image = images[intid_u]
//        imageView.sizeToFit()
//        controller.view = imageView
//        return controller
//        // Does this eventually lose the frame since we're returning the new view and then not storing it and the original ImageView is long gone by then?
//        // Alternatively, are we not sizing the imageView appropriately?
//    }
    
    func pageControllerWillStartLiveTransition(_ pageController: NSPageController) {
        print(pageController.selectedIndex)
        imageView.setImageFromURl(ImageUrl: imagesUrls[pageController.selectedIndex])
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangedObjects = imagesUrls
        imageView.setImageFromURl(ImageUrl: imagesUrls.first!)
        delegate = self
    }
}
