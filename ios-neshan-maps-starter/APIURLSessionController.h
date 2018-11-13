//
//  APIURLSessionController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/13/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIURLSessionController : UIViewController

@property (strong, nonatomic) IBOutlet NTMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressDetails;

@end

NS_ASSUME_NONNULL_END
