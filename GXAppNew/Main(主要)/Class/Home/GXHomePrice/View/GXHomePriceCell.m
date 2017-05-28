//
//  GXHomePriceCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomePriceCell.h"
#import "GXHomePriceCollectionCell.h"
#import "GXHomeAddCollectionCell.h"
#import "PriceMarketModel.h"
#define IntervalRefesh 2.0

@interface GXHomePriceCell ()
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,strong)NSMutableArray *defaultFiveArray;
@end
@implementation GXHomePriceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *homeLayOut = [[UICollectionViewFlowLayout alloc]init];
        homeLayOut.minimumLineSpacing = WidthScale_IOS6(5);
        homeLayOut.minimumInteritemSpacing = 5;
        homeLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat itemWidth = 0;
        if (IS_IPHONE_5) {
            itemWidth = WidthScale_IOS6(109);
        }else{
            itemWidth = WidthScale_IOS6(111);
        }
        homeLayOut.itemSize = CGSizeMake(itemWidth,80);
        //layOut.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        homePriceCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 10, GXScreenWidth - 30, 80) collectionViewLayout:homeLayOut];
        homePriceCollectionView.dk_backgroundColorPicker =DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(34, 35, 45));
        self.backGroundView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(34, 35, 45));
        homePriceCollectionView.delegate = self;
        homePriceCollectionView.dataSource = self;
        homePriceCollectionView.showsHorizontalScrollIndicator = NO;
//        homePriceCollectionView.pagingEnabled = YES;
        [self addSubview:self.backGroundView];
        [self addSubview:homePriceCollectionView];
        self.saveDataArray = [NSMutableArray new];
        self.defaultFiveArray = [NSMutableArray arrayWithObjects:@"LSAG15",@"LSCU",@"$DXY",@"OIL10",@"LSAL", nil];
        [homePriceCollectionView registerNib:[UINib nibWithNibName:@"GXHomePriceCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GXHomePriceCollectionCell"];
        [homePriceCollectionView registerNib:[UINib nibWithNibName:@"GXHomeAddCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GXHomeAddCollectionCell"];
//        self.contentView.backgroundColor = [UIColor blackColor];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(homePriceCollectionView);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}
-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = [UIColor redColor];
    }return _backGroundView;
}
-(void)homePriceReloadData{
    [homePriceCollectionView reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.priceListArray.count >= 9) {
        return 9;
    }else{
        return self.priceListArray.count + 1;
    }
}
- (void) initData{
    [self loadData];
    if (_isRefesh == YES) {
        GXLog(@"didload已经请求");
    } else if (_isRefesh == NO) {
        [self stop];
        NSTimer *timer = [NSTimer timerWithTimeInterval:IntervalRefesh target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}
- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)loadData {
    _isRefesh = NO;
//    DLog(@"=========00000000000");
    NSString *key = nil;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
    if (array.count >= 9) {
        NSArray *maxArray = [array subarrayWithRange:NSMakeRange(0, 9)];
        key = [maxArray  componentsJoinedByString:@","];
    }else if (array.count == 0){
//    else if ((array.count > 0 && array.count <=3) || array.count == 0) {
//        NSMutableArray *array1 = array.mutableCopy;
//        for (NSString *itemStr in self.defaultFiveArray) {
//            if (![array1 containsObject:itemStr]) {
//                [array1 addObject:itemStr];
//            }
//        }
//        key = [array1 componentsJoinedByString:@","];
        [self.priceListArray removeAllObjects];
        [homePriceCollectionView reloadData];
        return;
    }else{
        key = [array componentsJoinedByString:@","];
    }
    if ([GXUserInfoTool isLogin]) {
        [self.saveDataArray removeAllObjects];
        [GXHttpTool POSTCache:GXUrl_fetchPrice parameters:nil success:^(id responseObject) {
            if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
                for (NSDictionary *valueDict in responseObject[@"value"]){
                    [self.saveDataArray addObject:valueDict[@"code"]];
                }
                [GXUserdefult setObject:self.saveDataArray forKey:PersonSelectCodesKey];
                [GXUserdefult synchronize];
                if (self.saveDataArray.count != 0) {
//                    if (self.saveDataArray.count > 0 && self.saveDataArray.count <= 3) {
//                        for (NSString *itemStr in self.defaultFiveArray) {
//                            if (![self.saveDataArray containsObject:itemStr]) {
//                                [self.saveDataArray addObject:itemStr];
//                            }
//                        }
//                        param[@"code"] = [self.saveDataArray componentsJoinedByString:@","];
//                    }else
                    if (self.saveDataArray.count >= 9) {
                        NSArray *maxArray = [self.saveDataArray subarrayWithRange:NSMakeRange(0, 9)];
                        param[@"code"] = [maxArray componentsJoinedByString:@","];
                    }else{
                        param[@"code"] = [self.saveDataArray componentsJoinedByString:@","];
                    }
                }else{
                    param[@"code"] = key;
                }
            }else{
                param[@"code"] = key;
            }
            [self loadHomePriceDataFromServer:param];
        } failure:^(NSError *error) {
            param[@"code"] = key;
            [self loadHomePriceDataFromServer:param];
        }];
    }else{
        param[@"code"] = key;
        [self loadHomePriceDataFromServer:param];
    }
}
//加载首页行情
-(void)loadHomePriceDataFromServer:(NSDictionary *)dictionary{
    [GXHttpTool POSTCache:GXUrl_quotation parameters:dictionary  success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            NSArray *array = [PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            [self arrayCompare:array];
            if(self.priceListArray){
                self.priceListArray = nil;
            }
            self.priceListArray = array.mutableCopy;
            array = nil;
            [homePriceCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)arrayCompare:(NSArray *)ar
{
    for (int i=0; i<[self.priceListArray count]; i++) {
        PriceMarketModel *model1=self.priceListArray[i];
        for (int j=0; j<[ar count]; j++) {
            PriceMarketModel *model2=ar[j];
            if([[model1.code lowercaseString] isEqualToString:[model2.code lowercaseString]])
            {
                if([model2.last floatValue] > [model1.last floatValue])
                {
                    model2.lastBackgColor=priceList_color_tableViewCellLastBackgRed;
                }else if ([model2.last floatValue] < [model1.last floatValue])
                {
                    model2.lastBackgColor=priceList_color_tableViewCellLastBackgGreen;
                }else
                {
                    model2.lastBackgColor=[UIColor clearColor];
                }
                break;
            }
        }
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<[self.priceListArray count]) {
        //首页热门行情
        PriceMarketModel *model = self.priceListArray[indexPath.row];
        GXHomePriceCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GXHomePriceCollectionCell" forIndexPath:indexPath];
        cell.model = self.priceListArray[indexPath.row];
        cell.contentView.backgroundColor = model.lastBackgColor;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.lastBackgColor=nil;
            cell.contentView.backgroundColor=[UIColor clearColor];
        });
        return cell;
    }else{
        //添加按钮
        GXHomeAddCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GXHomeAddCollectionCell" forIndexPath:indexPath];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<[self.priceListArray count]) {
        _didPriceDetailCellBlock(indexPath.row);
    }else{
        _didAddCellBlock(indexPath.row + 1);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
