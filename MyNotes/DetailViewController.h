//
//  DetailViewController.h
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface DetailViewController : UIViewController

/**
 *  type = 1时增加，type = 2时查看详情。
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) Note *note;

@end
