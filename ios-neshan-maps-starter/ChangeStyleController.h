//
//  ChangeStyleController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/10/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeStyleController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *themePreview;
- (IBAction)changeStyle:(id)sender;

@end

NS_ASSUME_NONNULL_END
