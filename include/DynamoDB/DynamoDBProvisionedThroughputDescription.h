/*
 * Copyright 2010-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */




/**
 * Provisioned Throughput Description
 */

@interface DynamoDBProvisionedThroughputDescription:NSObject

{
    NSDate   *lastIncreaseDateTime;
    NSDate   *lastDecreaseDateTime;
    NSNumber *numberOfDecreasesToday;
    NSNumber *readCapacityUnits;
    NSNumber *writeCapacityUnits;
}




/**
 * Default constructor for a new  object.  Callers should use the
 * property methods to initialize this object after creating it.
 */
-(id)init;

/**
 * The date and time of the last provisioned throughput increase for this
 * table.
 */
@property (nonatomic, retain) NSDate *lastIncreaseDateTime;

/**
 * The date and time of the last provisioned throughput decrease for this
 * table.
 */
@property (nonatomic, retain) NSDate *lastDecreaseDateTime;

/**
 * The number of provisioned throughput decreases for this table during
 * this UTC calendar day. For current maximums on provisioned throughput
 * decreases, see <a
 * mazon.com/amazondynamodb/latest/developerguide/Limits.html">Limits</a>
 * in the <i>Amazon DynamoDB Developer Guide</i>.
 * <p>
 * <b>Constraints:</b><br/>
 * <b>Range: </b>1 - <br/>
 */
@property (nonatomic, retain) NSNumber *numberOfDecreasesToday;

/**
 * The maximum number of strongly consistent reads consumed per second
 * before Amazon DynamoDB returns a <i>ThrottlingException</i>.
 * Eventually consistent reads require less effort than strongly
 * consistent reads, so a setting of 50 <i>ReadCapacityUnits</i> per
 * second provides 100 eventually consistent <i>ReadCapacityUnits</i> per
 * second.
 * <p>
 * <b>Constraints:</b><br/>
 * <b>Range: </b>1 - <br/>
 */
@property (nonatomic, retain) NSNumber *readCapacityUnits;

/**
 * The maximum number of writes consumed per second before Amazon
 * DynamoDB returns a <i>ThrottlingException</i>.
 * <p>
 * <b>Constraints:</b><br/>
 * <b>Range: </b>1 - <br/>
 */
@property (nonatomic, retain) NSNumber *writeCapacityUnits;

/**
 * Returns a string representation of this object; useful for testing and
 * debugging.
 *
 * @return A string representation of this object.
 */
-(NSString *)description;


@end
