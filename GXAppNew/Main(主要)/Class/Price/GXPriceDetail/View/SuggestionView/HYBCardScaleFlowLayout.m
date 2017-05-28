//
//  HYBCardScaleFlowLayout.m
//  CollectionViewDemos
//
//  Created by huangyibiao on 16/3/27.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBCardScaleFlowLayout.h"

@interface HYBCardScaleFlowLayout ()

@property (nonatomic, assign) CGFloat previousOffsetX;

@end

@implementation HYBCardScaleFlowLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    //每个section的inset，用来设定最左和最右item距离边界的距离，此处设置在中间
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) /2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//cell缩放的设置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出父类算出的布局属性
    //不能直接修改需要copy
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    
    //collectionView中心点的值
    //屏幕中心点对应于collectionView中content位置
    CGFloat centerX = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    //cell中的item一个个取出来进行更改
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        // cell的中心点x 和 屏幕中心点 的距离
        CGFloat space = ABS(atts.center.x - centerX);
        CGFloat scale = 1 - (space/self.collectionView.frame.size.width/10);
        atts.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attsArray;
}


//设置滑动停止时的collectionView的位置
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
    //获得计算好的属性
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //计算collection中心点X
    //视图中心点相对于collectionView的content起始点的位置
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        //找到距离视图中心点最近的cell，并将minSpace值置为两者之间的距离
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;        //各个不同的cell与显示中心点的距离
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}



//#pragma mark - Override
//- (void)prepareLayout {
//  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//  self.minimumLineSpacing = 5;
//    self.minimumInteritemSpacing = 10;
////  self.sectionInset = UIEdgeInsetsMake(12, 30, 12, 30);
//    
//   // self.minimumLineSpacing = 10;
//    self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
//    self.itemSize = CGSizeMake(self.collectionView.frame.size.width - (4 * 10),
//                             self.collectionView.frame.size.height - (2 * 14));
// // [super prepareLayout];
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//  return YES;
//}
//
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//  NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
//  NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
//  
//  CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
//                                  self.collectionView.contentOffset.y,
//                                  self.collectionView.frame.size.width,
//                                  self.collectionView.frame.size.height);
//  CGFloat offset = CGRectGetMidX(visibleRect);
//  
//  [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
//    CGFloat distance = offset - attribute.center.x;
//    // 越往中心移动，值越小，那么缩放就越小，从而显示就越大
//    // 同样，超过中心后，越往左、右走，缩放就越大，显示就越小
//    CGFloat scaleForDistance = distance / self.itemSize.height;
//    // 0.2可调整，值越大，显示就越大
//    CGFloat scaleForCell = 1 + 0.5 * (1 - fabs(scaleForDistance));
//    
//    // only scale y-axis
//    attribute.transform3D = CATransform3DMakeScale(1, scaleForCell, 1);
//    attribute.zIndex = 1;
//  }];
//  
//  return attributes;
//}
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//  // 分页以1/3处
//  if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
//    self.previousOffsetX += self.collectionView.frame.size.width - self.minimumLineSpacing * 2;
//  } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
//    self.previousOffsetX -= self.collectionView.frame.size.width - self.minimumLineSpacing * 2;
//  }
//  
//  proposedContentOffset.x = self.previousOffsetX;
//  
//  return proposedContentOffset;
//}

@end
