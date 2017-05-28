//
//  PriceNoSuggesView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceNoSuggesView.h"
#import "GXLashView.h"
#import "PriceSuggestionModel.h"
#import "PriceTipSuggestionModel.h"
#import "HYBCardScaleFlowLayout.h"

#import "PriceSuggestionCollectionCell.h"


#import "GXSuggestionModel.h"
#import "PriceMarketModel.h"




#define SCREENWITH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define valueSize 24
#define titleSize 14
#define smallTitleSize 12
#define contentViewHeight 300
#define suggetionTipHeight 28


#define cellWidth 334
#define cellHeight 210
#define itemSpacing 10


@interface PriceNoSuggesView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *emptyContentView;


@property (nonatomic, strong) PriceTipSuggestionModel *tipModel;
@property (nonatomic, strong) UICollectionView *collectionSuggesView;
@property (nonatomic, strong) NSMutableArray *SuggestionArray;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UILabel *suggesValue;
@property (nonatomic, strong) UILabel *analysisValue;
@property (nonatomic, strong) UILabel *liveValue;



@end



@implementation PriceNoSuggesView {
    UIButton *backGroundButton;
    UIView *tipView;
    UILabel *tipLabel;
}

- (UICollectionView *)collectionSuggesView {
    if (!_collectionSuggesView) {
        HYBCardScaleFlowLayout *layout = [[HYBCardScaleFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(WidthScale_IOS6(cellWidth), HeightScale_IOS6(cellHeight));
        _collectionSuggesView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, suggetionTipHeight, _contentView.width, _contentView.height - suggetionTipHeight - priceTabbarHeight) collectionViewLayout:layout];
        //注册
        [_collectionSuggesView registerNib:[UINib nibWithNibName:NSStringFromClass([PriceSuggestionCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"PriceSuggestionCollectionCell"];
        
        _collectionSuggesView.delegate = self;
        _collectionSuggesView.dataSource = self;
        [_contentView addSubview:_collectionSuggesView];
        
    }
    return _collectionSuggesView;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.SuggestionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"PriceSuggestionCollectionCell";
    PriceSuggestionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.suggestModel = self.SuggestionArray[indexPath.row];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(indexPath.row % self.SuggestionArray.count + 1), self.SuggestionArray.count];
    cell.backgroundColor = GXRGBColor(46, 45, 61);
    
    return cell;
}

- (void)configWithStatusTitle:(NSString *)title {
    [self.stateButton setTitle:title forState:UIControlStateNormal];
}



- (void)btnClick {
    if ([self.delegate respondsToSelector:@selector(PriceSuggestionViewSkipController:)]) {
        [self.delegate PriceSuggestionViewSkipController:self];
    }
}






- (NSMutableArray *)SuggestionArray {
    if (!_SuggestionArray) {
        _SuggestionArray = [NSMutableArray array];
    }
    return _SuggestionArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
        self.clipsToBounds = YES;
        
        
        _isShow = NO;
        
        backGroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        backGroundButton.backgroundColor = [UIColor blackColor];
        backGroundButton.hidden = YES;
        backGroundButton.userInteractionEnabled = YES;
        [backGroundButton addTarget:self action:@selector(closeV) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGroundButton];
        
        
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, GXScreenHeight - priceTabbarHeight - suggetionTipHeight - 64, GXScreenWidth, contentViewHeight)];
        [self addSubview:_contentView];
        _contentView.backgroundColor = ThemeBlack_Color;
        
        
        
    
        
        
        //rgb 55 54 72
        tipView = [[UIView alloc] initWithFrame:CGRectMake(0,0, GXScreenWidth, suggetionTipHeight)];
        [_contentView addSubview:tipView];
        tipView.backgroundColor = PriceVertical_SuggestionTipViewColor;
        
        
        UIButton *btnIcon = [[UIButton alloc] init];
        [tipView addSubview:btnIcon];
        [btnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(tipView.mas_centerY);
            make.leading.mas_equalTo(tipView.mas_leading).offset(14);
            make.height.width.mas_equalTo(20);
        }];
        [btnIcon setImage:IMAGE_NAMED(@"priceSuggestionIcon") forState:UIControlStateNormal];
        
        
        
        tipLabel = [[UILabel alloc] init];
        [tipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tipView.mas_left).offset(40);
            make.centerY.mas_equalTo(tipView.mas_centerY);
        }];
        tipLabel.textColor = GXRGBColor(231, 231, 231);
        tipLabel.font = GXFONT_PingFangSC_Regular(12);
        

        UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(GXScreenWidth - 100, 0, 100, suggetionTipHeight)];
        self.selectButton = selectButton;
        [selectButton setImage:IMAGE_NAMED(@"priceArrowUp") forState:UIControlStateNormal];
        [selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, selectButton.width - 30, 0, 10)];
        [tipView addSubview:selectButton];
        [selectButton addTarget:self action:@selector(tipclick) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        UIView *emptyContentView = [[UIView alloc] init];
        self.emptyContentView = emptyContentView;
        [_contentView addSubview:emptyContentView];
        [emptyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(suggetionTipHeight + 10, 10, priceTabbarHeight + suggetionTipHeight + 10 , 10));
        }];
        
        emptyContentView.backgroundColor = GXRGBColor(55, 54, 72);
        emptyContentView.layer.masksToBounds = YES;
        emptyContentView.layer.borderWidth = 1;
        emptyContentView.layer.cornerRadius = 5;
        
       // emptyContentView.backgroundColor = [UIColor grayColor];
        
        // 亲爱的用户，未绑定播间无法查看分析师建议
        UILabel *label1 = [[UILabel alloc] init];
        [emptyContentView addSubview:label1];
        
        label1.textColor = PriceLightGray;
        label1.font = GXFONT_PingFangSC_Regular(14);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"亲爱的用户，未绑定播间无法查看分析师建议";
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(HeightScale_IOS6(15));
          //  make.centerX.mas_equalTo(self.mas_centerX);
            make.left.mas_equalTo(emptyContentView.mas_left).offset(12.5);
        }];
        
        
        // 横黑线
        UIView *lineView = [[UIView alloc] init];
        [emptyContentView addSubview:lineView];
        
        //rgb 19 19 24
        lineView.backgroundColor = GXRGBColor(19, 19, 24);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(emptyContentView.mas_left).offset(12.5);
            make.right.mas_equalTo(emptyContentView.mas_right);
            make.top.mas_equalTo(label1.mas_bottom).offset(20);
            make.height.mas_equalTo(0.5);
        }];
        
        
        
        // 即时建议(条）
        UILabel *suggesLable = [[UILabel alloc] init];
        [emptyContentView addSubview:suggesLable];
        
        suggesLable.textColor = PriceLightGray;
        suggesLable.font = GXFONT_PingFangSC_Regular(12);
        suggesLable.textAlignment = NSTextAlignmentLeft;
        suggesLable.text = @"即时建议(条）";
        [suggesLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(emptyContentView.mas_centerX).multipliedBy(0.5);
            make.top.mas_equalTo(emptyContentView.mas_centerY).multipliedBy(1.2);
        }];
        
        
        UILabel *suggesValue = [[UILabel alloc] init];
        self.suggesValue = suggesValue;
        [emptyContentView addSubview:suggesValue];
        
        suggesValue.textColor = GXWhiteColor;
        suggesValue.font = GXFONT_PingFangSC_Regular(24);
        suggesValue.textAlignment = NSTextAlignmentCenter;
     
        [suggesValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(suggesLable.mas_top).offset(-8);
            make.centerX.mas_equalTo(suggesLable.mas_centerX);
        }];
        
        
        // 分析师(位）
        UILabel *analysisLable = [[UILabel alloc] init];
        [emptyContentView addSubview:analysisLable];
        
        analysisLable.textColor = PriceLightGray;
        analysisLable.font = GXFONT_PingFangSC_Regular(12);
        analysisLable.textAlignment = NSTextAlignmentCenter;
        analysisLable.text = @"分析师(位）";
        [analysisLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(emptyContentView.mas_centerX);
            make.top.mas_equalTo(emptyContentView.mas_centerY).multipliedBy(1.2);
        }];
        
        
        UILabel *analysisValue = [[UILabel alloc] init];
        self.analysisValue = analysisValue;
        [emptyContentView addSubview:analysisValue];
        
        analysisValue.textColor = GXWhiteColor;
        analysisValue.font = GXFONT_PingFangSC_Regular(24);
        analysisValue.textAlignment = NSTextAlignmentCenter;
        
        [analysisValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(analysisLable.mas_top).offset(-8);
            make.centerX.mas_equalTo(analysisLable.mas_centerX);
        }];
        
        
        // 直播间(个）
        UILabel *liveLable = [[UILabel alloc] init];
        [emptyContentView addSubview:liveLable];
        
        liveLable.textColor = PriceLightGray;
        liveLable.font = GXFONT_PingFangSC_Regular(12);
        liveLable.textAlignment = NSTextAlignmentRight;
        liveLable.text = @"直播间(个)";
        [liveLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(emptyContentView.mas_centerX).multipliedBy(1.5);
            make.top.mas_equalTo(emptyContentView.mas_centerY).multipliedBy(1.2);
        }];
        
        
        UILabel *liveValue = [[UILabel alloc] init];
        self.liveValue = liveValue;
        [emptyContentView addSubview:liveValue];
        
        liveValue.textColor = GXWhiteColor;
        liveValue.font = GXFONT_PingFangSC_Regular(24);
        liveValue.textAlignment = NSTextAlignmentCenter;
       
        [liveValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(liveLable.mas_top).offset(-8);
            make.centerX.mas_equalTo(liveLable.mas_centerX);
        }];
        
        
        
        
        
        //底部button
        UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stateButton = stateButton;
        [emptyContentView addSubview:stateButton];
        
    
        [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(emptyContentView.mas_centerX);
            make.width.mas_equalTo(WidthScale_IOS6(85));
            make.height.mas_equalTo(HeightScale_IOS6(27));
            make.bottom.mas_equalTo(emptyContentView.mas_bottom).offset(-15);
        }];
        
        // rgb 64 130 244
        stateButton.titleLabel.font = GXFONT_PingFangSC_Regular(14);
        [stateButton setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateNormal];
        //GXRGBColor(64, 130, 244)
        //[stateButton setBorderWithView:stateButton top:YES left:YES bottom:YES right:YES borderColor:[UIColor whiteColor] borderWidth:1];
        [stateButton.layer setBorderColor:GXRGBColor(64, 130, 244).CGColor];
        [stateButton.layer setMasksToBounds:YES];
        [stateButton.layer setBorderWidth:1];
        [stateButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)tipclick {
    [self setSelectExViewShow];
}


