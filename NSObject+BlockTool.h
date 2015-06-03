//
//  NSObject+BlockTool.h
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/3.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (BlockTool)

- (void)handlerEventWithBlock:(id)block withIdentifier:(NSString *)identifier;

- (id)blockForEventWithIdentifier:(NSString *)identifier;

@end
