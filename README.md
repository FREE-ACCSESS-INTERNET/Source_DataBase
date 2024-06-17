# VPN Configurations Sales Management Database

This database manages the sale of VPN configurations to users, incorporating a referral system where users can invite friends and earn commissions. The structure supports user management, payment processing, referral tracking, and VPN configuration management.

## Database Structure

### Tables

1. **Status**
   - `Id`: INT, Primary Key
   - `Name`: NVARCHAR(50), Not Null

2. **Wallets**
   - `Id`: INT, Primary Key
   - `Balance`: DECIMAL(18, 2), Not Null

3. **Cards**
   - `Id`: INT, Primary Key
   - `WalletId`: INT, Not Null, Foreign Key references Wallets(Id)
   - `CardNumber`: NVARCHAR(50), Not Null
   - `CreatedAt`: DATETIME, Not Null

4. **Users**
   - `Id`: INT, Primary Key
   - `Name`: NVARCHAR(50), Not Null
   - `TelegramId`: NVARCHAR(50), Not Null
   - `Email`: NVARCHAR(50)
   - `WalletId`: INT, Not Null, Foreign Key references Wallets(Id)
   - `Status`: INT, Not Null, Foreign Key references Status(Id)
   - `RegisteredAt`: DATETIME, Not Null

5. **Referrals**
   - `Id`: INT, Primary Key
   - `UserId`: INT, Not Null, Foreign Key references Users(Id)
   - `ReferredById`: INT, Not Null, Foreign Key references Users(Id)

6. **Countries**
   - `Id`: INT, Primary Key
   - `Name`: NVARCHAR(50), Not Null

7. **Server**
   - `Id`: INT, Primary Key
   - `Name`: NVARCHAR(50), Not Null
   - `CountryId`: INT, Not Null, Foreign Key references Countries(Id)

8. **Payments**
   - `Id`: INT, Primary Key
   - `UserId`: INT, Not Null, Foreign Key references Users(Id)
   - `Amount`: DECIMAL(18, 2), Not Null
   - `Status`: INT, Not Null, Foreign Key references Status(Id)
   - `CreatedAt`: DATETIME, Not Null

9. **PaymentStatus**
   - `Id`: INT, Primary Key
   - `Status`: NVARCHAR(50), Not Null

10. **Configurations**
    - `Id`: INT, Primary Key
    - `UserId`: INT, Not Null, Foreign Key references Users(Id)
    - `ServerId`: INT, Not Null, Foreign Key references Server(Id)
    - `CreatedAt`: DATETIME, Not Null
    - `ExpireDate`: DATETIME, Not Null

11. **LastUsedGig**
    - `Id`: INT, Primary Key
    - `ConfigurationId`: INT, Not Null, Foreign Key references Configurations(Id)
    - `UsedGig`: DECIMAL(3, 2), Not Null
    - `UpdateDate`: DATETIME

12. **Paths**
    - `Id`: INT, Primary Key
    - `ServerId`: INT, Not Null, Foreign Key references Server(Id)
    - `Address`: NVARCHAR(50), Not Null
    - `Info`: NVARCHAR(200), Not Null
    - `CreatedAt`: DATETIME, Not Null
    - `Status`: INT, Not Null, Foreign Key references Status(Id)
    - `PricePerGig`: DECIMAL(18, 2), Not Null

13. **PathStatus**
    - `Id`: INT, Primary Key
    - `PathId`: INT, Not Null, Foreign Key references Paths(Id)
    - `Speed`: INT, Not Null
    - `Ping`: INT, Not Null
    - `CreatedAt`: DATETIME, Not Null

14. **Traffics**
    - `Id`: INT, Primary Key
    - `ConfigurationId`: INT, Not Null, Foreign Key references Configurations(Id)
    - `PathId`: INT, Not Null, Foreign Key references Paths(Id)
    - `CreatedAt`: DATETIME, Not Null
    - `Gig`: DECIMAL(3, 2), Not Null

15. **Transactions**
    - `Id`: INT, Primary Key
    - `TrafficsId`: INT, Not Null, Foreign Key references Traffics(Id)
    - `CreatedAt`: DATETIME, Not Null

16. **SubTransactions**
    - `Id`: INT, Primary Key
    - `TransactionId`: INT, Not Null, Foreign Key references Transactions(Id)
    - `Amount`: DECIMAL(18, 2), Not Null
    - `ReferralId`: INT, Not Null, Foreign Key references Referrals(Id)
    - `SellerWalletId`: INT, Not Null, Foreign Key references Wallets(Id)
    - `BuyerWalletId`: INT, Not Null, Foreign Key references Wallets(Id)
    - `Status`: INT, Not Null, Foreign Key references Status(Id)

### Features

- **User Management**: Handles user registration, status, and wallet integration.
- **Referral System**: Users can invite friends, and referrals are tracked for commission purposes.
- **Payment Processing**: Manages payments made by users for VPN services.
- **VPN Configuration Management**: Tracks VPN configurations, usage, and related transactions.
- **Traffic and Path Management**: Monitors VPN traffic and path statuses for quality and billing.




### Notes

- This schema supports a basic pyramid referral model where each user can refer others, and payments are processed through a central system.
- Ensure to handle sensitive information, like user payment details, securely in your implementation.

For any issues or further customization, please refer to the SQL Server documentation or reach out to your database administrator.
