//
//  DocDirectory.h
//  What'sThat
//
//  Created by Vibhooti on 5/17/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocDirectory : NSObject
{
    
}
-(UIImage *)getImageIfExistInDir:(NSString*)dirName fileName:(NSString*)fileName;
@end
