//
//  NoteDao.m
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "NoteDao.h"

@interface NoteDao()

@property (nonatomic, strong) NSMutableArray *dateList;

@end

@implementation NoteDao

static NoteDao *sharedManager = nil;

+ (NoteDao *)sharedManager {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date1 = [dateFormatter dateFromString:@"2015-06-01 21:02:03"];
        Note *note1 = [[Note alloc] init];
        note1.noteId = @"1";
        note1.date = date1;
        note1.content = @"没什么内容";
        
        NSDate *date2 = [dateFormatter dateFromString:@"2015-06-02 21:02:03"];
        Note *note2 = [[Note alloc] init];
        note2.noteId = @"2";
        note2.date = date2;
        note2.content = @"这个也没什么内容";
        
        sharedManager = [[self alloc] init];
        sharedManager.dateList = [[NSMutableArray alloc] init];
        [sharedManager.dateList addObject:note1];
        [sharedManager.dateList addObject:note2];
    });
    return sharedManager;
}

- (BOOL)create:(Note *)note {
    
    if ([self.dateList count] > 0) {
        
        Note *lastNote = [self.dateList lastObject];
        NSInteger noteId = [lastNote.noteId integerValue];
        noteId ++;
        note.noteId = [NSString stringWithFormat:@"%d",noteId];
        [self.dateList addObject:note];
        
    } else {
        
        note.noteId = @"1";
        [self.dateList addObject:note];
    }
    
    return YES;
}

- (BOOL)modify:(Note *)note {
    
    for (Note *n in self.dateList) {
        
        if ([n.noteId isEqualToString:note.noteId]) {
            
            n.date = note.date;
            n.content = note.content;
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)remove:(Note *)note {
    
    for (NSInteger i = 0; i < [self.dateList count]; i++) {
        
        Note *n = [self.dateList objectAtIndex:i];
        if ([n.noteId isEqualToString:note.noteId]) {
            
            [self.dateList removeObjectAtIndex:i];
            
            return YES;
        }
    }
    
    return NO;
}

- (NSMutableArray *)findAllDatas {
    
    return self.dateList;
}

- (Note *)findById:(Note *)note {
    
    for (Note *n in self.dateList) {
        
        if ([n.noteId isEqualToString:note.noteId]) {
            
            return n;
        }
    }
    
    return nil;
}

@end
