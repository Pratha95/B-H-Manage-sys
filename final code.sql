use mydb;

create trigger `update`
after
insert on
cart for each row
begin
update products set Quantity = products.Quantity_In_Stock - cart.Quantity
where products.ProductsID = cart.Product_id15
END//
DELIMITER ;
select * from products; 
select * from customer;
insert into cart(Quantity,Customer_Customerid,Product_id15) values(5,11,1);
select * from cart;
delimiter $$
create procedure `Five most expensive products` ()
begin
select
 products.product_description as Fivemostexpensiveproducts,
 products.price
 from Products
 Order By products.price DESC
 Limit 5;
End$$;
 delimiter ;
 call `Five most expensive products`;
 
delimiter $$
create procedure `Invoice` (iuser int(10), iorderId int(5))
begin

select `order`.OrderDate, `order`.Confirmation_Number,payments.Payment_Amount,payments.Payment_date from order_status
INNER JOIN `order`
ON `order`.Order_Status_Order_Status_ID= `order_status`.Order_Status_ID
inner join payments
on payments.Customer_Customerid=`order`.Customer_Customerid
where order_status.Order_Status_ID = 
(select Order_Status_Order_Status_ID from `order`
where orderID = iorderId AND Customer_CustomerID = iuser ) AND Payment_ID= ( select invoices.payments_Payment_ID from  invoices where invoices.Order_OrderID= iorderId);

end$$
delimiter ;

select *  from `order`;
 
 call invoice(3,13);
 
delimiter %%
Create procedure `add to cart`(iuser int(10), ino int(10), iproduct int(20) )
begin

insert into cart values (ino,iuser,iproduct,'null');

select products.Product_Description,products.Price,cart.Quantity,(price*ino)  as total from products 
INNER JOIN cart  
on products.ProductsID=cart.Product_id15
where cart.Customer_Customerid=iuser;
end%%
delimiter ;

call `add to cart`(5,5,6);


select * from cart;

alter table cart drop primary key;
alter table cart add cartitemid integer(20) primary key auto_increment;

delimiter $$
create trigger `dispalaycustomer` after insert on `customer` 
for each row
begin



end$$
 delimiter ;


create view Quantity_in_Store
AS
select Store_Location_Name,City,State,ZipCode,Country,Product_Description,Quantity_In_Stock
from store INNER JOIN store_has_products 
ON store_has_products.Store_StoreID=store.StoreID
INNER JOIN products 
ON store_has_products.Products_ProductsID=products.ProductsID;

select * from Quantity_in_Store;	


create view product_all_aspects 
AS
select Product_Description,Quantity_In_Stock,Price,BrandName,Name 
from products 
INNER JOIN brands 
on brands.BrandID=products.Brands_BrandID
INNER JOIN catagory
ON catagory.CatagoryID=brands.Catagory_CatagoryID
group by price asc;

select * from product_all_aspects;


delimiter //
create trigger `orderstat`
after insert on payments 
for each row
begin
update `order` set Order_Status_Order_Status_ID=1 where payments.Customer_Customerid=`order`.Customer_Customerid AND ;
end//

delimiter ;

drop trigger `orderstat`;

select * from payments;
select * from `order`;


CREATE TABLE temp_status(order_id INT, status VARCHAR(10));

CREATE TABLE temp_orderdetails(order_id INT, order_no VARCHAR(10),status_copy VARCHAR(10));

CREATE TRIGGER temp_status_trigger
    AFTER INSERT ON temp_status
    FOR EACH ROW 
    BEGIN
    UPDATE temp_orderdetails
    SET status_copy = NEW.status
    WHERE order_id = NEW.order_id

delimiter ;

INSERT INTO temp_orderdetails(order_id, order_no)VALUES(1,'111');
INSERT INTO temp_orderdetails(order_id, order_no)VALUES(2,'222');
INSERT INTO temp_orderdetails(order_id, order_no)VALUES(3,'333');

INSERT INTO temp_status(order_id, status)VALUES(1,'Pending'),(2,'Pending');


CREATE TRIGGER temp_status_AfterUpdate
    AFTER UPDATE ON temp_status
    FOR EACH ROW BEGIN

    IF (OLD.status != NEW.status)
    THEN
      UPDATE temp_orderdetails
      SET status_copy = NEW.status
      WHERE order_id = NEW.order_id
delimiter ;

UPDATE temp_status
  SET status = 'Aproved'
WHERE order_id = 2;

CREATE TRIGGER trig_product
after insert on products
for each row
as
IF EXISTS (SELECT COUNT(*) FROM products)
  BEGIN
   INSERT INTO p (Name, Department) VALUES (???, ???)
  END


CREATE TABLE `total_products1` (
  `Kind` varchar(10) NOT NULL,
  `Type` varchar(10) NOT NULL,
  `Sno` varchar(10) NOT NULL,
  PRIMARY KEY (`Sno`)
);

CREATE TABLE `available_products1` (
  `Kind` varchar(10) NOT NULL,
  `Type` varchar(10) NOT NULL,
  `Sno` varchar(10) NOT NULL,
  `Status` char(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`Sno`)
) ;

CREATE TRIGGER new_product_added1 
AFTER INSERT ON total_products1
FOR EACH ROW 
  INSERT INTO available_products1 (Kind, Type, Sno, Status)
  VALUES (NEW.Kind, NEW.Type, NEW.Sno, 'Available');
  
  Insert into `total_products1` values ('mobile', 'samsung', 4);
  
select * from available_products1;