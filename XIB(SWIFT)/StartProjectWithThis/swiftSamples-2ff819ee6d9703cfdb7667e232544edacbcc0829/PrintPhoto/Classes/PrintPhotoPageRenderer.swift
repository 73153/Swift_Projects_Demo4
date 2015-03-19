//
//  PrintPhotoPageRenderer.swift
//  PrintPhoto
//
//  Created by Calman Steynberg on 2014-06-04.
//
//

import UIKit

class PrintPhotoPageRenderer: UIPrintPageRenderer {
    var imageToPrint: UIImage
    
    init() {
        self.imageToPrint = UIImage()
    }
    
    // This code always draws one image at print time.
    override func numberOfPages() -> Int {
        return 1
    }
    
    override func drawPageAtIndex(pageIndex: Int, inRect printableRect: CGRect) {
        if self.imageToPrint != nil {
            var destRect: CGRect
            
            // When drawPageAtIndex:inRect: paperRect reflects the size of
            // the paper we are printing on and printableRect reflects the rectangle
            // describing the imageable area of the page, that is the portion of the page
            // that the printer can mark without clipping.
            
            var paperSize = self.paperRect.size
            var imageableAreaSize = self.printableRect.size
            
            // If the paperRect and printableRect have the same size, the sheet is borderless and we will use
            // the fill algorithm. Otherwise we will uniformly scale the image to fit the imageable area as close
            // as is possible without clipping.
            var fillSheet = paperSize.width == imageableAreaSize.width && paperSize.height == imageableAreaSize.height
            
            var imageSize = imageToPrint.size
            if fillSheet {
                destRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
            } else {
                destRect = self.printableRect
            }
            
            // Calculate the ratios of the destination rectangle width and height to the image width and height.
            var width_scale = destRect.size.width/imageSize.width, height_scale = destRect.size.height/imageSize.height
            var scale: Float = 0.0
            if fillSheet {
                scale = width_scale > height_scale ? width_scale : height_scale	  // This produces a fill to the entire sheet and clips content.
            } else {
                scale = width_scale < height_scale ? width_scale : height_scale	  // This shows all the content at the expense of additional white space.
            }
            
            // Locate destRect so that the scaled image is centered on the sheet.
            destRect = CGRectMake((paperSize.width - imageSize.width*scale)/2, (paperSize.height - imageSize.height*scale)/2, imageSize.width*scale, imageSize.height*scale)
            // Use UIKit to draw the image to destRect.
            imageToPrint.drawInRect(destRect)
        } else {
            NSLog("%s No image to draw!")
        }
    }
    
}
