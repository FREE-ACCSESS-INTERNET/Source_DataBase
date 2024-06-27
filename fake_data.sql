insert into Status (Name) values
('Active'), 
('Inactive'), 
('Blocked'), 
('Deleted'),
('Pending'),
('Success'),
('Failed'),
('Processing');

--  create 10000 wallets with a 0 balance
DECLARE @i1 INT = 1;
WHILE @i1 <= 10000
BEGIN
    insert into Wallets (Balance) values (0);
    SET @i1 = @i1 + 1;
END;

-- create 10000 Users
DECLARE @i2 INT = 1;
WHILE @i2 <= 10000
BEGIN
    insert into Users (Name, TelgramId, TelegramInfo, CreatedAt, WalletId, InviteCode) values 
    ('User' + CAST(@i2 AS NVARCHAR(50)), 'TelgramId' + CAST(@i2 AS NVARCHAR(50)), 'TelegramInfo' + CAST(@i2 AS NVARCHAR(200)), GETDATE(), @i2, 'InviteCode' + CAST(@i2 AS NVARCHAR(50)));
    SET @i2 = @i2 + 1;
END;

-- create 20000 Cards
DECLARE @i3 INT = 1;
WHILE @i3 <= 20000
BEGIN
    insert into Cards (WalletId, CardNumber, CreatedAt) values 
    (CEILING(@i3/4)+5, 'CardNumber' + CAST(@i3 AS NVARCHAR(50)), GETDATE());
    SET @i3 = @i3 + 1;
END;

-- create 10000 Referrals
DECLARE @i4 INT = 2;
WHILE @i4 <= 10000
BEGIN
    insert into Referrals (UserId, ReferralId, CardID, Balance) values 
    (@i4, @i4 - 1, @i4, 0);
    SET @i4 = @i4 + 2;
END;

DECLARE @i5 INT = 1;
WHILE @i5 <= 10000
BEGIN
    insert into Payments (BuyerWalletId, SellerCardId, Amount, CreatedAt) values 
    (FLOOR(RAND()*(10000-1+1))+1, FLOOR(RAND()*(20000-1+1))+1, RAND()*1000, GETDATE());
    SET @i5 = @i5 + 1;
END;

-- create 10 countries
insert into Countries (Name) values
('Iran'), 
('Turkey'), 
('Russia'), 
('China'),
('USA'),
('Germany'),
('France'),
('Italy'),
('Spain'),
('Canada');

DECLARE @i6 INT = 1;
WHILE @i6 <= 10
BEGIN
    insert into Server (Name, IP, Port, CreatedAt, Status, CountryId) values 
    ('Server' + CAST(@i6 AS NVARCHAR(50)), '192.168.1.' + CAST(@i6 AS NVARCHAR(50)), 8080, GETDATE(), 1, FLOOR(RAND()*(10-1+1))+1);
    SET @i6 = @i6 + 1;
END;

-- create 100 paths 
DECLARE @i7 INT = 1;
WHILE @i7 <= 100
BEGIN
    insert into Paths (ServerId, Address, Info, CreatedAt, Status, PricePerGig) values 
    (FLOOR(RAND()*(10-1+1))+1, 'Address' + CAST(@i7 AS NVARCHAR(50)), 'Info' + CAST(@i7 AS NVARCHAR(200)), GETDATE(), 1, RAND()*100);
    SET @i7 = @i7 + 1;
END;    

-- create 1000 configurations
DECLARE @i8 INT = 1;
WHILE @i8 <= 1000
BEGIN
    insert into Configurations (WalletId, ServerId, CreatedAt, Status, Name, ConfTemplate, UsedGig, MaxGig, ActivePathId) values 
    (FLOOR(RAND()*(10000-1+1))+1, FLOOR(RAND()*(10-1+1))+1, GETDATE(), 1, 'Name' + CAST(@i8 AS NVARCHAR(50)), 'ConfTemplate' + CAST(@i8 AS NVARCHAR(200)), 0, 100, FLOOR(RAND()*(100-1+1))+1);
    SET @i8 = @i8 + 1;
END;

DECLARE @i9 INT = 1;
WHILE @i9 <= 10000
BEGIN
    insert into Traffics (ConfigurationId, PathId, CreatedAt, Gig) values 
    (@i9, CEILING(i9/200)+1, GETDATE(), CEILING(i9/200)+1);
    SET @i9 = @i9 + 1;
END;

DECLARE @i10 INT = 1;
WHILE @i10 <= 10000
BEGIN
    insert into Transactions (TrafficsId, CreatedAt) values 
    (i10, GETDATE());
    SET @i10 = @i10 + 1;
END;

-- create 1000 subtransactions
DECLARE @i11 INT = 1;
DECLARE @transactionId INT = 1;
DECLARE @referralId INT = 1;
DECLARE @sellerWalletId INT = 1;
DECLARE @buyerWalletId INT = 1;
DECLARE @status INT = 1;

WHILE @i11 <= 1000
BEGIN
    insert into SubTransactions (TransactionId, Amount, ReferralId, SellerWalletId, BuyerWalletId, Status) values 
    (@transactionId, @i11 * 100, @referralId, @sellerWalletId, @buyerWalletId, @status);
    SET @i11 = @i11 + 1;
    SET @transactionId = @transactionId + 1;
    SET @referralId = @referralId + 1;
    SET @sellerWalletId = @sellerWalletId + 1;
    SET @buyerWalletId = @buyerWalletId + 1;
    SET @status = @status + 1;
END;
    

-- create 1000 pathstatus
DECLARE @i12 INT = 1;
WHILE @i12 <= 1000
BEGIN
    insert into PathStatus (PathId, Speed, Ping, CreatedAt) values 
    (FLOOR(CAST(RAND() * 100 AS INT))+1, FLOOR(CAST(RAND() * 100 AS INT))+1, FLOOR(CAST(RAND() * 100 AS INT))+1, GETDATE());
    SET @i12 = @i12 + 1;
END;

-- create 1000 lastusedgig
DECLARE @i13 INT = 1;
WHILE @i13 <= 1000
BEGIN
    insert into LastUsedGig (ConfigurationId, UsedGig, UpdateDate) values 
    (FLOOR(CAST(RAND() * 1000 AS INT))+1, CAST(RAND() * 100 AS DECIMAL(3, 2)), GETDATE());
    SET @i13 = @i13 + 1;
END;

-- create 1000 paymentsstatus
DECLARE @i14 INT = 1;
WHILE @i14 <= 1000
BEGIN
    insert into PaymentsStatus (Status, CreatedAt, PaymentId) values 
    (FLOOR(CAST(RAND() * 7 AS INT))+1, GETDATE(), FLOOR(CAST(RAND() * 10000 AS INT))+1);
    SET @i14 = @i14 + 1;
END;

-- create 1000 referralstatus
DECLARE @i15 INT = 1;
WHILE @i15 <= 1000
BEGIN
    insert into ReferralStatus (Status, CreatedAt, ReferralId) values 
    (FLOOR(CAST(RAND() * 7 AS INT))+1, GETDATE(), FLOOR(CAST(RAND() * 10000 AS INT))+1);
    SET @i15 = @i15 + 1;
END;
