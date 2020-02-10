//
//  ScannerVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

public class ScannerVC: UIViewController {
    
    
    public lazy var headerViewController:HeaderVC = .init()
    
    public lazy var cameraViewController:CameraVC = .init()
    
    /// 动画样式
    public var animationStyle:ScanAnimationStyle = .default {
        didSet{
            cameraViewController.animationStyle = animationStyle
        }
    }
    
    // 扫描框颜色
    public var scannerColor:UIColor = .red {
        didSet{
            cameraViewController.scannerColor = scannerColor
        }
    }
    
    public var scannerTips:String = ""{
        didSet{
            cameraViewController.scanView.tips = scannerTips
        }
    }
    
    /// `AVCaptureMetadataOutput` metadata object types.
    public var metadata = AVMetadataObject.ObjectType.metadata {
        didSet{
            cameraViewController.metadata = metadata
        }
    }
    
    public var successBlock:((String)->())?
    
    public var errorBlock:((Error)->())?
    
    /// 设置标题
    public override var title: String?{
        
        didSet{
            
            if navigationController == nil {
                headerViewController.title = title
            }
        }
        
    }
    
    /// 设置Present模式时关闭按钮的图片
    public var closeImage: UIImage?{
        
        didSet{
            
            if navigationController == nil {
                headerViewController.closeImage = closeImage ?? UIImage()
            }
        }
        
    }
    
    private func addRightBarAction() {
        let rightBar = UIBarButtonItem(title: "相册".localized(), style: .plain, target: self, action: #selector(rightBarAction(_:)))
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc
    private func rightBarAction(_ bar: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let controller = UIImagePickerController()
            controller.sourceType = .photoLibrary
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
            cameraViewController.stopCapturing()
        } else {
            Toast.showToast(text:"Read Photo Library failed! check your permission please!")
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addRightBarAction()
        setupUI()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraViewController.startCapturing()
    }
}

extension ScannerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let ciimage = CIImage(image: image)!
//        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: nil)
        if let fectures = detector?.features(in: ciimage) {
            if let fecture = fectures.first as? CIQRCodeFeature {
                successBlock?(fecture.messageString ?? "")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CustomMethod
extension ScannerVC{
    
    func setupUI() {
        
        if title == nil {
            title = "扫一扫".localized()
        }
        
        view.backgroundColor = .black
        
        headerViewController.delegate = self
        
        cameraViewController.metadata = metadata
        
        cameraViewController.animationStyle = animationStyle
        
        cameraViewController.delegate = self
        
        add(cameraViewController)
        
        if navigationController == nil {
            
            add(headerViewController)
            
            view.bringSubviewToFront(headerViewController.view)
        }
    }
    
    
    public func setupScanner(_ title:String? = nil, _ color:UIColor? = nil, _ style:ScanAnimationStyle? = nil, _ tips:String? = nil, _ success:@escaping ((String)->())){
        
        if title != nil {
            self.title = title
        }
        
        if color != nil {
            scannerColor = color!
        }
        
        if style != nil {
            animationStyle = style!
        }
        
        if tips != nil {
            scannerTips = tips!
        }
        
        successBlock = success
    }
}

// MARK: - HeaderViewControllerDelegate
extension ScannerVC:HeaderViewControllerDelegate{
    /// 点击关闭
    public func didClickedCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension ScannerVC: CameraViewControllerDelegate {
    func didOutput(_ code: String) {
        successBlock?(code)
    }
    
    func didReceiveError(_ error: Error) {
        errorBlock?(error)
    }
}
