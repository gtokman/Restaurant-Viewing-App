//
//  DetailsFoodViewController.swift
//  RestaurantApp
//
//  Created by Gary Tokman on 8/7/18.
//  Copyright © 2018 Gary Tokman. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class DetailsFoodViewController: UIViewController {
    @IBOutlet weak var detailsFoodView: DetailsFoodView?
    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsFoodView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsFoodView?.collectionView?.dataSource = self
        detailsFoodView?.collectionView?.delegate = self
    }

    func updateView() {
        if let viewModel = viewModel {
            detailsFoodView?.priceLabel?.text = viewModel.price
            detailsFoodView?.hoursLabel?.text = viewModel.isOpen
            detailsFoodView?.locationLabel?.text = viewModel.phoneNumber
            detailsFoodView?.ratingsLabel?.text = viewModel.rating
            detailsFoodView?.collectionView?.reloadData()
            centerMap(for: viewModel.coordinate)
            title = viewModel.name
        }
    }

    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsFoodView?.mapView?.addAnnotation(annotation)
        detailsFoodView?.mapView?.setRegion(region, animated: true)
    }
}

extension DetailsFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageUrls.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailsCollectionViewCell
        if let url = viewModel?.imageUrls[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsFoodView?.pageControl?.currentPage = indexPath.item
    }
}
