
CREATE TABLE Account
(
  account_id         NOT NULL,
  Name       VARCHAR NULL    ,
  ID         Integer NOT NULL,
  PRIMARY KEY (account_id)
);

CREATE TABLE Customer
(
  ID           Integer NOT NULL,
  Nmae         VARCHAR NOT NULL DEFAULT 홍길동,
  Acount_numer VARCHAR NULL    ,
  PRIMARY KEY (ID)
);

ALTER TABLE Account
  ADD CONSTRAINT FK_Customer_TO_Account
    FOREIGN KEY (ID)
    REFERENCES Customer (ID);
