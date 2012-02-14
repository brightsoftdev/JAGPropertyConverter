//
//  PropertyModelTests.m
//
//  Created by James Gill on 11/22/11.
//
// Copyright (c) 2012 James A. Gill
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PropertyModelTests.h"
#import "TestModel.h"
#import "JAGPropertyFinder.h"

@implementation PropertyModelTests


- (void) testMixedModelToDict {
    TestModel *model = [TestModel testModel];
    int intProp = 5;
    model.intProperty = intProp;
    NSString *stringProp = @"Title!";
    model.stringProperty = stringProp;
    
    TestModel *otherModel = [TestModel testModel];
    int otherIntProp = 9;
    otherModel.intProperty = otherIntProp;
    NSString *otherStringProp = @"More title";
    otherModel.stringProperty = otherStringProp;
    model.modelProperty = otherModel;
    
    NSDictionary *props = [model propertiesAsDictionary];
    STAssertEquals([[props valueForKey:@"intProperty"] intValue], intProp, 
                   @"props should have interProperty %d, but is %d", intProp,
                   [[props valueForKey:@"intProperty"] intValue]);
    STAssertEquals([props valueForKey:@"stringProperty"], stringProp, 
                   @"props should have stringProperty %@, but is %@", stringProp,
                   [props valueForKey:@"stringProperty"]);
    
    id foundOtherModel = [props valueForKey:@"modelProperty"];
    STAssertTrue([foundOtherModel isKindOfClass: [NSDictionary class]], 
                   @"modelProperty should be NSDictionary after parsing, but is %@.", [foundOtherModel class]);
    STAssertEquals([[foundOtherModel valueForKey:@"intProperty"] intValue], otherIntProp, 
                   @"foundOtherModel should have interProperty %d, but is %d", intProp,
                   [[foundOtherModel valueForKey:@"intProperty"] intValue]);
    STAssertEquals([foundOtherModel valueForKey:@"stringProperty"], otherStringProp, 
                   @"props should have stringProperty %@, but is %@", otherStringProp,
                   [foundOtherModel valueForKey:@"stringProperty"]);
    
}

- (void) testMixedModelFromDict {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    NSString *testModelID = @"A";
    [props setValue:testModelID forKey:@"testModelID"];
    int intProp = 5;
    [props setValue:[NSNumber numberWithInt:intProp] forKey:@"intProperty"];
    NSString *stringProp = @"Title!";
    [props setValue:stringProp forKey:@"stringProperty"];
    
    NSMutableDictionary *otherModelProps = [NSMutableDictionary dictionary];
    NSString *otherTestModelID = @"B";
    [otherModelProps setValue:otherTestModelID forKey:@"testModelID"];
    int otherIntProp = 9;
    [otherModelProps setValue:[NSNumber numberWithInt:otherIntProp] forKey:@"intProperty"];
    NSString *otherStringProp = @"More title";
    [otherModelProps setValue:otherStringProp forKey:@"stringProperty"];
    
    [props setValue:otherModelProps forKey:@"modelProperty"];
    
    TestModel *model = [TestModel testModel];
    [model setPropertiesFromDictionary:props];
    
    STAssertEquals(model.intProperty, intProp, 
                   @"model should have interProperty %d, but is %d", intProp,
                   model.intProperty);
    STAssertEquals(model.stringProperty, stringProp, 
                   @"model should have stringProperty %@, but is %@", stringProp,
                   model.stringProperty);
    
    TestModel *foundOtherModel = model.modelProperty;
    STAssertTrue([foundOtherModel isMemberOfClass: [TestModel class]], 
                 @"modelProperty should return a TestModel, but returned %@.", [foundOtherModel class]);
    STAssertEquals(foundOtherModel.intProperty, otherIntProp, 
                   @"other model should have intProperty %d, but is %d", otherIntProp,
                   foundOtherModel.intProperty);
    STAssertEquals(foundOtherModel.stringProperty, otherStringProp, 
                   @"other model should have stringProperty %@, but is %@", otherStringProp,
                   foundOtherModel.stringProperty);
    
}

- (void) testCoordinate {
    TestModel *model = [TestModel testModel];
    NSArray *propertyNames = [JAGPropertyFinder propertyNamesForClass:[TestModel class]];
    NSLog(@"Found property names for TestModel: %@", propertyNames);
    TestModel *model2 = [TestModel testModel];
    //We should not have crashed on coordinate here.
    [model2 setPropertiesFromDictionary:[model propertiesAsDictionary]];
}

/*
- (void) testGetIntProperty {}
- (void) testSetIntProperty {}

- (void) testGetModelProperty;
- (void) testSetModelProperty;

- (void) testGetArrayWithNumbersProperty;
- (void) testSetArrayWithNumbersProperty;

- (void) testGetArrayWithModelsProperty;
- (void) testSetArrayWithModelsProperty;

- (void) testGetSetWithNumbersProperty;
- (void) testSetSetWithNumbersProperty;

- (void) testGetSetWithModelsProperty;
- (void) testSetSetWithModelsProperty;

- (void) testGetDictionaryProperty;
- (void) testSetDictionaryProperty;
*/

@end
