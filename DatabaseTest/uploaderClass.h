//
//  uploaderClass.h
//  DatabaseTest
//
//  Created by Tanmay Bakshi on 2015-06-15.
//  Copyright © 2015 TBSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface uploaderClass : NSObject
-(void)uploadImageToServer: (UIImage *)image name:(NSString*)filename;
-(BOOL)doneYetFunc;
@end
BOOL doneYet;
