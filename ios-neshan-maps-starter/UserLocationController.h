//
//  UserLocationController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/11/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

@interface UserLocationController : UIViewController <CLLocationManagerDelegate>

- (IBAction)focusOnUserLocation:(id)sender;
@end

NS_ASSUME_NONNULL_END
