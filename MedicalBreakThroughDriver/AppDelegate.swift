//
//  AppDelegate.swift
//  MedicalBreakThroughDriver
//
//  Created by macbok on 29/01/25.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import AWSS3
import AWSCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initializeS3()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        GMSServices.provideAPIKey("AIzaSyD09AGUnxXVmRLRFZ0R4AWVE_qPgyoecjg")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func initializeS3() {
//        let poolId = "us-west-1:83a11d48-4aa8-4f3d-bd86-5225447ff113" // Old
        _ = "us-west-1:3a1210b2-4a70-47e6-8d06-3fa6de14861f" // New
//        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let COGNITO_POOL_ID = "us-west-1:3a1210b2-4a70-47e6-8d06-3fa6de14861f"
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest1, identityPoolId: COGNITO_POOL_ID)
        let configuration = AWSServiceConfiguration(region: .USWest1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
      //  AWSDDLog.add(AWSDDTTYLogger.sharedInstance) // Console logger
        if let logger = AWSDDTTYLogger.sharedInstance {
            AWSDDLog.add(logger)
        }
        AWSDDLog.sharedInstance.logLevel = .all
    }
}

