import Foundation
import UIKit
import AWSS3 //1

typealias progressBlock = (_ progress: Double) -> Void //2
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3

class AWSS3Manager {
    
    static let shared = AWSS3Manager() // 4
    private init () { }
    let bucketName = BUCKET_NAME //5
    
    // Upload image using UIImage object
    func uploadImage(image: UIImage, progress: progressBlock?, completion: completionBlock?) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }
        
        let tmpPath = NSTemporaryDirectory() as String
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: "image", progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
        }
    }
    
    // Upload video from local path url
    func uploadVideo(videoUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = "\(ProcessInfo.processInfo.globallyUniqueString).mp4"//self.getUniqueFileName(fileUrl: videoUrl) // "iosdone/" 
        self.uploadfile(fileUrl: videoUrl, fileName: fileName, contenType: "mov/mp4", progress: progress, completion: completion)
    }
    
    // Upload auido from local path url
    func uploadAudio(audioUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = audioUrl.lastPathComponent
        self.uploadfile(fileUrl: audioUrl, fileName: fileName, contenType: "audio", progress: progress, completion: completion)
    }
    
    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(BUCKET_NAME).appendingPathComponent(fileName)
                    
                        debugPrint("Uploaded to:\(String(describing: publicURL))")
                    if let response = task.response {
                        let fileURL = response.url
                        
                       debugPrint("Uploaded file URL: \(String(describing: fileURL))")
//                       debugPrint("Base URL: " + "https://d1g0ba8hbbwly8.cloudfront.net")
//                       debugPrint("Split URL: \(String(describing: response.url?.relativePath))")
                        
//                        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
//                        getPreSignedURLRequest.bucket = BUCKET_NAME
//                        getPreSignedURLRequest.key = fileName
//                        getPreSignedURLRequest.httpMethod = .GET
//                        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
//
//                        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
//                            if let error = task.error {
//                               debugPrint("AWSS3PreSignedURLBuilder Error: \(error)")
//                                return nil
//                            }
//
//                            let presignedURL = task.result
//                            let url:URL = URL(string : String(describing: presignedURL))!
//                           debugPrint("Get private url",presignedURL)
//                            return nil;
//                        }
                        if let completionBlock = completion {
                            completionBlock(response.url!.relativePath, nil)
                        }
                        
                    }
                    
                    // You can access the uploaded file URL using the task's response property
                    
                } else {
                   debugPrint(error?.localizedDescription ?? "")
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: fileName.mimeType(), expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
               debugPrint("error is: == \(error.localizedDescription)")
                            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    func dltImage(fileUrl : URL, progress: progressBlock?, completion: completionBlock?) {
        
        self.deletefile(fileUrl: fileUrl, fileName: "", contenType: "image", progress: progress, completion: completion)
    }
    
     func deletefile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                debugPrint(completionHandler as Any)
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(BUCKET_NAME).appendingPathComponent(fileName)
                    
                   debugPrint("Uploaded to:\(String(describing: publicURL))")
                    if let response = task.response {
                        let fileURL = response.url
                       debugPrint("Uploaded file URL: \(String(describing: fileURL))")
//                       debugPrint("Base URL: " + "https://d1g0ba8hbbwly8.cloudfront.net")
//                       debugPrint("Split URL: \(String(describing: response.url?.relativePath))")
                        if let completionBlock = completion {
                            completionBlock(response.url!.relativePath, nil)
                        }
                        
                    }
                    
                    // You can access the uploaded file URL using the task's response property
                    
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
       debugPrint("filename==",fileName)
       debugPrint("fileurl==",fileUrl)
       debugPrint("mimetype==",fileName.mimeType())

        
        let s3 = AWSS3.default()
        guard let deleteObjectRequest = AWSS3DeleteObjectRequest() else {
            return
        }
        deleteObjectRequest.bucket = bucketName
        deleteObjectRequest.key = fileName
        s3.deleteObject(deleteObjectRequest) { task, error in
            if let error = error {
                   debugPrint("Error occurred: \(error)")
                    return
                }
               debugPrint("Deleted successfully.")
                return 
        }

    
    }
}
