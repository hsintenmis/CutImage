//
// 大頭照 UIImage, 
// 從圖庫選圖片，提供 圓形/方形 選取遮罩
// 自訂輸入 選取遮罩 尺寸
//

import UIKit
import Foundation

class Main: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ClipViewControllerDelegate {
    
    @IBOutlet weak var imgTarget: UIImageView!
    @IBOutlet weak var switchType: UISegmentedControl!
    @IBOutlet weak var txtWH: UITextField!
    
    let defWithHeight = 150;
    var typeCut: Int = 0; // 0=圓, 1=方
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        txtWH.text = String(defWithHeight)
    }

    /**
    * Action, 點取 button '選取圖片'
    */
    @IBAction func actSelImg(sender: UIButton) {
        typeCut = switchType.selectedSegmentIndex
        
        if (txtWH.text!.isEqual("")) {
            txtWH.text = String(defWithHeight)
        }
        
        // 產生 UIImagePickerController, 選取圖片
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion:nil)
    }
    
    /**
    * UIImagePickerController 的 protocol (implements)
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        //print(image.imageOrientation)
        
        let mCutImage: CutImage = CutImage()
        mCutImage.delegate = self
        mCutImage.initWithImage(image)
        mCutImage.clipType = typeCut
        mCutImage.radius = CGFloat(Int(txtWH.text!)!)
        mCutImage.scaleRation = 2.0
        
        picker.pushViewController(mCutImage, animated: true)
    }
    
    /**
    * ClipViewControllerDelegate, 實作 method
    */
    func ClipViewController(clipViewController: CutImage, FinishClipImage editImage: UIImage) {
        
        clipViewController.dismissViewControllerAnimated(true, completion: {self.imgTarget.image = editImage})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

