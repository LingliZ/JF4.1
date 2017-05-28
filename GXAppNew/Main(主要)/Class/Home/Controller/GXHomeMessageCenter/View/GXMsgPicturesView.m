//
//  GXMsgPicturesView.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMsgPicturesView.h"
#define GXPicturesViewDidClick @"GXPicturesViewDidClick"
@interface GXMsgPicturesView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation GXMsgPicturesView

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
    NSDictionary *imageDict = self.Imgs[indexPath.item];
//    if (imageDict[@"Img"]) {
//        NSURL *url = [NSURL URLWithString:imageDict[@"Img"]];
//        [imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHolder_pic"]];
//    }
    //    cell.contentView.backgroundColor = [UIColor redColor];
    //    imageV.backgroundColor = [UIColor redColor];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = @{@"cell":cell,@"imagesUrls":self.Imgs};
    [[NSNotificationCenter defaultCenter] postNotificationName:GXPicturesViewDidClick object:nil userInfo:dict];
}
- (void)setImgs:(NSArray *)Imgs{
    _Imgs = Imgs;
    [self reloadData];
}

@end
