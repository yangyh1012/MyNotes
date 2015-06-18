//
//  DetailViewController.m
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "DetailViewController.h"
#import "NSObject+BlockTool.h"

#import "Note.h"
#import "NoteDao.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
    UIBarButtonItem *barButtonItem = nil;
    if (self.type == 1) {
        
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doSave:)];
    } else if (self.type == 2) {
        
        self.textView.text = self.note.content;
        self.textView.editable = NO;
        
        barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doEdit:)];
    }
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [self.textView becomeFirstResponder];
    
    UIBarButtonItem *leftItem = nil;
    leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(doBack:)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)doSave:(id)sender {
    
    if (![self.textView.text isEqualToString:@""]) {
        
        Note *note1 = [[Note alloc] init];
        note1.date = [NSDate date];
        note1.content = self.textView.text;
        
        //同步，会卡主线程
        [[NoteDao sharedManager] insert:note1];
        
        void(^block)(void) = [self blockForEventWithIdentifier:@"ViewController1"];
        
        block();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doEdit:(id)sender {
    
    UIBarButtonItem *barButtonItem = nil;
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doModify:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.textView.editable = YES;
    [self.textView becomeFirstResponder];
}

- (void)doModify:(id)sender {
    
    if (![self.textView.text isEqualToString:self.note.content]) {
        
        self.note.date = [NSDate date];
        self.note.content = self.textView.text;
        
        //同步，会卡主线程
        [[NoteDao sharedManager] modify:self.note];
    }
    
    UIBarButtonItem *barButtonItem = nil;
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doEdit:)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.textView.editable = NO;
}

- (void)doBack:(id)sender {
    
    if (self.type == 1) {
        
        
    } else if (self.type == 2) {
        
        if (![self.textView.text isEqualToString:self.note.content]) {
            
            self.note.date = [NSDate date];
            self.note.content = self.textView.text;
            
            //同步，会卡主线程
            [[NoteDao sharedManager] modify:self.note];
        }
        
        void(^block)(void) = [self blockForEventWithIdentifier:@"ViewController2"];
        
        block();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 0,keyboardSize.height, 0);
}

- (void)keyboardDidHide:(NSNotification *)notification {

     self.textView.contentInset = UIEdgeInsetsZero;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
