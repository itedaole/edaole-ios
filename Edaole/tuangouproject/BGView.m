//
//  BGView.m
//  SUSHIDO
//
//  Created by WANG Mengke on 10-7-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BGView.h"

@implementation BGView

-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat colors[] =
		{
			243.0 / 255.0, 181.0 / 255.0, 206.0 / 255.0, 1.00,
			207.0 / 255.0, 170.0 / 255.0, 185.0 / 255.0, 1.00,
		};
		gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		CGColorSpaceRelease(rgb);
	}
	return self;
}

- (void)dealloc{
	CFRelease(gradient);
}

// Returns an appropriate starting point for the demonstration of a linear gradient
CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height);
}

- (void)drawRect:(CGRect)rect{
	CGPoint start, end;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
}

@end