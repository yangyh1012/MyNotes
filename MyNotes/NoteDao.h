//
//  NoteDao.h
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface NoteDao : NSObject

+ (NoteDao *)sharedManager;

- (BOOL)create:(Note *)note;

- (BOOL)modify:(Note *)note;

- (BOOL)remove:(Note *)note;

- (NSMutableArray *)findAllDatas;

- (Note *)findById:(Note *)note;

@end
