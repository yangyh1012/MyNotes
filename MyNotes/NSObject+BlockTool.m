//
//  NSObject+BlockTool.m
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/3.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "NSObject+BlockTool.h"

@implementation NSObject (BlockTool)

const char ZXObjectEventHandlerDictionary;

- (void)handlerEventWithBlock:(id)block withIdentifier:(NSString *)identifier {
    
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectEventHandlerDictionary);
    if(eventHandlerDictionary == nil)
    {
        eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &ZXObjectEventHandlerDictionary, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    [eventHandlerDictionary setObject:block forKey:identifier];
}

- (id)blockForEventWithIdentifier:(NSString *)identifier {
    
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectEventHandlerDictionary);
    if(eventHandlerDictionary == nil) return nil;
    return [eventHandlerDictionary objectForKey:identifier];
}

@end
