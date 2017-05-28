//
//  GXPicturesView.m
//  GXApp
//
//  Created by zhudong on 16/8/11.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPicturesView.h"
#import "YYPhotoBrowseView.h"
#define GXPicturesViewDidClick @"GXPicturesViewDidClick"
@interface GXPicturesView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
@implementation GXPicturesView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        //
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
    }
    return self;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.Imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageV = [[UIImageView alloc] init];
    [cell.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    NSString *imageStr = self.Imgs[indexPath.item];
    if (imageStr.length > 0) {
        NSURL *url = [NSURL URLWithString:imageStr];
        [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"live_placeholder"]];
    }
    cell.tag = indexPath.row;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = @{@"index":@(indexPath.row),@"imagesUrls":self.Imgs};
    [[NSNotificationCenter defaultCenter] postNotificationName:GXPicturesViewDidClick object:nil userInfo:dict];
}
- (void)setImgs:(NSArray *)Imgs{
    if (Imgs.count <= 9) {
        _Imgs = Imgs;
    }else{
        NSMutableArray * arrM = [NSMutableArray arrayWithArray:Imgs];
        [arrM removeObjectsInRange:NSMakeRange(8, arrM.count - 9)];
        _Imgs = arrM.copy;
    }
    [self reloadData];
}
@end
