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
    
    // imagePicker class
    var mImgPicker: UIImagePickerController!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        mImgPicker = UIImagePickerController()
        mImgPicker.delegate = self
        mImgPicker.allowsEditing = false
        
        txtWH.text = String(defWithHeight)
    }

    /**
    * Action, 點取 button '選取圖片庫'
    */
    @IBAction func actSelImg(sender: UIButton) {
        typeCut = switchType.selectedSegmentIndex
        
        if (txtWH.text!.isEqual("")) {
            txtWH.text = String(defWithHeight)
        }
        
        // 產生 UIImagePickerController, 選取圖片
        mImgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(mImgPicker, animated: true, completion:nil)
    }
    
    /**
     * Action, 點取 button '選擇相機
     */
    @IBAction func actCamera(sender: UIButton) {
        if (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
            mImgPicker.sourceType = UIImagePickerControllerSourceType.Camera
            mImgPicker.cameraCaptureMode = .Photo
            presentViewController(mImgPicker, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    /**
    * # Delegate
    * UIImagePickerController 的 protocol (implements)
    */
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        //let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let mCutImage: CutImage = CutImage()
        mCutImage.initWithImage(image)
        mCutImage.delegate = self
        mCutImage.scaleRation = 3.0 // 图片缩放的最大倍数
        mCutImage.clipType = typeCut
        mCutImage.radius = CGFloat(Int(txtWH.text!)!)
        
        picker.pushViewController(mCutImage, animated: true)
    }
    */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage pickImg: UIImage, editingInfo: [String : AnyObject]?) {
        // 選擇圖片後，執行第三方圖片處理
        dismissViewControllerAnimated(true, completion: {
            ()->Void in
            
            let mCutImage: CutImage = CutImage()
            mCutImage.delegate = self
            mCutImage.scaleRation = 3.0 // 图片缩放的最大倍数
            mCutImage.clipType = self.typeCut
            mCutImage.radius = CGFloat(Int(self.txtWH.text!)!)
            mCutImage.initWithImage(pickImg)

            self.presentViewController(mCutImage, animated: true, completion: nil)
        })
    }
    
    /**
     * # Delegate
     * UIImagePickerController 的 protocol (implements)
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    * # Delegate
    * ClipViewControllerDelegate, 實作 method
    */
    func ClipViewController(clipViewController: CutImage, FinishClipImage editImage: UIImage) {
        
        clipViewController.dismissViewControllerAnimated(true, completion: {self.imgTarget.image = editImage})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

