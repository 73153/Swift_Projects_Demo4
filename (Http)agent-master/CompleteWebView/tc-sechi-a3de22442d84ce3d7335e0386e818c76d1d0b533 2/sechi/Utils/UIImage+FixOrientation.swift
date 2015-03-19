//
//  UIImage+FixOrientation.swift
//  sechi
//
//  Created by TCSASSEMBLER on 2014-06-13.
//  Copyright (c) 2014 TopCoder. All rights reserved.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage {
        
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        switch (self.imageOrientation) {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, Float(M_PI))
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, Float(M_PI_2))
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, -Float(M_PI_2))
        default:
            break
        }
        
        switch (self.imageOrientation) {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }
        
        var ctx = CGBitmapContextCreate(nil, UInt(self.size.width), UInt(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage))
        CGContextConcatCTM(ctx, transform)
        
        switch (self.imageOrientation) {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage)
        }
        
        var cgimg = CGBitmapContextCreateImage(ctx)
        var img = UIImage(CGImage: cgimg)
        CGContextRelease(ctx)
        CGImageRelease(cgimg)
        return img
    }
}

