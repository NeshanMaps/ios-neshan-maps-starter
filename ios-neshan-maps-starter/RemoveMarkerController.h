//
//  RemoveMarkerController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/5/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NeshanMobileSDK/NeshanMobileSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoveMarkerController : UIViewController
@property (strong, nonatomic) IBOutlet NTMapView *map;
@property (weak, nonatomic) IBOutlet UIView *remove_marker_button_sheet;

@property (weak, nonatomic) IBOutlet UIButton *removeMarkerButton;
- (IBAction)removeMarker:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *marker_id;
@end

NS_ASSUME_NONNULL_END
