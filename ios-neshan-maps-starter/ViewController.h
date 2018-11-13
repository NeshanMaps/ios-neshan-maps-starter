//
//  ViewController.h
//  ios-neshan-maps-starter
//
//  Created by hamid on 11/4/18.
//  Copyright © 2018 Razhman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *version;

- (IBAction)siteClicked:(id)sender;
- (IBAction)sourceCodeClicked:(id)sender;
- (IBAction)test:(id)sender;

@end

