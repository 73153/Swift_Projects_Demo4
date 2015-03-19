//
//  SEJobPhotosTableViewCell.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

/**
 *  Custom table view cell for single schedule view screen (photos part specifically)
 */
class SEJobPhotosTableViewCell: SESwipeableTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var datasource = SEJobPhotoInfo[]()
    
    @IBOutlet var collectionView: UICollectionView
    
    /**
     *  Setup collection view delegate and attribute
     */
    override func awakeFromNib() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //#pragma mark - UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     *  Returns number of items to display in collection view, plus one because of "add" button cell
     *
     *  @param collectionView
     *  @param section
     *
     *  @return number of items to display in collection view
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count + 1
    }
    
    /**
     *  Prepare UICollectionViewCell to show. Collection view has only one image, add button or photo that is linked to the schedule.
     *
     *  @param collectionView collection view for which it's needed
     *  @param indexPath      index path at which it will be displayed
     *
     *  @return collection view cell object
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(SEJobPhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        if indexPath.row == 0 {
            var backgroundImageView = UIImageView(image: UIImage(named: "btn_add_photo"))
            backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFit
            cell.backgroundView = backgroundImageView
        } else {
            var photoInfo = self.datasource[indexPath.row - 1]
            var backgroundImageView = UIImageView(image: UIImage(contentsOfFile: photoInfo.filePath))
            backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
            cell.backgroundView = backgroundImageView
        }
        
        return cell
    }
    
}
