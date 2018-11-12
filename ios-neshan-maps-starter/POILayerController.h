//
//  POILayerController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/12/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface POILayerController : UIViewController

@property (strong, nonatomic) IBOutlet NTMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *themePreview;
- (IBAction)changeStyle:(id)sender;
- (IBAction)togglePOILayer:(id)sender;

@end

NS_ASSUME_NONNULL_END
