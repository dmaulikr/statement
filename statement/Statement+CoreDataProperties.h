//
//  Statement+CoreDataProperties.h
//  statement
//
//  Created by Alexander Kuhar on 6/17/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "Statement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Statement (CoreDataProperties)

+ (NSFetchRequest<Statement *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comments;
@property (nonatomic) int16_t completed;
@property (nullable, nonatomic, copy) NSDate *createdDate;
@property (nullable, nonatomic, copy) NSString *statementText;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
