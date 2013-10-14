//
//  UIImage+Screenshot.m
//  CET6Free
//
//  Created by Lee Seven on 13-5-23.
//  Copyright (c) 2013年 iyuba. All rights reserved.
//

#import "UIImage+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Screenshot)
+ (UIImage*)screenshot
{
    
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    //    CGSize imageSize = ViewController.navigationController.view.bounds.size;
    /*
     if (NULL != UIGraphicsBeginImageContextWithOptions)
     UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
     else
     UIGraphicsBeginImageContext(imageSize);
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     // Iterate over every window from back to front
     for (UIWindow *window in [[UIApplication sharedApplication] windows])
     {
     if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
     {
     // -renderInContext: renders in the coordinate space of the layer,
     // so we must first apply the layer's geometry to the graphics context
     CGContextSaveGState(context);
     // Center the context around the window's anchor point
     CGContextTranslateCTM(context, [window center].x, [window center].y);
     // Apply the window's transform about the anchor point
     CGContextConcatCTM(context, [window transform]);
     // Offset by the portion of the bounds left of and above the anchor point
     CGContextTranslateCTM(context,
     -[window bounds].size.width * [[window layer] anchorPoint].x,
     -[window bounds].size.height * [[window layer] anchorPoint].y);
     
     // Render the layer hierarchy to the current context
     [[window layer] renderInContext:context];
     
     // Restore the context
     CGContextRestoreGState(context);
     }
     }
     
     // Retrieve the screenshot image
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGFloat scale = [UIImage isRetinaDisplay] ? 2.0 : 1.0;
    CGFloat topCat = 20;
    CGRect contentRectToCrop = CGRectMake(0, topCat * scale, imageSize.width * scale, (imageSize.height - topCat) * scale);
    //    UIImage *imageout = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    return croppedImage;
}
+ (BOOL) isRetinaDisplay{
    return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00;
}
@end
