-- this file aims to create the table in the SQL Server


-- create the table

CREATE If NOT EXISTS TABLE [dbo].[Status] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE If NOT EXISTS TABLE [dbo].[Users] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [TelgramId] NVARCHAR(50) NOT NULL,
    [TelegramInfo] NVARCHAR(200) NOT NULL,
    [CreatedAt] DATETIME NOT NULL
);

CREATE If NOT EXISTS TABLE [dbo].[Wallets] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [UserId] INT NOT NULL,
    [Balance] DECIMAL(18, 2) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Referrals] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [UserId] INT NOT NULL,
    [ReferralId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL, 
    [Status] INT NOT NULL,
    [WalletId] INT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (ReferralId) REFERENCES Users(Id),
    FOREIGN KEY (WalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Countries] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
);

CREATE If NOT EXISTS TABLE [dbo].[Server] (
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

CREATE If NOT EXISTS TABLE [dbo].[Payments] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [BuyerWalletId] INT NOT NULL,
    [SellerWalletId] INT NOT NULL,
    [Amount] DECIMAL(18, 2) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (BuyerWalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (SellerWalletId) REFERENCES Wallets(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[PaymentsStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [Status] NVARCHAR(50) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [PaymentId] INT NOT NULL,
    FOREIGN KEY (PaymentId) REFERENCES Payments(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Configurations] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [WalletId] INT NOT NULL,
    [ServerId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [ConfTemplate] NVARCHAR(200) NOT NULL,
    [UsedGig] INT NOT NULL,
    [MaxGig] INT NOT NULL,
    FOREIGN KEY (WalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (ServerId) REFERENCES Server(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[LastUsedGig] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ConfigurationId] INT NOT NULL,
    [UsedGig] INT NOT NULL,
    FOREIGN KEY (ConfigurationId) REFERENCES Configurations(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Paths] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ServerId] INT NOT NULL,
    [Address] NVARCHAR(50) NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [Status] INT NOT NULL,
    [PricePerGig] DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (ServerId) REFERENCES Server(Id),
    FOREIGN KEY (Status) REFERENCES Status(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[PathStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [PathId] INT NOT NULL,
    [Speed] INT NOT NULL,
    [Ping] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (PathId) REFERENCES Paths(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Traffics] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [ConfigurationId] INT NOT NULL,
    [PathId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (ConfigurationId) REFERENCES Configurations(Id),
    FOREIGN KEY (PathId) REFERENCES Paths(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[Transactions] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [TrafficsId] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    FOREIGN KEY (TrafficsId) REFERENCES Traffics(Id)
);

CREATE If NOT EXISTS TABLE [dbo].[SubTransactions] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY,
    [TransactionId] INT NOT NULL,
    [Amount] DECIMAL(18, 2) NOT NULL,
    [ReferralId] INT NOT NULL,
    [SellerWalletId] INT NOT NULL,
    [BuyerWalletId] INT NOT NULL,
    FOREIGN KEY (TransactionId) REFERENCES Transactions(Id),
    FOREIGN KEY (ReferralId) REFERENCES Referrals(Id),
    FOREIGN KEY (SellerWalletId) REFERENCES Wallets(Id),
    FOREIGN KEY (BuyerWalletId) REFERENCES Wallets(Id)
);



    

    


