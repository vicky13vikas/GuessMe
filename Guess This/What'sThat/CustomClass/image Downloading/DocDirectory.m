//
//  DocDirectory.m
//  What'sThat
//
//  Created by Vibhooti on 5/17/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "DocDirectory.h"

@implementation DocDirectory

-(UIImage *)getImageIfExistInDir:(NSString*)dirName fileName:(NSString*)fileName{
    NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/"];
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",cacheDirectory,dirName,fileName];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath])
    {
      return [UIImage imageWithContentsOfFile:filePath];
    }
    return nil;
}

@end
