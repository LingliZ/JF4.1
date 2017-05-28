//
//  GXRSAEncryptor.h
//  GXApp
//
//  Created by WangLinfang on 16/8/30.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

//RSA加密

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface GXRSAEncryptor : NSObject
#pragma mark - Instance Methods

-(void) loadPublicKeyFromFile: (NSString*) derFilePath;
-(void) loadPublicKeyFromData: (NSData*) derData;

-(void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
-(void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;




-(NSString*) rsaEncryptString:(NSString*)string;
-(NSData*) rsaEncryptData:(NSData*)data ;

-(NSString*) rsaDecryptString:(NSString*)string;
-(NSData*) rsaDecryptData:(NSData*)data;





#pragma mark - Class Methods

+(void) setSharedInstance: (GXRSAEncryptor*)instance;
+(GXRSAEncryptor*) sharedInstance;

@end
