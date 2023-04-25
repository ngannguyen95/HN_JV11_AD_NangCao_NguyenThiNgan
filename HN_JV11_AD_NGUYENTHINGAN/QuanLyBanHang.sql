create database qlbh;
use qlbh;
create table customer(
cId int auto_increment primary key,
cName varchar(25),
cage tinyint
);
create table `order`(
oId int auto_increment primary key,
cId int,
foreign key(cId) references customer(cId),
odate datetime,
oTotalPrice int
);
create table product(
pId int auto_increment primary key,
pName varchar (25),
pPrice int
);
create table orderdetail(
oId int,
foreign key (oId) references `order`(oId),
pId int,
foreign key(pId) references product(pId),
odQTY int
);
insert into customer(cname,cage)values
("Minh Quan",10),
("Ngoc Oanh",20),
("Hong Ha",50);
insert into `order`(cId,odate)values
(1,"2006-3-21"),(2,"2006-3-23"),(1,"2006-3-16");
insert into product(pName,pPrice)values
("May Giat",3),("Tu Lanh",5),("Dieu Hoa",7),("Quat",1),("Bep Dien",2);
insert into orderdetail(oId,pId,odQTY)values
(1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);

-- Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, 
-- danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn
select * from `order`
order by odate desc; 
-- Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pname,pPrice  from product 
where (pPrice = (select max(pPrice) from product))
group by pname,pPrice;
-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
select  c.cName,p.pName from customer c join `order` o on c.cId = o.cId  
join orderdetail od on o.oId = od.oId
join product p on  od.pId = p.pId;
-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select c.cname from customer c left join `order` o on c.cId = o.cId  
where c.cId not in (select cId from `order`);
-- Hiển thị chi tiết của từng hóa đơn
select o.oId,o.odate,od.odQTY,p.pName,p.pPrice from `order` o join orderdetail od on o.oId = od.oId
join product p on od.pId = p.pId;
-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của
 -- từng loại mặt hàng xuất hiện trong hóa đơn
 select o.oId,o.odate,sum(od.odQTY*p.pPrice) as `Total` from orderdetail od join  `order` o  on o.oId = od.oId
 join product p on od.pId = p.pId
 group by o.oId,o.odate;
-- Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị 
select sum(od.odQTY*p.pPrice) as "Sales" from orderdetail od join product p on od.pId = p.pId;
-- Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
alter table `order` drop constraint order_ibfk_1;
alter table orderdetail drop constraint orderdetail_ibfk_1;
alter table orderdetail drop constraint orderdetail_ibfk_2;
alter table customer modify cid int not null;
alter table customer drop primary key;
alter table `order` modify oid int not null;
alter table `order` drop primary key;
alter table product modify pid int not null;
alter table product drop primary key;

-- Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa
-- mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo
 delimiter //
create trigger cusUpdate
after update on customer for each row
begin 
update `order`
set cId = NEW.cId
where cId = Old.cId;
end //
 delimiter ;

-- Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ 
-- xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail
delimiter // 
create procedure delProduct(proName varchar (25))
begin
delete from product where pName like proName
update oderdetail 
set product.pId = oderdetail.pId
where product.pName;
end //
delimiter ;
call delProduct('Quat');





