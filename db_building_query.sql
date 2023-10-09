create database apotek_rely;
use apotek_rely;

create table operators (
operator_id varchar(20),
associate_id varchar(20),
operator_type varchar(20),
operator_name varchar(40),
primary key(operator_id)
);

create table tenders (
tender_id smallint not null,
type_code varchar(10) not null,
tender_type varchar(20) not null,
rounding_direction varchar(4),
rounding_multiple decimal(10,5),
rounding_threshold decimal(10,5),
primary key(tender_id)
);


create table workstations (
workstation_id smallint not null,
workstation_location smallint,
type_code varchar(8),
workstation_mode varchar(12),
primary key(workstation_id)
);

create table currencies (
currency_code varchar(3) not null,
currency_name tinytext not null,
foreign_currency bool not null,
currency_rate decimal(10,5),
primary key(currency_code)
);

create table tax_groups (
tax_group_id varchar(12) not null,
tax_subtype varchar(12),
amount decimal(8,5) not null,
percent decimal(5,2) not null,
primary key(tax_group_id)
);

create table business_units (
unit_id smallint not null,
unit_name varchar(28) not null,
unit_type_code varchar(28) not null,
address_type_code varchar(20),
address_line varchar(100),
city varchar(80),
territory varchar(50),
postal_code varchar(12),
country varchar(56),
phone_area_code varchar(3),
local_no varchar(16),
extension_no varchar(16),
itu_country_code varchar(4),
website varchar(255),
primary key(unit_id)
);

create table transactions (
transaction_id char(28) not null,
zero_sales bool,
unit_id smallint not null,
workstation_id smallint not null,
operator_id varchar(20) not null,
sequence_no smallint,
currency_code varchar(3) not null,
transaction_status varchar(8) not null,
tender_id smallint,
sale_amount decimal(20,5),
rounding decimal(10,5),
net_amount decimal(20,5) not null,
tax_amount decimal(20,5),
vat_rate decimal(5,2),
vat_amount decimal(20,5),
begin_dt datetime not null,
end_dt datetime not null,
primary key(transaction_id),
foreign key(unit_id) references business_units(unit_id),
foreign key(workstation_id) references workstations(workstation_id),
foreign key(operator_id) references operators(operator_id),
foreign key(currency_code) references currencies(currency_code),
foreign key(tender_id) references tenders(tender_id)
);

create table receipts (
transaction_id char(28) not null,
receipt_text mediumtext,
receipt_image mediumblob,
foreign key(transaction_id) references transactions(transaction_id),
primary key(transaction_id)
);

create table items (
rsid varchar(16) not null,
gtin varchar(16) not null,
unit_cost decimal(10,5),
suggested_price decimal(10,5),
extended_ammount decimal(10,5),
short_desc varchar(16) not null,
in_stock bool not null,
quantity smallint,
primary key(rsid)
);

create table transaction_sale_items (
transaction_id char(28) not null,
cancel_flag bool not null,
entry_method varchar(8),
item_subtype varchar(10),
item_type varchar(16) not null,
gtin varchar(16) not null,
rsid varchar(16) not null,
merchandise_group smallint,
special_order_no varchar(16),
short_description varchar(32),
unit_cost_price decimal(10,2),
suggested_price decimal(10,2),
extended_amount decimal(10,2),
quantity decimal(10,5),
units decimal(10,2),
unit_of_measure char(2),
tax_group_id varchar(12),
loyalty_type varchar(28),
loyalty_points smallint,
price_type smallint,
sequence_no smallint not null,
dt datetime not null,
foreign key(transaction_id) references transactions(transaction_id),
foreign key(tax_group_id) references tax_groups(tax_group_id),
foreign key(rsid) references items(rsid),
primary key(transaction_id, sequence_no)
);


insert into business_units (unit_id, unit_name, unit_type_code) values (3004, "lalala", "lalala");
insert into business_units (unit_id, unit_name, unit_type_code) values (3000, "lalala", "lalala");
insert into workstations (workstation_id) values (1);
insert into workstations (workstation_id) values (10);
insert into workstations (workstation_id) values (37);
insert into operators (operator_id) values ("cashierid");
insert into operators (operator_id) values ("xstse04");
insert into operators (operator_id) values ("1234");
insert into currencies (currency_code, currency_name, foreign_currency) values ("SEK", "SEK", FALSE);
insert into tenders (tender_id, type_code, tender_type) values (1, "stuff", "stuff");
insert into tax_groups (tax_group_id, amount, percent) values ("04999", 10.0, 10.0);
insert into tax_groups (tax_group_id, amount, percent) values ("4999", 10.0, 10.0);
insert into items (rsid, gtin, short_desc, in_stock) values ("100000","100000","stuff", True);
insert into items (rsid, gtin, short_desc, in_stock) values ("100060","100060","stuff", True);
insert into items (rsid, gtin, short_desc, in_stock) values ("12302","7046265478027","stuff", True);