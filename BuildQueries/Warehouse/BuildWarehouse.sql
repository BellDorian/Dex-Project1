-- Enforce Phone Format: ###-###-####
-- Email addresses cannot possibly contain > 320 characters

CREATE TABLE Customers (
    CustomerID INT NOT NULL IDENTITY (1,1),
    FirstName VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    PrimaryEmail VARCHAR(320) NOT NULL,
    Phone CHAR(12),
    PRIMARY KEY (CustomerID)
);

CREATE TABLE AlternateEmails (
    AltAddressID INT NOT NULL,
    CustomerID INT NOT NULL,
    EmailAddress VARCHAR(320) NOT NULL,
    CONSTRAINT FK_AlternateEmails_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    PRIMARY KEY (AltAddressID, CustomerID)
);


CREATE TABLE PaymentStatus (
    StatusCode INT NOT NULL,
    StatusMessage VARCHAR(20) NOT NULL,
    PRIMARY KEY (StatusCode)
);

CREATE TABLE Products (
    ProductID INT NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2), 
    PRIMARY KEY (ProductID)
);


CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Orders_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    StatusCode INT NOT NULL,
    CONSTRAINT FK_Orders_StatusCode FOREIGN KEY (StatusCode) REFERENCES PaymentStatus (StatusCode),
    DateOrdered TIMESTAMP NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID)
);


CREATE TABLE OrderDetails (
    ComponentID INT NOT NULL,
    OrderID INT NOT NULL,
    CONSTRAINT FK_OrderDetails_OrderID FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
    ProductID INT NOT NULL,
    CONSTRAINT FK_OrderDetails_ProductID FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
    Quantity INT NOT NULL,
    ComponentPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ComponentID, OrderID)
);

-- Make space for just under 1 trillion conversations to be stored using this schema
CREATE TABLE Conversations (
    ConvoID VARCHAR(13) NOT NULL,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Conversatons_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    PRIMARY KEY (ConvoID)
);

-- Use BIT for true/false. This is more consistent 
CREATE TABLE Messages (
    MessageID INT NOT NULL IDENTITY (1,1),
    ConvoID VARCHAR(13) NOT NULL,
    TimeSent TIMESTAMP NOT NULL,
    CONSTRAINT FK_Messages_ConvoID FOREIGN KEY (ConvoID) REFERENCES Conversations (ConvoID),
    SentByCustomer BIT,
    Content VARCHAR(500),
    PRIMARY KEY (MessageID)
);

CREATE TABLE SupportMessages (
    MessageID INT NOT NULL,
    CONSTRAINT FK_SupportMessages_MessageID FOREIGN KEY (MessageID) REFERENCES Messages (MessageID),
    AgentName VARCHAR(100) NOT NULL
    PRIMARY KEY (MessageID)
);

