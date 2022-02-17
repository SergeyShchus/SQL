USE CTEDB

IF EXISTS ( SELECT [name] FROM sys.tables WHERE [name] = 'test_ch2' )    
DROP TABLE test_ch2   
GO    
    
CREATE TABLE test_ch2   
(    
Item_ID int identity,    
parcel nvarchar(22) NOT NULL,    
type_parcel nvarchar(50) NULL,    
area numeric(38, 8) NULL,
division nvarchar(150) NULL)
   
    
GO   


insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:01', 'взяли', '2.49', 'зона 1');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:02', 'взяли', '1.12', 'зона 2');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:03', 'віддали', '0.16', 'зона 1');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:04', 'взяли', '3.08', 'зона 2');
insert into test_ch2(parcel, type_parcel, area, division) values ('1223284500:05', 'взяли', '0.57', 'зона 1');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:06', 'віддали', '2.11', 'зона 2');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:07', 'віддали', '1.18', 'зона 2');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:08', 'взяли', '2.97', 'зона 1');
insert into test_ch2 (parcel, type_parcel, area, division) values ('1223284500:09', 'віддали', '1.13', 'зона 3');

select * from test_ch2;