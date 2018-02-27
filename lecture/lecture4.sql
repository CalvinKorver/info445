-- Error Handling


/*
    Old School vs New School
        Raise Error, Throw Error

    Fail Early! - Avoid doing extra work
    Avoid affecting other transactions
        - Cascading rollbacks
            Whats this?
        - Long duration blocking
*/


/*
Old School

Flexible because you can have context - pass additional information pertaining to when and where the error occurred
*/
IF @ProdID is null
    BEGIN
    PRINT 'Prod Value NOT FOUND'
    RaiseError @ProdID cannot be null; session terminate
    Return
    END

-- New School
IF @ProdID is null
    BEGIN
    PRINT 'Prod Value NOT FOUND'
    Throw '@ProdID cannot be null';
    END


/*

How do we process many to many relationships?


High Availability
    The ability to process a transaction
    The transaction is able to be complete
    People are able to access the db 24/7
    
    How do we measure it?
        Measure it in seconds
        Degrees of HA (NOT all nothing) 99.99999%?
        Looks alive vs is alive

Scalability
    The ability to increase connections or throughput (# of trans. / time)

    2 Methods:
    
    1. Scale UP
        Add hardware to a single node
        Upgrading to a larger node
    
    2. Scale OUT
        Adding more nodes
        Spreading the data and workload among them
    
Uptime
    Ability to complete a transaction or read data
    Measured in minutes or seconds per year
        May include data loss and still be acceptable
        Often includes automatic failover but does not have to

Downtime
    Can be planned or unplanned

Data Loss
    Highly available does not rule out data loss
        Acceptable depending on application needs


Synchronous
    Communications are serial
        In db terms, transactions wait for commit confirmation


Asynchronous
    Communications are parallel
        Transactions do not wait for commit confirmation
 
