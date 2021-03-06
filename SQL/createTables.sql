drop database if exists LiLac;
create database LiLac;
use LiLac;

/* Creating the schema for tables */
DROP TABLE IF EXISTS Flower;
CREATE TABLE Flower (
fName VARCHAR(50) NOT NULL UNIQUE,
color VARCHAR(25),
fPrice INT,
fID INT,
PRIMARY KEY(fID)
);

DROP TABLE IF EXISTS Bouquet;
CREATE TABLE Bouquet (
bPrice INT,
bName VARCHAR(50) NOT NULL UNIQUE,
numLeft INT,
fCount INT UNSIGNED,
fID INT,
bID INT,
PRIMARY KEY(bID),
FOREIGN KEY (fID) REFERENCES Flower(fID)
);

DROP TABLE IF EXISTS Florist;
CREATE TABLE Florist (
fID INT,
numFlower INT,
restockDate DATE,
FOREIGN KEY (fID) REFERENCES Flower(fID)
);

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
cID INT,
cName VARCHAR(50) NOT NULL UNIQUE,
PRIMARY KEY(cID)
);

DROP TABLE IF EXISTS Sale;
CREATE TABLE Sale
(cID INT,
bID INT,
pricePaid REAL DEFAULT NULL,
packaging VARCHAR(50),
FOREIGN KEY (bID) REFERENCES Bouquet (bID),
FOREIGN KEY (cID) REFERENCES Customer (cID)
);

/* Populating tables with data */
INSERT INTO Flower VALUES("Rose", "red", 3, 1001);
INSERT INTO Flower VALUES("Lily", "pink", 3, 1002);
INSERT INTO Flower VALUES("Tulip", "yellow", 5, 1003);
INSERT INTO Flower VALUES("Daisy", "white", 2, 1004);
INSERT INTO Flower VALUES("Sunflower", "yellow", 5, 1005);
 
INSERT INTO Bouquet VALUES(15, "Rose Bouquet", 3, 5, 1001, 1);
INSERT INTO Bouquet VALUES(30, "Lily Bouquet", 1, 10, 1002, 2);
INSERT INTO Bouquet VALUES(30, "Tulip Bouquet", 5, 6, 1003, 3);
INSERT INTO Bouquet VALUES(12, "Daisy Bouquet", 9, 6, 1004, 4); 
INSERT INTO Bouquet VALUES(20, "Sunflower Bouquet", 0, 4, 1005, 5);

INSERT INTO Florist VALUES(1001, 30, '2021-11-11');
INSERT INTO Florist VALUES(1002, 53, '2021-11-5');
INSERT INTO Florist VALUES(1003, 46, '2021-10-25');
INSERT INTO Florist VALUES(1004, 25, '2021-10-22');
INSERT INTO Florist VALUES(1005, 15, '2021-11-8');

INSERT INTO Customer VALUES(201, 'Gracie Chung');
INSERT INTO Customer VALUES(202, 'Alex Harris');
INSERT INTO Customer VALUES(203, 'Sungchan Jung');
INSERT INTO Customer VALUES(204, 'Erin Mac');
INSERT INTO Customer VALUES(205, 'Hayden Edwards');
INSERT INTO Customer VALUES(206, 'Sen Fall');
INSERT INTO Customer VALUES(207, 'Jisung Park');

INSERT INTO Sale VALUES(204, 2, 30, 'vase');
INSERT INTO Sale VALUES(204, 1, 15, 'vase');
INSERT INTO Sale VALUES(206, 5, 20, 'to go');
INSERT INTO Sale VALUES(207, 4, 12, 'vase');
INSERT INTO Sale VALUES(203, 3, 30, 'vase');
INSERT INTO Sale VALUES(201, 1, 15, 'vase');
INSERT INTO Sale VALUES(201, 1, 15, 'vase');

/* Trigger: whenever a new type of flower is added, florist buys 50 of them */
delimiter //
create trigger AddFlowerInventory 
after insert on Flower
for each row

begin
	IF (new.fID not in (select fID from florist))
    THEN
		insert into Florist values (new.fID, 50, CURDATE());
	END IF;
end; //

/* Trigger: whenever a new type of flower is added, florist creates a bouquet of that new flower.
The price of this new bouquet is 5 multiplied by the price of each flower. 
The name of this new bouquet is "name of flower" + "Bouquet"
The number of this bouquet is defaulted to 5. 
The amount of flowers in the bouquet is defaulted to 5. 
The bID of this new bouquet is 1 + highest bID
*/

delimiter //
create trigger AddFlowerBouquet
after insert on Flower
for each row
begin
    IF new.fID not in (select fID from Bouquet) 
    THEN
        insert into Bouquet values (5 * new.fPrice, CONCAT(new.fname, ' Bouquet') , 5, 5, new.fID, 1+(select max(bID) as bID from bouquet as b2));
    end if;
end; //

/* Stored procedure to get a customer's bouquet ID and bouquet type
Call example: 
mysql> call getCustomerBouquetByName('Erin Mac');
+--------------+
| bouquetName  |
+--------------+
| Lily Bouquet |
| Rose Bouquet |
+--------------+
*/
delimiter //
create procedure getCustomerBouquetByName(IN inputcName VARCHAR(50))
begin
	select Bouquet.bName as bouquetName
    from Customer
    inner join Sale using (cID)
    inner join Bouquet using (bID)
    where cName = inputcName;
end//
delimiter ;

/* Stored procedure to calculate a customer's total purchase 
Call example: 
mysql> call getTotalSpentByCustomerName('Erin Mac');
+------------+
| totalPrice |
+------------+
|         45 |
+------------+
*/
delimiter //
create procedure getTotalSpentByCustomerName(IN inputcName VARCHAR(50))
begin
	select sum(Sale.pricePaid) as totalPrice
    from Customer
    inner join Sale using (cID)
    where cName = inputcName;
end//
delimiter ;







