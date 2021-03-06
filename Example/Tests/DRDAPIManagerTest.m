//
//  DRDAPIManagerTest.m
//  DurandalNetworking
//
//  Created by 圣迪 on 16/1/13.
//  Copyright © 2016年 cendywang. All rights reserved.
//

#import "DRDTestCase.h"
#import <OCMock.h>
#import <DurandalNetworking/DRDGeneralAPI.h>
#import <DurandalNetworking/DRDAPIManager.h>
#import <DurandalNetworking/DRDAPIBatchAPIRequests.h>
#import <AFNetworking.h>

@interface DRDAPIManager (UnitTesting)

- (AFHTTPSessionManager *)sessionManagerWithAPI:(DRDBaseAPI<DRDAPI>*)api;

@end

@interface DRDAPIManagerTest : DRDTestCase

@end

@implementation DRDAPIManagerTest

- (void)testSharedManager {
    DRDAPIManager *manager = [[DRDAPIManager alloc] init];
    XCTAssert(manager == [DRDAPIManager sharedDRDAPIManager]);
}

- (void)testSendAPIRequest {
    id afnSession  = OCMClassMock([AFHTTPSessionManager class]);
    id partialMock = OCMPartialMock([DRDAPIManager sharedDRDAPIManager]);
    OCMStub([partialMock sessionManagerWithAPI:[OCMArg any]]).andReturn(afnSession);
    
    DRDGeneralAPI *generalAPI           = [[DRDGeneralAPI alloc] init];
    generalAPI.apiRequestMethodType     = DRDRequestMethodTypeGET;
    generalAPI.baseUrl                  = self.baseURLStr;
    
    [[DRDAPIManager sharedDRDAPIManager] sendAPIRequest:generalAPI];
    
    OCMVerify([afnSession GET:[OCMArg any]
                   parameters:[OCMArg any]
                     progress:[OCMArg any]
                      success:[OCMArg any]
                      failure:[OCMArg any]]);
    [partialMock stopMocking];
}

- (void)testSendBatchAPIRequests {
    id afnSession  = OCMClassMock([AFHTTPSessionManager class]);
    id partialMock = OCMPartialMock([DRDAPIManager sharedDRDAPIManager]);
    OCMStub([partialMock sessionManagerWithAPI:[OCMArg any]]).andReturn(afnSession);
    
    DRDGeneralAPI *generalAPIGet = [[DRDGeneralAPI alloc] init];
    generalAPIGet.apiRequestMethodType = DRDRequestMethodTypeGET;
    generalAPIGet.baseUrl = self.baseURLStr;
    
    DRDGeneralAPI *generalAPIPost = [[DRDGeneralAPI alloc] init];
    generalAPIPost.apiRequestMethodType = DRDRequestMethodTypePOST;
    generalAPIPost.baseUrl = self.baseURLStr;
    
    DRDAPIBatchAPIRequests *batchRequests = [[DRDAPIBatchAPIRequests alloc] init];
    [batchRequests addAPIRequest:generalAPIGet];
    [batchRequests addAPIRequest:generalAPIPost];
    
    [[DRDAPIManager sharedDRDAPIManager] sendBatchAPIRequests:batchRequests];
    
    OCMVerify([afnSession GET:[OCMArg any]
                   parameters:[OCMArg any]
                     progress:[OCMArg any]
                      success:[OCMArg any]
                      failure:[OCMArg any]]);
    OCMVerify([afnSession POST:[OCMArg any]
                    parameters:[OCMArg any]
                      progress:[OCMArg any]
                       success:[OCMArg any]
                       failure:[OCMArg any]]);
    [partialMock stopMocking];
}

@end
