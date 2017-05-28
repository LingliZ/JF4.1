//
//  GXAddAccountTool.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/4.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountTool.h"

@implementation GXAddAccountTool
+(void)getAccountStatusSuccess:(void (^)(id))success Failure:(void (^)(NSError *))failure
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"type"]=@"qiluce,tjpme,sxbrme";
    [GXHttpTool POST:GXUrl_get_open_account parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];

}
+(void)isAddAccountSucess:(void (^)(BOOL))success Failure:(void (^)(NSError *))failure
{
    [self getAccountStatusSuccess:^(id responseObject) {
        if([responseObject[@"success"]intValue]==1)
        {
            BOOL isAddAccount;
            for(NSDictionary*dic in responseObject[@"value"])
            {
                if([dic[@"account"]length]>0)
                {
                    isAddAccount=YES;
                }
                else{
                    isAddAccount=NO;
                }
            }
            success(isAddAccount);
        }
        else
        {
            success(responseObject);
        }
    } Failure:^(NSError *error) {
        
        failure(error);
    }];
}
+(void)getUserInfoSuccess:(void (^)(GXUserInfoModel *))success Failure:(void (^)(NSError *))failure
{
    [GXHttpTool POST:GXUrl_customerInfo parameters:nil success:^(id responseObject) {
        if([responseObject[@"success"]intValue]==1)
        {
            GXUserInfoModel*model=[GXUserInfoModel mj_objectWithKeyValues:responseObject[@"value"]];
            success(model);
        }
    } failure:^(NSError *error) {
        
    }];

}
@end
