//
//  SVLocationHandler.h
//  iyuba
//
//  Created by Lee Seven on 13-7-29.
//  Copyright (c) 2013年 Lee Seven. All rights reserved.
//


/*
 * 高德地图版本的Handler
 */


#import <Foundation/Foundation.h>
#import "MAMapKit.h"
#import "MASearch.h"
#define AMAP_KEY @"a7c97efcbb393fb97cd68b33a4735fb7"


@class SVLocationHandler;
@protocol SVLocationHandlerDelegate <NSObject>

- (void)handler:(SVLocationHandler *)handler didUpdateUserLocation:(CLLocationCoordinate2D)location;
- (void)handler:(SVLocationHandler *)handler getUserLocationFailedWithError:(NSError *)error;

@end
@interface SVLocationHandler : NSObject<MAMapViewDelegate,MASearchDelegate>

@property (nonatomic, strong) id<SVLocationHandlerDelegate> delegate;
@property (nonatomic, strong)MAUserLocation * userLocation;

+ (double)userLastLatitude;
+ (double)userLastLongitude;
+ (SVLocationHandler *)sharedHandler;

+ (double)distanceBetweenLatitude1:(double)lat1 longitude1:(double)long1 andLatitude2:(double)lat2 longitude2:(double)long2;

- (void)getUserLocationDelegate:(id<SVLocationHandlerDelegate>)delegate;
- (void)getPOIsNearbyDelegate:(id<SVLocationHandlerDelegate>)delegate;
@end
