-- create the table

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


-- create tables for Data WareHouse 
CREATE SCHEMA NET AUTHORIZATION dbo;
CREATE SCHEMA Temp AUTHORIZATION dbo;

CREATE TABLE [Net].[DimServer] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [IP] NVARCHAR(50) NOT NULL,
    [Port] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [CountryName] NVARCHAR(50) NOT NULL
);

CREATE TABLE [Temp].[DimServer] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [IP] NVARCHAR(50) NOT NULL,
    [Port] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [CountryName] NVARCHAR(50) NOT NULL
);

CREATE TABLE [Net].[DimCountry] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE [temp].[DimCountry] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL
);


CREATE TABLE [temp].[DimPath] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Address] NVARCHAR(50) NOT NULL,
    [Info] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [PricePerGig] DECIMAL(18, 2) NOT NULL,
    [ServerName] NVARCHAR(50) NOT NULL,
    [ServerIP] NVARCHAR(50) NOT NULL,
    [ServerPort] INT NOT NULL,
    [ServerCreatedAt] DATETIME NOT NULL,
    [ServerStatus] NVARCHAR(50) NOT NULL,
    [ServerCountryName] NVARCHAR(50) NOT NULL
);

CREATE TABLE [Net].[DimPath] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Address] NVARCHAR(50) NOT NULL,
    [Info] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [PricePerGig] DECIMAL(18, 2) NOT NULL,
    [ServerName] NVARCHAR(50) NOT NULL,
    [ServerIP] NVARCHAR(50) NOT NULL,
    [ServerPort] INT NOT NULL,
    [ServerCreatedAt] DATETIME NOT NULL,
    [ServerStatus] NVARCHAR(50) NOT NULL,
    [ServerCountryName] NVARCHAR(50) NOT NULL
);

Create table [NET].[DimConfiguration] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [BussinessKey] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [ConfTemplate] NVARCHAR(200) NOT NULL,
    [UsedGig] INT NOT NULL,
    [MaxGig] INT NOT NULL,
    [ServerName] NVARCHAR(50) NOT NULL,
    [ServerIP] NVARCHAR(50) NOT NULL,
    [ServerPort] INT NOT NULL,
    [ServerCreatedAt] DATETIME NOT NULL,
    [ServerStatus] NVARCHAR(50) NOT NULL,
    [ServerCountryName] NVARCHAR(50) NOT NULL,
    [PathAddress] NVARCHAR(50) NOT NULL,
    [PathInfo] NVARCHAR(200) NOT NULL,
    [PathCreatedAt] DATETIME NOT NULL,
    [PathStatus] NVARCHAR(50) NOT NULL,
    [PathPricePerGig] DECIMAL(18, 2) NOT NULL,
    [StartDate] DATETIME NOT NULL,
    [EndDate] DATETIME
);

Create table [Temp].[DimConfiguration] (
    [Id] INT NOT NULL PRIMARY KEY,
    [CreatedAt] DATETIME NOT NULL,
    [Status] NVARCHAR(50) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [ConfTemplate] NVARCHAR(200) NOT NULL,
    [UsedGig] INT NOT NULL,
    [MaxGig] INT NOT NULL,
    [ServerName] NVARCHAR(50) NOT NULL,
    [ServerIP] NVARCHAR(50) NOT NULL,
    [ServerPort] INT NOT NULL,
    [ServerCreatedAt] DATETIME NOT NULL,
    [ServerStatus] NVARCHAR(50) NOT NULL,
    [ServerCountryName] NVARCHAR(50) NOT NULL,
    [PathAddress] NVARCHAR(50) NOT NULL,
    [PathInfo] NVARCHAR(200) NOT NULL,
    [PathCreatedAt] DATETIME NOT NULL,
    [PathStatus] NVARCHAR(50) NOT NULL,
    [PathPricePerGig] DECIMAL(18, 2) NOT NULL
);

-- SCD type 3 for Telegram ID and Telegram Info

Create table [NET].[DimUser] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [TelgramId] NVARCHAR(50) NOT NULL,
    [TelegramInfo] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [InviteCode] NVARCHAR(50) NOT NULL,
    [TelegramIdOld] NVARCHAR(50),
    [TelegramInfoOld] NVARCHAR(200)
);

Create table [Temp].[DimUser] (
    [Id] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL,
    [TelgramId] NVARCHAR(50) NOT NULL,
    [TelegramInfo] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [InviteCode] NVARCHAR(50) NOT NULL,
    [TelegramIdOld] NVARCHAR(50),
    [TelegramInfoOld] NVARCHAR(200)
);


CREATE TABLE [NET].[DimDate] (
    Date DATE,
    Year INT,
    Month INT,
    Day INT,
    Weekday INT,
    Hour INT,
    Minute INT
);

-- fact table SubTransaction
CREATE TABLE [NET].[FactSubTransaction] (
    [Id] INT NOT NULL PRIMARY KEY,
    Date INT NOT NULL,
    UserId INT NOT NULL,
    ParentId INT NOT NULL,
    ConfigId INT NOT NULL,
    ServerId INT NOT NULL, 
    PathId INT NOT NULL,
    CountryId INT NOT NULL,
    UsedTraffic DECIMAL(18, 2) NOT NULL
);

create table [Net].[FactConfStatus](
    [ConfigId] INT NOT NULL PRIMARY KEY,
    UserId INT NOT NULL,
    ServerId INT NOT NULL,
    PathId INT NOT NULL,
    CountryId INT NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    UsedGig DECIMAL(3, 2) NOT NULL,
    TrafficsCount INT NOT NULL
);

create table [Net].[FactDailyPathStatus](
    pathId INT NOT NULL PRIMARY KEY,
    Date DATETIME,
    serverID INT, 
    CountryId INT, 
    ping INT, 
    speed INT
);