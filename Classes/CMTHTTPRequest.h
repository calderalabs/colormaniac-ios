//
//  CMTHTTPRequest.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 06/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface CMTHTTPRequest : ASIHTTPRequest {

}

+ (CMTHTTPRequest *)requestWithPath:(NSString *)path parameters:(NSString *)parameters format:(NSString *)format;
+ (CMTHTTPRequest *)requestWithPath:(NSString *)path parameters:(NSString *)parameters;
+ (CMTHTTPRequest *)requestWithPath:(NSString *)path;

@end