- (void)closeV {
    [self setSelectExViewShow];
}


- (void)setTipSuggestion:(PriceTipSuggestionModel *)tipModel {
    
    _tipModel = tipModel;
    
    int number;
    NSInteger count = [tipModel.roomCallNum integerValue];
    
    if (count < 10) {
        number = 2;
    } else if ( 10 <= count && count < 99 ) {
        number = 3;
    } else {
        number = 4;
    }
    
    NSString *string = [NSString stringWithFormat:@"来自%ld位分析师老师的%ld条即时建议",[tipModel.analystsNum integerValue], [tipModel.roomCallNum integerValue]];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:PriceRedColor range:NSMakeRange(string.length - (4 + number), number)];
    tipLabel.attributedText = att;
    
    
    self.suggesValue.text = [NSString stringWithFormat:@"%ld",[_tipModel.roomCallNum integerValue]];
    self.analysisValue.text = [NSString stringWithFormat:@"%ld",[_tipModel.analystsNum integerValue]];;
    self.liveValue.text = [NSString stringWithFormat:@"%ld",[_tipModel.roomNum integerValue]];
}


- (void)setSuggesionViewButtonStatus:(SuggetionViewStatus)buttonSatus title:(NSString *)title {
    _buttonSatus = buttonSatus;
    self.isDisplaySuggestion = NO;
    [self configWithStatusTitle:title];
    
}


