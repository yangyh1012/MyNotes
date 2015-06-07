//
//  ViewController.m
//  MyNotes
//
//  Created by 杨毅辉 on 15/6/2.
//  Copyright (c) 2015年 yangyh1012. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "NSObject+BlockTool.h"

#import "NoteDao.h"
#import "Note.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //同步，会卡主线程
    self.dataList = [[NoteDao sharedManager] findAllDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender {
    
    [self.tableView setEditing:NO animated:NO];
    
    DetailViewController *detailViewController = (DetailViewController *)vc;
    detailViewController.type = 1;
    
    [detailViewController handlerEventWithBlock:^(void){
        
        [self.tableView reloadData];
        
    } withIdentifier:@"ViewController1"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        
        [self.tableView setEditing:NO animated:YES];
    }
    
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Note *note = self.dataList[indexPath.row];
    cell.textLabel.text = note.content;
    cell.detailTextLabel.text = [note.date description];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Note *note = [self.dataList objectAtIndex:[indexPath row]];
        [[NoteDao sharedManager] remove:note];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailViewController.type = 2;
    
    //查看详情的时候才有note
    Note *note = self.dataList[indexPath.row];
    detailViewController.note = note;
    
    [detailViewController handlerEventWithBlock:^(void){
        
        [self.tableView reloadData];
        
    } withIdentifier:@"ViewController2"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
