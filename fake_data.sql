CREATE TABLE [dbo].[Status] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Wallets] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Balance] DECIMAL(18, 2) NOT NULL,
);

CREATE TABLE [dbo].[Cards] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [WalletId] INT NOT NULL,
    [CardNumber] NVARCHAR(50) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (WalletId) REFERENCES Wallets(Id)
);

CREATE TABLE [dbo].[Users] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [TelgramId] NVARCHAR(50) NOT NULL,
    [TelegramInfo] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [WalletId] INT NOT NULL,
    [InviteCode] NVARCHAR(50) NOT NULL,
    FOREIGN KEY (WalletId) REFERENCES Wallets(Id)
);

CREATE TABLE [dbo].[ReferralStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Status] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [ReferralId] INT NOT NULL,
    FOREIGN KEY (ReferralId) REFERENCES Users(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);


CREATE TABLE [dbo].[Referrals] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [UserId] INT NOT NULL,
    [ReferralId] INT NOT NULL,
    [CardID] INT NOT NULL,
    [Balance] DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (CardID) REFERENCES Cards(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (ReferralId) REFERENCES Users(Id),
);

CREATE TABLE [dbo].[Countries] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Server] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [IP] NVARCHAR(50) NOT NULL,
    [Port] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [CountryId] INT NOT NULL,
    FOREIGN KEY (CountryId) REFERENCES Countries(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE TABLE [dbo].[Payments] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [BuyerWalletId] INT NOT NULL,
    [SellerCardId] INT NOT NULL,
    [Amount] DECIMAL(18, 2) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (BuyerWalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (SellerCardId) REFERENCES Cards(Id)
);

CREATE TABLE [dbo].[PaymentsStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Status] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [PaymentId] INT NOT NULL,
    FOREIGN KEY (PaymentId) REFERENCES Payments(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE TABLE [dbo].[Paths] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ServerId] INT NOT NULL,
    [Address] NVARCHAR(50) NOT NULL,
    [Info] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [PricePerGig] DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (ServerId) REFERENCES Server(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE TABLE [dbo].[Configurations] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [WalletId] INT NOT NULL,
    [ServerId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [ConfTemplate] NVARCHAR(200) NOT NULL,
    [UsedGig] INT NOT NULL,
    [MaxGig] INT NOT NULL,
    [ActivePathId] INT NOT NULL,
    FOREIGN KEY (ActivePathId) REFERENCES Paths(Id),
    FOREIGN KEY (WalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (ServerId) REFERENCES Server(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE TABLE [dbo].[LastUsedGig] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ConfigurationId] INT NOT NULL,
    [UsedGig] DECIMAL(3, 2) NOT NULL,
    [UpdateDate] DATETIME,
    FOREIGN KEY (ConfigurationId) REFERENCES Configurations(Id)
);


CREATE TABLE [dbo].[PathStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [PathId] INT NOT NULL,
    [Speed] INT NOT NULL,
    [Ping] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (PathId) REFERENCES Paths(Id)
);

CREATE TABLE [dbo].[Traffics] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ConfigurationId] INT NOT NULL,
    [PathId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Gig] DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (ConfigurationId) REFERENCES Configurations(Id),
    FOREIGN KEY (PathId) REFERENCES Paths(Id)
);

CREATE TABLE [dbo].[Transactions] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [TrafficsId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (TrafficsId) REFERENCES Traffics(Id)
);

CREATE TABLE [dbo].[SubTransactions] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [TransactionId] INT NOT NULL,
    [Amount] DECIMAL(18, 2) NOT NULL,
    [ReferralId] INT NOT NULL,
    [SellerWalletId] INT NOT NULL,
    [BuyerWalletId] INT NOT NULL,
    [Status] INT NOT NULL,
    FOREIGN KEY (Status) REFERENCES Status(Id),
    FOREIGN KEY (TransactionId) REFERENCES Transactions(Id),
    FOREIGN KEY (ReferralId) REFERENCES Referrals(Id),
    FOREIGN KEY (SellerWalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (BuyerWalletId) REFERENCES Wallets(Id)
);


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

-- create 10000 Userse 
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
    (CEILING(@i3/2), 'CardNumber' + CAST(@i3 AS NVARCHAR(50)), GETDATE());
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

-- create 1000000 Payments 
DECLARE @i5 INT = 1;
WHILE @i5 <= 1000000
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

-- create 100 10 servers
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

-- create 5000000 traffics
DECLARE @i9 INT = 1;
WHILE @i9 <= 5000000
BEGIN
    insert into Traffics (ConfigurationId, PathId, CreatedAt, Gig) values 
    (FLOOR(RAND()*(1000-1+1))+1, FLOOR(RAND()*(100-1+1))+1, GETDATE(), RAND()*100);
    SET @i9 = @i9 + 1;
END;

-- create 5000000 transactions
DECLARE @i10 INT = 1;
WHILE @i10 <= 5000000
BEGIN
    insert into Transactions (TrafficsId, CreatedAt) values 
    (FLOOR(RAND()*(5000000-1+1))+1, GETDATE());
    SET @i10 = @i10 + 1;
END;

-- create 5000000 subtransactions
DECLARE @i11 INT = 1;
WHILE @i11 <= 5000000
BEGIN
    insert into SubTransactions (TransactionId, Amount, ReferralId, SellerWalletId, BuyerWalletId, Status) values 
    (FLOOR(RAND()*(5000000-1+1))+1, RAND()*100, FLOOR(RAND()*(10000-1+1))+1, FLOOR(RAND()*(10000-1+1))+1, FLOOR(RAND()*(10000-1+1))+1, FLOOR(RAND()*(7-1+1))+1);
    SET @i11 = @i11 + 1;
END;

