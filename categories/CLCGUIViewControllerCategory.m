//
//  CLCGUIViewControllerCategory.m
//  Goodreads
//  Created by Ettore Pasquini on 1/23/13.
//

#import "clcg_device_utils.h"
#import "CLCGUIViewControllerCategory.h"


@implementation UIViewController (Candygirl)


-(void)presentVC:(UIViewController*)vc
{
  if (clcg_os_geq(@"5.0")) {
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    [self presentModalViewController:vc animated:YES];
  }
}


@end
