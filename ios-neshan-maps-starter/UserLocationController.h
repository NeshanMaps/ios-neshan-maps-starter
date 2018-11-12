//
//  UserLocationController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/11/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserLocationController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet NTMapView *map;
- (IBAction)focusOnUserLocation:(id)sender;
@end

NS_ASSUME_NONNULL_END
