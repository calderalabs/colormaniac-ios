//
//  CMTPurchaseButton.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 05/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKProduct;

@interface CMTPurchaseButton : UIButton {
	BOOL _confirm;
	
	SKProduct *_product;
	
	id _target;
	SEL _action;
}

- (id)initWithProduct:(SKProduct *)product;
- (void)setConfirm:(BOOL)confirm animated:(BOOL)animated;

@property (nonatomic, retain) SKProduct *product;
@property (nonatomic, assign, getter=isConfirming) BOOL confirm;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end
