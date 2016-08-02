//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "Node.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）


@end

@implementation TreeTableView
@synthesize selecetTitle;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _data = data;
        _tempData = [self createTempData:data];
    }
    return self;
}

/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    UITableViewCell *cell;
    
    Node *node = [_tempData objectAtIndex:indexPath.row];
    
    // cell有缩进的方法
    cell.indentationLevel = node.depth; // 缩进级别
    cell.indentationWidth = 30.f; // 每个缩进级别的距离
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
    }
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, cell.frame.size.width/2, 40)];
    [label setText:node.name];
    [label setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:cell.frame.size.width/26.7]];
    [cell addSubview:label];
    if (node.parentId!=-1) {
        [label setFrame:CGRectMake(30, 0, cell.frame.size.width/2, 40)];
    }else{
        if (node.expand) {
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width*3/4, cell.frame.size.width/22.8, cell.frame.size.width/29, cell.frame.size.width/45.7)];
            [rightView setImage:[UIImage imageNamed:@"gray_down_logo"]];
            [cell addSubview:rightView];
            
        }else{
            UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width*3/4, cell.frame.size.width/22.8, cell.frame.size.width/29, cell.frame.size.width/45.7)];
            [rightView setImage:[UIImage imageNamed:@"gray_up_logo"]];
            [cell addSubview:rightView];
            
        }
        
    }
    
    if ([selecetTitle isEqualToString:node.name] && node.expand && node.parentId!=-1) {
        [label setTextColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:33.f/255.f alpha:1.0]];
        UIImageView *rightView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width*3/4, cell.frame.size.width/22.8, cell.frame.size.width/22, cell.frame.size.width/26.7)];
        [rightView setImage:[UIImage imageNamed:@"select_logo"]];
        [cell addSubview:rightView];
    }
    
   // cell.textLabel.text=node.name;
    
    return cell;
}


#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
        [_treeTableCellDelegate cellClick:parentNode];
    }
    
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.parentId == parentNode.nodeId) {
            node.expand = !node.expand;
            if (node.expand) {
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end
