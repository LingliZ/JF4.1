//
//  GXHomeImportantMessageController.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeImportantMessageController.h"
#import "GXHomeImpMsgBaseModel.h"
#import "GXBanAnaRemImpDetailController.h"
#import "GXGlobalArticleDetailController.h"
//模型
#import "GXHomeTextModel.h"
#import "GXHomeAudioModel.h"
#import "GXHomeVedioModel.h"
#import "GXHomeTextCell.h"
#import "GXHomeAudioCell.h"
#import "GXHomeVedioCell.h"
#import "ZDPlayer.h"//音频
#import <AVKit/AVKit.h>//视频
#import "HTPlayer.h"
#import <AVFoundation/AVFoundation.h>
//测试
#import "UIView+GXVIewController.h"
#import "GXHomeImpHeaderView.h"
#import "GXHomeImpMsgFootView.h"



@interface GXHomeImportantMessageController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)UITableView *homeImportMsgTableView;
@property (nonatomic,assign)NSInteger page;
//视频
@property (strong, nonatomic)NSIndexPath *currentIndexPath;
@property (strong, nonatomic)GXHomeVedioCell *currentCell;//当前播放的cell
@property (strong, nonatomic)HTPlayer *htPlayer;
@property (assign, nonatomic)BOOL isSmallScreen;
@property (nonatomic,assign)BOOL isVedioPlay;
@property (strong, nonatomic)NSMutableArray<NSMutableArray *> *dataSource;
//更改交互的ScrollowView
@property (nonatomic,strong)UIScrollView *changeScrollowView;
@property (nonatomic,assign)BOOL isEnable;


//audio
@property (nonatomic,strong) ZDPlayer *audioPlayer;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong)UIButton *audioPlayBtn;
@property (nonatomic,assign) BOOL isAudioBreak;
@property (nonatomic,assign) NSInteger playingIndex;
@property (nonatomic,assign) NSInteger playingSection;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;

@end

@implementation GXHomeImportantMessageController
{
    GXHomeImpMsgFootView *footerView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"SwitchThePageToStopPlaying" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer pause];
    [self.htPlayer releaseWMPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SwitchThePageToStopPlaying" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingIndex = -1;
    self.playingSection = -1;
    self.audioPlayer = [ZDPlayer sharePlayer];
    self.isEnable = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.homeImportMsgTableView.dataSource = self;
    self.homeImportMsgTableView.delegate = self;
    self.homeImportMsgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeImportMsgTableView.estimatedRowHeight = 280;
    self.homeImportMsgTableView.rowHeight = UITableViewAutomaticDimension;
    [self createdFooterView];
    [self.view addSubview:self.homeImportMsgTableView];
    [self refreshData];
    [self.homeImportMsgTableView registerClass:[GXHomeVedioCell class] forCellReuseIdentifier:@"vedioCell"];
//  接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popDetail:) name:kHTPlayerPopDetailNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollow) name:SonBeginScroll object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollowNO) name:SonEndScroll object:nil];
    [self addObserver];
}
-(void)createdFooterView{
    footerView = [[[NSBundle mainBundle]loadNibNamed:@"GXHomeImpMsgFootView" owner:self options:nil] lastObject];
    footerView.frame = CGRectMake(0, 0, GXScreenWidth, 110);
//    self.homeImportMsgTableView.tableFooterView = footerView;
//    self.homeImportMsgTableView.tableFooterView.hidden = YES;
}
- (void)changeScrollowNO{
    self.isEnable = false;
}

