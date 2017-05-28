//
//  GXCustomerSurveyTwoController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCustomerSurveyTwoController.h"

@interface GXCustomerSurveyTwoController ()

@end
@implementation GXCustomerSurveyTwoController
{
    NSMutableArray*titlesArr;//存储题目的标题
    NSMutableArray*itemsArr;//包含选项和对应的分数
    NSMutableArray*questionTypesArr;//题目类型(单选/多选)
    NSMutableArray*itemsOnlyArr;//只包含选项
    NSMutableDictionary*selectResultDic;//答题结果
    NSMutableDictionary*selectScoreDic;//答题得分
    BOOL isFinishedAnswer;//是否完成答题
    NSMutableDictionary*selecNumDic;//答题选中选项对应的编号
    
    int heightForScrollView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isForAddAccount=YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self requestQuestions];
}
-(void)createUI
{
    self.title=@"客户调查";
    [UIView setBorForView:self.btn_finish withWidth:0 andColor:nil andCorner:5];
//    [self.btn_finish setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [UIView setBorForView:self.btn_testAgain withWidth:0 andColor:nil andCorner:5];
    self.view_answerResult.hidden=YES;
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        self.label_mark_step4.text=@"完成开户";
    }
    [self.btn_finish setBtn_nextControlStateDisabled];
    titlesArr=[[NSMutableArray alloc]init];
    itemsArr=[[NSMutableArray alloc]init];
    itemsOnlyArr=[[NSMutableArray alloc]init];
    questionTypesArr=[[NSMutableArray alloc]init];
    selectResultDic=[[NSMutableDictionary alloc]init];
    selectScoreDic=[[NSMutableDictionary alloc]init];
    selecNumDic=[[NSMutableDictionary alloc]init];
    self.bottomScrollView.delegate=self;
    [self.bottomScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@62);
        make.bottom.mas_equalTo(@(-108));
        make.right.mas_equalTo(@0);
        make.width.mas_equalTo(@(GXScreenWidth));
        make.left.mas_equalTo(@0);
    }];

}
- (IBAction)btnClick_finish:(UIButton *)sender {
    if(!isFinishedAnswer)
    {
        [self.view showFailWithTitle:@"题目未答完"];
        return;
    }
    [self dealWithAnswerResult];
}
#pragma mark--处理答题结果
-(void)dealWithAnswerResult
{
    NSMutableDictionary*scoreForCommite=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        //齐鲁
        int totalScore=0;
        for(int i=1;i<=selectScoreDic.count;i++)
        {
            NSString*key=[NSString stringWithFormat:@"%d",i];
            NSString*score=selectScoreDic[key];
            totalScore+=score.intValue;
            
            NSString*saveKey=[NSString stringWithFormat:@"risk%d",i];
            scoreForCommite[saveKey]=score;
        }
        if(totalScore<=37)
        {
        
            [UIView animateWithDuration:0.5 animations:^{
                self.view_answerResult.hidden=NO;
            }];
            return;
            
        }
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        //天津
        NSMutableString*surveyResult=[[NSMutableString alloc]init];
        for(int i=1;i<=selectScoreDic.count;i++)
        {
            NSString*key=[NSString stringWithFormat:@"%d",i];
            NSString*score=selectScoreDic[key];
            if(i==selectScoreDic.count)
            {
                [surveyResult appendString:[NSString stringWithFormat:@"%d-%@",i,score]];
            }
            else
                [surveyResult appendString:[NSString stringWithFormat:@"%d-%@,",i,score]];
        }
        [scoreForCommite setObject:surveyResult forKey:@"surveyResult"];
        GXLog(@"津贵所问卷调查答案结果为：%@",surveyResult);
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        //陕西一带一路
        /*
         q_1-4|q_2-14|q_3-17|q_4-25,26|q_5-36|q_6-39,40|q_7-44|q_8-53|q_9-47|q_10-54|q_11-56|q_12-59|q_13-60|q_14-62
         */
        int totalScore=0;
        for(int i=1;i<=selectScoreDic.count;i++)
        {
            NSString*key=[NSString stringWithFormat:@"%d",i];
            NSString*score=selectScoreDic[key];
            totalScore+=score.intValue;
            
        }
        if(totalScore<50)
        {
            //得分必须大于50
            [UIView animateWithDuration:0.5 animations:^{
                self.view_answerResult.hidden=NO;
            }];
            return;
        }
        NSMutableString*surveyResult=[[NSMutableString alloc]init];
        for(int i=1;i<=selectScoreDic.count;i++)
        {
            NSString*key=[NSString stringWithFormat:@"%d",i];
            NSString*num=selecNumDic[key];
            if(i==selecNumDic.count)
            {
                [surveyResult appendString:[NSString stringWithFormat:@"q_%d-%@",i,num]];
            }
            else
                [surveyResult appendString:[NSString stringWithFormat:@"q_%d-%@|",i,num]];
        }
        [scoreForCommite setObject:surveyResult forKey:@"surveyResult"];

    }
    
    [GXUserdefult setObject:scoreForCommite forKey:AddCountParams];
    [GXUserdefult synchronize];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        GXCustomerSurveyThreeController*threeVC=[[GXCustomerSurveyThreeController alloc]init];
        [self.navigationController pushViewController:threeVC animated:YES];
        return;
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        [self commitDataForAddCount];
        return;
    }
    GXAddCountSelectBankController*selectVC=[[GXAddCountSelectBankController alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];

}
-(void)requestQuestions
{
    /*
     获取题目
     http://192.168.100.140:10130/account/get-survey?type=qiluce&customerId=1232131231312312312&ip=127.0.0.1
     */
    
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    // params[@"customerId"]=[GXUserInfoTool getCUstomerId];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        //齐鲁开户
        params[@"type"]=@"qiluce";
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        //天津开户
        params[@"type"]=@"tjpme";
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        //陕西一带一路开户
        params[@"type"]=AccountTypeShanxi;
    }

    GXLog(@"customerId:%@",params[@"customerId"]);
    
    [self.bottomScrollView showLoadingWithTitle:@"题目请求中..."];
    [GXHttpTool POSTCache:GXUrl_getSurvey parameters:params success:^(id responseObject) {
        [self.bottomScrollView removeTipView];
        GXLog(@"请求到的题目为：%@",responseObject);
        NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
        if(success.intValue)
        {
            [self dealWithQuestionsWithResponseObject:responseObject];
        }
        else
        {
            [self.bottomScrollView showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        
        GXLog(@"请求失败的结果为：%@",error);
        [self.bottomScrollView removeTipView];
        [self.bottomScrollView showFailWithTitle:@"题目请求失败，请检查网络设置"];
        /*
         请求失败后读取缓存的题目
         */
        /*
         if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
         {
         titlesArr=[GXUserInfoTool getQuestionsArrayWithKey:TitlesArrayForQilu];
         itemsArr=[GXUserInfoTool getQuestionsArrayWithKey:ItemsArrayForQilu];
         itemsOnlyArr=[GXUserInfoTool getQuestionsArrayWithKey:ItemsOnlyArrayForQilu];
         }
         if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
         {
         titlesArr=[GXUserInfoTool getQuestionsArrayWithKey:TitlesArrayForTianjin];
         itemsArr=[GXUserInfoTool getQuestionsArrayWithKey:ItemsArrayTianjin];
         itemsOnlyArr=[GXUserInfoTool getQuestionsArrayWithKey:ItemsOnlyArrayTianjin];
         }
         if(itemsArr.count)
         {
         [self addQuestions];
         
         }
         else
         {
         [self.view showFailWithTitle:@"题目获取失败，请检查网络设置"];
         }
         */
    }];
    
}

#pragma mark--处理题目数据
-(void)dealWithQuestionsWithResponseObject:(id)responseObject
{
    NSArray*valueArr=responseObject[@"value"];
    for(NSDictionary*dic in valueArr)
    {
        [titlesArr addObject:dic[@"title"]];
        [itemsArr addObject:dic[@"answerList"]];
        [questionTypesArr addObject:dic[@"type"]];
        NSMutableArray*arr=[[NSMutableArray alloc]init];
        for(NSDictionary*dict in dic[@"answerList"])
        {
            [arr addObject:dict[@"content"]];
        }
        [itemsOnlyArr addObject:arr];
    }
    /*
     缓存题目
     */
    [self saveQuestions];
    [self addQuestions];
}
-(void)saveQuestions
{
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        [GXUserInfoTool saveQuestionsArray:titlesArr withKey:TitlesArrayForQilu];
        [GXUserInfoTool saveQuestionsArray:itemsArr withKey:ItemsArrayForQilu];
        [GXUserInfoTool saveQuestionsArray:itemsOnlyArr withKey:ItemsOnlyArrayForQilu];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        [GXUserInfoTool saveQuestionsArray:titlesArr withKey:TitlesArrayForTianjin];
        [GXUserInfoTool saveQuestionsArray:itemsArr withKey:ItemsArrayTianjin];
        [GXUserInfoTool saveQuestionsArray:itemsOnlyArr withKey:ItemsOnlyArrayTianjin];
    }
}
#pragma mark--添加问卷题目
-(void)addQuestions
{
    for(int i=0;i<titlesArr.count;i++)
    {
        NSString*title=[titlesArr objectAtIndex:i];
        NSArray*itemArr=[itemsOnlyArr objectAtIndex:i];
        
        MySelectQuestionsView*selectView=[[[NSBundle mainBundle]loadNibNamed:@"MySelectQuestionsView" owner:self options:nil]lastObject];
        selectView.tag=i;
        selectView.delegate=self;
        selectView.arr_itemsAndScores=[[NSMutableArray alloc]initWithArray:itemsArr[i]];
        selectView.type=questionTypesArr[i];
        [selectView addItemViewWithQuestionTitle:[NSString stringWithFormat:@"%d.%@",i+1,title] andQuestionItems:itemArr];
        selectView.frame=CGRectMake(0, heightForScrollView, GXScreenWidth, selectView.viewHight);
        
        heightForScrollView+=selectView.viewHight+10;
        [self.bottomScrollView addSubview:selectView];
        //添加题标
        UILabel*markLabel=[[UILabel alloc]initWithFrame:CGRectMake(GXScreenWidth*i, selectView.viewHight+10, GXScreenWidth, 30)];
        markLabel.textAlignment=NSTextAlignmentCenter;
        markLabel.font=[UIFont boldSystemFontOfSize:12];
        markLabel.text=[NSString stringWithFormat:@"%d/%ld题",i+1,titlesArr.count];
        markLabel.backgroundColor=[UIColor clearColor];
        //[self.bottomScrollView addSubview:markLabel];
        
        if(i>0)
        {
            UIButton*btn_last=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn_last setTitle:@"返回上一题" forState:UIControlStateNormal];
            [btn_last setTitleColor:[UIColor colorWithRed:1.00 green:0.75 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
            btn_last.tag=i;
            btn_last.frame=CGRectMake(i*GXScreenWidth, selectView.viewHight+10, 100, 30);
            [btn_last addTarget:self action:@selector(lastQuestion:) forControlEvents:UIControlEventTouchUpInside];
            //[self.bottomScrollView addSubview:btn_last];
            
        }
        if(i<titlesArr.count-1)
        {
            UIButton*btn_next=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn_next setTitle:@"下一题" forState:UIControlStateNormal];
            [btn_next setTitleColor:[UIColor colorWithRed:1.00 green:0.75 blue:0.44 alpha:1.0] forState:UIControlStateNormal];
            btn_next.tag=i;
            btn_next.frame=CGRectMake(i*GXScreenWidth+GXScreenWidth-100, selectView.viewHight+10, 100, 30);
            [btn_next addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
            // [self.bottomScrollView addSubview:btn_next];
        }
        
    }
    self.bottomScrollView.contentSize=CGSizeMake(GXScreenWidth*titlesArr.count, heightForScrollView+30);
    self.bottomScrollView.bounces=NO;
    self.bottomScrollView.showsHorizontalScrollIndicator=NO;
    
    NSLayoutConstraint *scrollViewHeigh = [NSLayoutConstraint constraintWithItem:self.bottomScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:heightForScrollView+64+40];
    //[self.view addConstraint:scrollViewHeigh];
    
    [self.bottomScrollView setContentSize:CGSizeMake(GXScreenWidth, heightForScrollView-10)];
}
#pragma mark--MySelectQuestionViewDelegate
-(void)selectQuestionsWithTag:(NSInteger)questionTag forItemsWithTag:(NSInteger)itemTag
{
    NSArray*questionArr=[itemsArr objectAtIndex:questionTag];
    NSDictionary*questionDic=[questionArr objectAtIndex:itemTag];
    NSString*score=questionDic[@"score"];
    
    [selectScoreDic setObject:score forKey:[NSString stringWithFormat:@"%ld",questionTag+1]];//保存答题得分
    if(selectScoreDic.count ==titlesArr.count)
    {
        isFinishedAnswer=YES;
    }
}
-(void)selectShanxiQuestionsWithTag:(NSInteger)questionTag andHighestScore:(NSString*)highestScore andItemsNums:(NSString *)itemNums
{
    [selectScoreDic setObject:highestScore forKey:[NSString stringWithFormat:@"%ld",questionTag+1]];
    [selecNumDic setObject:itemNums forKey:[NSString stringWithFormat:@"%ld",questionTag+1]];
    if(itemNums.length==0)
    {
        //取消选择该项
        [selectScoreDic removeObjectForKey:[NSString stringWithFormat:@"%ld",questionTag+1]];
        [selecNumDic removeObjectForKey:[NSString stringWithFormat:@"%ld",questionTag+1]];
    }
    if(selectScoreDic.count==titlesArr.count)
    {
        isFinishedAnswer=YES;
    }
}
#pragma mark--重新答题
-(void)reAnswering
{
    isFinishedAnswer=NO;
    for(MySelectQuestionsView*selectView in self.bottomScrollView.subviews)
    {
        if([selectView isKindOfClass:[MySelectQuestionsView class]])
        {
            [selectView setAllItemsForUnselected];
        }
    }
    
    //清空答题结果
    [selectScoreDic removeAllObjects];
    
    //self.btn_nextStep.hidden=YES;
    self.bottomScrollView.contentOffset=CGPointMake(0, 0);
}

#pragma mark--提交一带一路开户数据
-(void)commitDataForAddCount
{
    NSMutableDictionary*commiteparamsDic=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    commiteparamsDic[@"customerId"]=[GXUserInfoTool getUserId];
    commiteparamsDic[@"source"]=@"ios";
    [self.view showLoadingWithTitle:@"正在提交数据……"];
    [GXHttpTool POST:GXUrl_openAccount parameters:commiteparamsDic success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:responseObject[@"value"][@"msg"]];
            GXAddShanxiAccountSuccessModel*model=[GXAddShanxiAccountSuccessModel mj_objectWithKeyValues:responseObject[@"value"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                GXAddShanxiAccountSuccessController*shanxiSucessVC=[[GXAddShanxiAccountSuccessController alloc]init];
                shanxiSucessVC.model=model;
                [self.navigationController pushViewController:shanxiSucessVC animated:YES];
            });
        }
        else
        {
            [MobClick event:@"uc_sxydyl_open_an_account_defeat"];
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
    }];
}

- (IBAction)btnClick_testAgain:(UIButton *)sender {
    self.view_answerResult.hidden=YES;
    [self reAnswering];
}





@end
