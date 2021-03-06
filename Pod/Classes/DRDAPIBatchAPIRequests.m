//
//  DRDAPIBatchAPIRequests.m
//  Pods
//
//  Created by 圣迪 on 16/1/4.
//
//

#import "DRDAPIBatchAPIRequests.h"
#import "DRDBaseAPI.h"
#import "DRDAPIManager.h"

static  NSString * const hint = @"API should be kind of DRDBaseAPI and conform to protocol DRDAPI";

@interface DRDAPIBatchAPIRequests ()

@property (nonatomic, strong, readwrite) NSMutableSet *apiRequestsSet;

@end

@implementation DRDAPIBatchAPIRequests

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiRequestsSet = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Add Requests
- (void)addAPIRequest:(DRDBaseAPI<DRDAPI>*)api {
    NSParameterAssert(api);
    NSAssert([api isKindOfClass:[DRDBaseAPI class]] &&
             [api conformsToProtocol:@protocol(DRDAPI)],
             hint);
    [self.apiRequestsSet addObject:api];
}

- (void)addBatchAPIRequests:(NSSet *)apis {
    NSParameterAssert(apis);
    NSAssert([apis count] > 0, @"Apis amounts should greater than ZERO");
    [apis enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if ([obj isKindOfClass:[DRDBaseAPI class]] && [obj conformsToProtocol:@protocol(DRDAPI)]) {
            [self.apiRequestsSet addObject:obj];
        } else {
            __unused NSString *hintStr = [NSString stringWithFormat:@"%@ %@",
                                          [[obj class] description],
                                          hint];
            NSAssert(NO, hintStr);
            return ;
        }
    }];
}

- (void)start {
    NSAssert([self.apiRequestsSet count] != 0, @"Batch API Amount can't be 0");
    [[DRDAPIManager sharedDRDAPIManager] sendBatchAPIRequests:self];
}

@end
