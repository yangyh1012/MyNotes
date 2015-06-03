//
//  Note.h
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, copy) NSString *noteId;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *content;

@end
