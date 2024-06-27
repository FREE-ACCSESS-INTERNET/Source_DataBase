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
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    insert into Wallets (Balance) values (0);
    SET @i = @i + 1;
END;

-- create 10000 Userse 
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    insert into Users (Name, TelgramId, TelegramInfo, CreatedAt, WalletId, InviteCode) values 
    ('User' + CAST(@i AS NVARCHAR(50)), 'TelgramId' + CAST(@i AS NVARCHAR(50)), 'TelegramInfo' + CAST(@i AS NVARCHAR(200)), GETDATE(), @i, 'InviteCode' + CAST(@i AS NVARCHAR(50)));
    SET @i = @i + 1;
END;

-- create 20000 Cards
DECLARE @i INT = 1;
WHILE @i <= 20000
BEGIN
    insert into Cards (WalletId, CardNumber, CreatedAt) values 
    (CEILING(i/2), 'CardNumber' + CAST(@i AS NVARCHAR(50)), GETDATE());
    SET @i = @i + 1;
END;

-- create 10000 Referrals
DECLARE @i INT = 2;
WHILE @i <= 10000
BEGIN
    insert into Referrals (UserId, ReferralId, CardID, Balance) values 
    (@i, @i - 1, @i, 0);
    SET @i = @i + 2;
END;

