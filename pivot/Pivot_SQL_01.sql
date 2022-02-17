USE CTEDB

IF EXISTS ( SELECT [name] FROM sys.tables WHERE [name] = 'ItemDetails' )    
DROP TABLE test_supply    
GO    
    
CREATE TABLE test_supply    
(    
Item_ID int identity(1,1),    
supplier VARCHAR(100) NULL,    
product VARCHAR(100) NULL,    
volume int NULL)
   
    
GO   


insert into test_supply (supplier, product, volume) values ('A', 'Product 1', 928);
insert into test_supply (supplier, product, volume) values ('A', 'Product 1', 422);
insert into test_supply (supplier, product, volume) values ('A', 'Product 4', 164);
insert into test_supply (supplier, product, volume) values ('A', 'Product 1', 403);
insert into test_supply (supplier, product, volume) values ('A', 'Product 3', 26);
insert into test_supply (supplier, product, volume) values ('B', 'Product 4', 594);
insert into test_supply (supplier, product, volume) values ('B', 'Product 4', 989);
insert into test_supply (supplier, product, volume) values ('B', 'Product 3', 844);
insert into test_supply (supplier, product, volume) values ('B', 'Product 4', 870);
insert into test_supply (supplier, product, volume) values ('B', 'Product 2', 644);
insert into test_supply (supplier, product, volume) values ('C', 'Product 2', 733);
insert into test_supply (supplier, product, volume) values ('C', 'Product 2', 502);
insert into test_supply (supplier, product, volume) values ('C', 'Product 1', 97);
insert into test_supply (supplier, product, volume) values ('C', 'Product 3', 620);
insert into test_supply (supplier, product, volume) values ('C', 'Product 2', 776);

select * from test_supply;



----pivot table 1

select t.product, 
       sum(case when t.supplier = 'A' then t.volume end) as A
from test_supply t
group by t.product
order by t.product;


----pivot table 2

select t.product, 
       sum(case when t.supplier = 'A' then t.volume end) as A,
       sum(case when t.supplier = 'B' then t.volume end) as B,
       sum(case when t.supplier = 'C' then t.volume end) as C
from test_supply t
group by t.product
order by t.product;


----pivot table 3

select t.product,
       sum(case when t.supplier = 'A' then t.volume end) as A,
       sum(case when t.supplier = 'B' then t.volume end) as B,
       sum(case when t.supplier = 'C' then t.volume end) as C,
       sum(t.volume) as total_sum
from test_supply t
group by t.product;

----pivot table 4

select t.product,
       sum(case when t.supplier = 'A' then t.volume end) as A,
       sum(case when t.supplier = 'B' then t.volume end) as B,
       sum(case when t.supplier = 'C' then t.volume end) as C,
       sum(t.volume) as total_sum
from test_supply t
group by rollup(t.product);


----pivot table 5

select coalesce(t.product, 'total_sum') as product,
       sum(case when t.supplier = 'A' then t.volume end) as A,
       sum(case when t.supplier = 'B' then t.volume end) as B,
       sum(case when t.supplier = 'C' then t.volume end) as C,
       sum(t.volume) as total_sum
from test_supply t
group by rollup(t.product);



---------------------------------


select t.supplier,
       t.product,
       sum(t.volume) as agg
from test_supply t
group by t.product,
         t.supplier;

--все возможные итоги

select t.supplier, t.product, sum(t.volume) as agg
from test_supply t
group by t.supplier, t.product
union all
select null, t.product, sum(t.volume)
from test_supply t
group by t.product
union all
select t.supplier, null, sum(t.volume)
from test_supply t
group by t.supplier
union all
select null, null, sum(t.volume)
from test_supply t;

--OR:

select t.supplier, 
       t.product, 
       sum(t.volume) as agg
from test_supply t
group by cube(t.supplier, t.product);

--'total_sum' вместо NULL

select coalesce(t.supplier, 'total_sum') as supplier, 
       coalesce(t.product, 'total_sum') as product, 
       sum(t.volume) as agg
from test_supply t
group by cube(t.supplier, t.product);



--PIVOT:

select *
from ( select coalesce(t.supplier, 'total_sum') as supplier, 
	      coalesce(t.product, 'total_sum') as product, 
	      sum(t.volume) as agg
	from test_supply t
	group by cube(t.supplier, t.product)
      ) t
pivot (sum(agg) 
       for supplier in ("A", "B", "C", "total_sum")
       ) pvt	
;


--OR CTE:

with cte
as	(
	select coalesce(t.supplier, 'total_sum') as supplier, 
	         coalesce(t.product, 'total_sum') as product, 
	         sum(t.volume) as agg
	from test_supply t
	group by cube(t.supplier, t.product)
	)
select * from cte;


---------------------------------------------------

with cte
as	(
	select coalesce(t.supplier, 'total_sum') as supplier, 
	         coalesce(t.product, 'total_sum') as product, 
	         sum(t.volume) as agg
	from test_supply t
	group by cube(t.supplier, t.product)
	)
select distinct t.product, 
                    a.agg as A,
                    b.agg as B,
                    c.agg as C,
                    ts.agg as total_sum
from cte t
left join cte a
	on t.product = a.product and a.supplier = 'A'
left join cte b
	on t.product = b.product and b.supplier = 'B'
left join cte c
	on t.product = c.product and c.supplier = 'C'
left join cte ts
	on t.product = ts.product and ts.supplier = 'total_sum'
order by product;