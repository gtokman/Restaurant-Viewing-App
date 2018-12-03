//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by Gary Tokman on 2/25/18.
//  Copyright © 2018 Gary Tokman. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.locationService = locationService
            window.rootViewController = locationViewController
        default:
            let nav = storyboard
                .instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            window.rootViewController = nav
            loadBusinesses()
        }
        window.makeKeyAndVisible()
        
        return true
    }

    private func loadBusinesses() {
        service.request(.search(lat: 42.361145, long: -71.057083)) { (result) in
            switch result {
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses.compactMap(RestaurantListViewModel.init)
                if let nav = self.window.rootViewController as? UINavigationController,
                    let restaurantListViewController = nav.topViewController as? RestaurantTableViewController {
                    restaurantListViewController.viewModels = viewModels ?? []
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