- (void)changeScrollow{
    self.isEnable = true;
}
-(void)loadMsgData{
    [self.homeImportMsgTableView reloadData];
}
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:)name:kHTPlayerFinishedPlayNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:)name:kHTPlayerFullScreenBtnNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTheVideo:)name:kHTPlayerCloseVideoNotificationKey object:nil];
}
-(void)stopPlay{
    if (self.audioPlayer.player.rate == 1) {
        [self.audioPlayer pause];
        [self audioBtnClick:self.audioPlayBtn];
    }
    if (self.htPlayer.player.rate == 1) {
        [self.htPlayer releaseWMPlayer];
    }
}
-(void)videoDidFinished:(NSNotification *)notice{
    if (_htPlayer.screenType == UIHTPlayerSizeFullScreenType){
        [self toCell];//先变回cell
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
    }];
}
-(void)closeTheVideo:(NSNotification *)obj{
    [UIView animateWithDuration:0.3 animations:^{
        _htPlayer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_htPlayer removeFromSuperview];
        [self releaseWMPlayer];
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        if (_isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}
-(void)releaseWMPlayer{
    [_htPlayer releaseWMPlayer];
    _htPlayer = nil;
    _currentIndexPath = nil;
}
-(void)toCell{
    self.currentCell = (GXHomeVedioCell *)[self.homeImportMsgTableView cellForRowAtIndexPath:_currentIndexPath];
    [_htPlayer reductionWithInterfaceOrientation:self.currentCell.vedioView];
    _isSmallScreen = NO;
    [self.homeImportMsgTableView reloadData];
}
-(void)toSmallScreen{
    //放widow上
    [_htPlayer toSmallScreen];
    _isSmallScreen = YES;
}
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [_htPlayer toFullScreenWithInterfaceOrientation:interfaceOrientation];
}
- (void)popDetail:(NSNotification *)obj
{
    _htPlayer = (HTPlayer *)obj.object;
    
    if (_htPlayer) {
        if (_isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    };
    [self addObserver];
}
- (void)refreshData{
    self.playingIndex = -1;
    self.playingSection = -1;
    [self refreshMsgFirstData];
    self.homeImportMsgTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMsgMoreData)];
    self.homeImportMsgTableView.mj_footer.automaticallyChangeAlpha = YES;
}
- (void)refreshMsgFirstData{
    self.page = 1;
    [self loadMoreDataFromServer:self.page];
}
- (void)refreshMsgMoreData{
    self.page++;
    if (self.page >10) {
        [self.homeImportMsgTableView.mj_footer endRefreshing];
        return;
    }
    if (self.page > 10) {
        self.page = 10;
    }
    [self loadMoreDataFromServer:self.page];
}
-(void)loadMoreDataFromServer:(NSInteger)page{
    NSDictionary *parmarter = @{@"page":@(page),@"number":@"10"};
    [GXHttpTool POSTCache:GXUrl_importList parameters:parmarter success:^(id responseObject) {
       //视频测试
       //NSDictionary *testDict = @{@"created":@"2017-02-16 15:10:00",@"url":@"http://7xliru.com1.z0.glb.clouddn.com/11.mp4",@"type":@"vedio",@"imgUrl":@"https://www.91guoxin.com/uploads/20170216/58a5524345c09.png"};
        int count=0;
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            NSArray *valueArray = responseObject[@"value"];
            count=(int)[valueArray count];
            if (valueArray.count != 0 && self.page == 1) {
                [self removeAllArrayData];
            }
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                //视频测试
                //GXHomeImpMsgBaseModel *baseModel = [GXHomeImpMsgBaseModel modelWithDictionary:testDict];
                GXHomeImpMsgBaseModel *baseModel = [GXHomeImpMsgBaseModel modelWithDictionary:valueDict];
                NSDate *date = [GXAdaptiveHeightTool dateFromStringWithDateStyle:@"yyyy-MM-dd HH:mm:ss" withDateString:baseModel.created];
                NSString *dateStr = [GXAdaptiveHeightTool compareTodayOrYestodayOrTomorrowDate:date];
                if ([dateStr isEqualToString:@"今天"]) {
                    [self.dataSource[0] addObject:baseModel];
                }else if ([dateStr isEqualToString:@"昨天"]){
                    [self.dataSource[1] addObject:baseModel];
                }else{
                    [self.dataSource[2] addObject:baseModel];
                }
            }
        }
        
        [self.homeImportMsgTableView.mj_footer endRefreshing];
        [self.homeImportMsgTableView reloadData];
        
        if( count<10 || self.page == 10)
        {
            [self.homeImportMsgTableView.mj_footer endRefreshingWithNoMoreData];
            self.homeImportMsgTableView.tableFooterView = footerView;
        }else{
            self.homeImportMsgTableView.tableFooterView = nil;
        }
    } failure:^(NSError *error) {
        [self showErrorNetMsg:@"" withView:self.homeImportMsgTableView];
        [self.homeImportMsgTableView.mj_footer endRefreshing];
    }];
}
-(void)removeAllArrayData{
    [self.dataSource removeAllObjects];
    self.dataSource = nil;
}
-(UITableView *)homeImportMsgTableView{
    if (!_homeImportMsgTableView) {
        _homeImportMsgTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 49 - 64 - 40) style:UITableViewStylePlain];
    }
    return _homeImportMsgTableView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXHomeImpMsgBaseModel *baseModel = (GXHomeImpMsgBaseModel *)self.dataSource[indexPath.section][indexPath.row];
    UITableViewCell *cell;
    if ([baseModel.type isEqualToString:@"info"]) {
        GXHomeTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        if (textCell == nil) {
            textCell = [[GXHomeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
        }
        textCell.model = (GXHomeTextModel *)baseModel;
        cell = textCell;
    }else if ([baseModel.type isEqualToString:@"audio"]){
        GXHomeAudioCell *audioCell =  [[GXHomeAudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"audioCell"];
        audioCell.audioPlayBtn.tag = indexPath.row;
        [audioCell.audioSlider addTarget:self action:@selector(audioSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [audioCell.audioPlayBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        audioCell.model = (GXHomeAudioModel *)baseModel;
        if (indexPath.section == self.playingSection) {
            if (indexPath.row == self.playingIndex) {
                [audioCell.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_stop_pic"] forState:UIControlStateNormal];
                self.isAudioBreak = false;
                self.slider = audioCell.audioSlider;
                self.audioPlayBtn = audioCell.audioPlayBtn;
                self.currentTimeLabel = audioCell.audioCurrentTimeLabel;
                self.totalTimeLabel = audioCell.audioTotalTimeLabel;
            }
        }
        cell = audioCell;
    }else{
        GXHomeVedioCell *vedioCell = [tableView dequeueReusableCellWithIdentifier:@"vedioCell"];
        vedioCell.model = (GXHomeVedioModel *)baseModel;
        cell = vedioCell;
        vedioCell.selectionStyle = UITableViewCellSelectionStyleNone;
        vedioCell.playBtn.tag = indexPath.row;
        [vedioCell.playBtn addTarget:self action:@selector(vedioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return vedioCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.dk_backgroundColorPicker=DKColorPickerWithColors(GXHomeDKWhiteColor,GXHomeDKBlackColor);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if (self.dataSource[section].count == 0) {
            return 0;
        }else{
            return 30;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GXHomeImpMsgBaseModel *model = self.dataSource.lastObject.firstObject;
    NSDate *date = [GXAdaptiveHeightTool dateFromStringWithDateStyle:@"yyyy-MM-dd HH:mm:ss" withDateString:model.created];
    NSString *titleStr = [GXAdaptiveHeightTool compareCurrentTime:date];
    NSArray *titleArray = @[@"",@"昨天",titleStr];
    GXHomeImpHeaderView *headerView = [GXHomeImpHeaderView headerViewWihtTableView:tableView];
    headerView.title = titleArray[section];
    return headerView;
}
#pragma mark - 视频播放
- (void)vedioBtnClick:(UIButton *) btn{
    UIView *v = [btn superview];//获取父类view
    UIView *v1 = [v superview];
    UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [self.homeImportMsgTableView indexPathForCell:cell];//获取cell对应的section
    _currentIndexPath = [NSIndexPath indexPathForRow:btn.tag inSection:indexPathAll.section];
    self.currentCell = (GXHomeVedioCell *)[self.homeImportMsgTableView cellForRowAtIndexPath:_currentIndexPath];
    
    if (_audioPlayer.player.rate == 1) {
        [self.audioPlayer pause];
        [self audioBtnClick:self.audioPlayBtn];
    }
    if (_htPlayer) {
        [_htPlayer removeFromSuperview];
        [_htPlayer setVideoURLStr:self.currentCell.model.url];
    }else{
        _htPlayer = [[HTPlayer alloc]initWithFrame:self.currentCell.vedioView.bounds videoURLStr:self.currentCell.model.url];
    }
    [_htPlayer setPlayTitle:self.currentCell.model.title];
    [self.currentCell.vedioView addSubview:_htPlayer];
    [self.currentCell.vedioView bringSubviewToFront:_htPlayer];
    if (_htPlayer.screenType == UIHTPlayerSizeSmallScreenType) {
        [_htPlayer reductionWithInterfaceOrientation:self.currentCell.vedioView];
    }
    _isSmallScreen = NO;
    [self.homeImportMsgTableView reloadData];
}
#pragma mark - 音频播放
- (void)audioSliderChanged: (UISlider *)slider{
    if (slider.value >= 0.99) {
        self.slider.value = 0.98;
    }
    [self.audioPlayer playWithValue:slider.value];
}
- (void)audioBtnClick: (UIButton *)btn{
    UITableViewCell *cell1 = (UITableViewCell *)btn.superview.superview.superview;//获取cell
    NSIndexPath *indexPath1 = [self.homeImportMsgTableView indexPathForCell:cell1];
    NSIndexPath *currentPath = [NSIndexPath indexPathForRow:btn.tag inSection:indexPath1.section];
    GXHomeAudioCell *cell = (GXHomeAudioCell *)[self.homeImportMsgTableView cellForRowAtIndexPath:currentPath];
    if (_htPlayer) {
        [self.htPlayer releaseWMPlayer];
        [self.htPlayer removeFromSuperview];
    }
    NSString *songName = cell.model.url;
    self.currentTimeLabel = cell.audioCurrentTimeLabel;
    self.totalTimeLabel = cell.audioTotalTimeLabel;
    if (self.audioPlayBtn != btn) {
        self.playingSection = indexPath1.section;
        self.playingIndex = btn.tag;
        //修改UI
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play_pic"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"home_audio_stop_pic"] forState:UIControlStateNormal];
        //播放
        cell.audioSlider.userInteractionEnabled = true;
        self.slider.userInteractionEnabled = false;
        self.slider = cell.audioSlider;
        [self.audioPlayer playWithName: songName];
        self.audioPlayBtn = btn;
        self.isAudioBreak = false;
    }else {
        self.isAudioBreak = !self.isAudioBreak;
        if (self.isAudioBreak) {
            self.playingIndex = -1;
            self.playingSection = -1;
            [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play_pic"] forState:UIControlStateNormal];
            [self.audioPlayer pause];
            self.slider.userInteractionEnabled = false;
        }else{
            self.playingIndex = btn.tag;
            self.playingSection = indexPath1.section;
            [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_stop_pic"] forState:UIControlStateNormal];
            [self.audioPlayer playWithName:songName];
            self.slider.userInteractionEnabled = true;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.playerDelegate = ^ void (CGFloat value, CGFloat totalTime, NSString *timeStr, NSString *totalStr){
        weakSelf.slider.value = value;
        weakSelf.currentTimeLabel.text = timeStr;
        weakSelf.totalTimeLabel.text = totalStr;
        //NSLog(@"播放滚动:%f====总时间:%@====已走:%@",value,totalStr,timeStr);
        if (value >= 0.99) {
            [weakSelf.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play"] forState:UIControlStateNormal];
            weakSelf.slider.value = 0;
            weakSelf.slider.userInteractionEnabled = false;
            weakSelf.audioPlayBtn = nil;
            weakSelf.slider = nil;
            weakSelf.isAudioBreak = false;
            weakSelf.playingIndex = -1;
        }
    };
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetSetY = scrollView.contentOffset.y;
    if (offsetSetY <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        self.isEnable = false;
        [[NSNotificationCenter defaultCenter] postNotificationName:FatherBeginScroll object:nil];
    }
    
    if (!self.isEnable) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    if(scrollView == self.homeImportMsgTableView){
        if (_htPlayer==nil) return;
        if (_htPlayer.superview) {
            CGRect rectInTableView = [self.homeImportMsgTableView rectForRowAtIndexPath:_currentIndexPath];
            CGRect rectInSuperview = [self.homeImportMsgTableView convertRect:rectInTableView toView:[self.homeImportMsgTableView superview]];
            if (rectInSuperview.origin.y-kNavbarHeight<-self.currentCell.vedioView.height||rectInSuperview.origin.y>self.view.height) {//往上拖动
                if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:_htPlayer]) {
                    //放widow上,小屏显示
//                    [self toSmallScreen];
                    [self releaseWMPlayer];
                }
            }else{
                if (![self.currentCell.vedioView.subviews containsObject:_htPlayer]) {
//                    [self toCell];
                }
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseWMPlayer];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXHomeImpMsgBaseModel *baseModel = self.dataSource[indexPath.section][indexPath.row];
    if ([(NSNumber *)baseModel.click integerValue] == 1) {
        GXGlobalArticleDetailController *detailVC = [[GXGlobalArticleDetailController alloc]init];
        if ([baseModel.type isEqualToString:@"info"]) {
            detailVC.textModel = (GXHomeTextModel *)baseModel;
        }else if ([baseModel.type isEqualToString:@"audio"]){
            detailVC.audioModel = (GXHomeAudioModel *)baseModel;
        }else{
            detailVC.vedioModel = (GXHomeVedioModel *)baseModel;
        }
        [self.navigationController pushViewController:detailVC animated:true];
    }else{
        return;
    }
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i<3; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [_dataSource addObject:array];
        }
    }
    return _dataSource;
}
@end
