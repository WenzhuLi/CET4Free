//
//  SVLocationHandler.m
//  iyuba
//
//  Created by Lee Seven on 13-7-29.
//  Copyright (c) 2013年 Lee Seven. All rights reserved.
//

#import "SVLocationHandler.h"
#define kUserLatitudeKey @"userLastLatitude"
#define kUserLongitudeKey @"userLastLongitude"

@interface SVLocationHandler(){
    
}
@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) MAPoiSearchOption *poiSearchOption;
@property (nonatomic, strong) MASearch * search;
@end
static SVLocationHandler * handler;
@implementation SVLocationHandler
+ (SVLocationHandler *)sharedHandler{
    if (!handler) {
        handler = [[SVLocationHandler alloc] init];
    }
    return handler;
}
- (id)init{
    self = [super init];
    if (self) {
        self.mapView  = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.mapView.delegate = self;
    }
    return self;
}
+ (double)userLastLatitude{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kUserLatitudeKey];
}
+ (double)userLastLongitude{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kUserLongitudeKey];
}
+ (double)distanceBetweenLatitude1:(double)lat1 longitude1:(double)long1 andLatitude2:(double)lat2 longitude2:(double)long2{
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"%f",distance);
    return distance;
    //Distance in Meters
    
    //1 meter == 100 centimeter
    
    //1 meter == 3.280 feet
    
    //1 meter == 10.76 square feet
}
+ (void)storeLatitude:(double)lat longitude:(double)longi{
    [[NSUserDefaults standardUserDefaults] setDouble:lat forKey:kUserLatitudeKey];
    [[NSUserDefaults standardUserDefaults] setDouble:longi forKey:kUserLongitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)getUserLocationDelegate:(id<SVLocationHandlerDelegate>)delegate{
    self.delegate = delegate;
    self.mapView.showsUserLocation = YES;
}
- (void)poiRequestCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.poiSearchOption = [[MAPoiSearchOption alloc] init];
    
    self.poiSearchOption.config = @"BELSBXY";
    self.poiSearchOption.encode = @"UTF-8";
    self.poiSearchOption.cenX   = [NSString stringWithFormat:@"%f", coordinate.longitude];
    self.poiSearchOption.cenY   = [NSString stringWithFormat:@"%f", coordinate.latitude];
    
    [self.search poiSearchWithOption:self.poiSearchOption];
}
- (void)getPOIsNearbyDelegate:(id<SVLocationHandlerDelegate>)delegate{
    self.search = [[MASearch alloc] initWithSearchKey:AMAP_KEY Delegate:self];

    self.poiSearchOption =[[MAPoiSearchOption alloc] init];
    self.poiSearchOption.config = @"BELSBXY";
    self.poiSearchOption.encode = @"UTF-8";
    NSLog(@"user location:%f,%f",self.userLocation.location.coordinate.longitude,self.userLocation.location.coordinate.latitude);
    self.poiSearchOption.cenX   = [NSString stringWithFormat:@"%f", self.userLocation.location.coordinate.longitude];
    self.poiSearchOption.cenY   = [NSString stringWithFormat:@"%f", self.userLocation.location.coordinate.latitude];
    [self.search poiSearchWithOption:self.poiSearchOption];
}
//在 MAMapViewDelegate 协议中添加了如下回调函数
-(NSString*)keyForMap
{
    return AMAP_KEY;
}


/*
 *  定位更新时的回调函数
 */

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation:(%f,%f)",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation != nil) {
        self.userLocation = userLocation;
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        CLLocationCoordinate2D lastLocation = CLLocationCoordinate2DMake([SVLocationHandler userLastLatitude], [SVLocationHandler userLastLongitude]);
        double distance = [SVLocationHandler distanceBetweenLatitude1:userLocation.location.coordinate.latitude longitude1:userLocation.location.coordinate.longitude andLatitude2:lastLocation.latitude longitude2:lastLocation.longitude];
        NSLog(@"distance:%f",distance);
        [SVLocationHandler storeLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        if (distance < 100) {
            if (!self.search) {
                [self getPOIsNearbyDelegate:nil];
            }
            self.mapView.showsUserLocation = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(handler:didUpdateUserLocation:)]) {
                [self.delegate handler:self didUpdateUserLocation:userLocation.location.coordinate];
            }
            return;
        }
        
        
	}
}
/*
*  定位失败时的回调函数
*/
-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"didFailToLocateUserWithError:%@",error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(handler:getUserLocationFailedWithError:)]) {
        [self.delegate handler:self getUserLocationFailedWithError:error];
    }
}

#pragma mark - POI delegate

-(void)poiSearch:(MAPoiSearchOption *)poiSearchOption Result:(MAPoiSearchResult *)result
{
    if (self.poiSearchOption != poiSearchOption)
    {
        return;
    }
    
    /* Clean up. */
//    [self.poiAnnotations removeAllObjects];
    self.mapView.showsUserLocation = NO;
    [result.pois enumerateObjectsUsingBlock:^(MAPOI *poi, NSUInteger idx, BOOL *stop) {
        NSLog(@"============POI============\nName:%@\nAddress:%@\nDistance:%@\nMatch:%@\nType:%@\nTel:%@",poi.name,poi.address,poi.distance,poi.match,poi.type,poi.tel);
        /*
        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
        
        poiAnnotation.coordinate = CLLocationCoordinate2DMake([poi.y doubleValue], [poi.x doubleValue]);
        poiAnnotation.title      = poi.name;
        poiAnnotation.subtitle   = poi.address;
        
        [self.poiAnnotations addObject:poiAnnotation];
         */
    }];
    /*
    self.mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake([poiSearchOption.cenY doubleValue],
                                                                            [poiSearchOption.cenX doubleValue]),
                                                 MACoordinateSpanMake(0.004, 0.004));
    
    [self.mapView addAnnotations:self.poiAnnotations];
     */
}
@end
