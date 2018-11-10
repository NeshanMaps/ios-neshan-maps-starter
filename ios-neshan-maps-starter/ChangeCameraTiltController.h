//
//  ChangeCameraTiltController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/10/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeCameraTiltController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *tiltSlider;
- (IBAction)sliderChanged:(id)sender;

- (IBAction)toggleCameraTilt:(id)sender;

@end

NS_ASSUME_NONNULL_END