- (void)showCodeSuggestionsListView:(PriceTipSuggestionModel *)tipModel markertMode:(PriceMarketModel *)marketModel {
    

    if (self.isDisplaySuggestion == NO) {
        return;
    }
    
    _tipModel = tipModel;

    if (self.emptyContentView) {
        [self.emptyContentView removeFromSuperview];
        self.emptyContentView = nil;
    }
    
    if (self.SuggestionArray.count != 0) {
        [self.SuggestionArray removeAllObjects];
    }
    
    NSArray *array = tipModel.Table;
    if (array.count != 0) {
        for (NSDictionary *dict in array) {
            GXSuggestionModel *model = [[GXSuggestionModel alloc] initWithDict:dict];
            model.sell = marketModel.sell;
            model.buy = marketModel.sell;
            [self.SuggestionArray addObject:model];
        }
        
        [self.collectionSuggesView reloadData];
    }
    
    
}


- (void)setSelectExViewShow {
    
    if (backGroundButton.hidden) {
        backGroundButton.hidden = NO;
        backGroundButton.alpha = 0;
        
        _isShow = YES;
        
        if ([self.delegate respondsToSelector:@selector(PriceSuggestionViewBeginShow:)]) {
            [self.delegate PriceSuggestionViewBeginShow:self];
        }
        
        
       
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect contentOriginFrame = _contentView.frame;
            contentOriginFrame.origin.y = GXScreenHeight - priceTabbarHeight - suggetionTipHeight - contentViewHeight;
            _contentView.frame = contentOriginFrame;
            
            backGroundButton.alpha = 0.5;
            
            // 改变箭头
            [self.selectButton.imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
            
        }];
        
    } else {
        
        _isShow = NO;
        
        if ([self.delegate respondsToSelector:@selector(PriceSuggestionViewDidHide:)]) {
            [self.delegate PriceSuggestionViewDidHide:self];
        }
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            backGroundButton.alpha = 0;
            
            CGRect f = _contentView.frame;
            f.origin.y += (f.size.height) - 64;
            _contentView.frame = f;
            
            // 改变箭头
            [self.selectButton.imageView setTransform:CGAffineTransformMakeRotation(-2*M_PI)];
            
        } completion:^(BOOL finished) {
            
            backGroundButton.hidden = YES;
        }];
    }
    
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
