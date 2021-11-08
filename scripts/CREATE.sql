CREATE DATABASE AIRBNB;
USE AIRBNB;

CREATE TABLE account(
	account_id int PRIMARY KEY,
	user_name varchar(50),
	email varchar(50),
	password_hash varchar(50),
	first_name varchar(255),
	last_name varchar(255)
	);
CREATE TABLE social_media_type(
	social_media_type_id int PRIMARY KEY,
	social_media_platform_name varchar(50)
	);

CREATE TABLE credit_card_vendor(
	credit_card_vendor_id int PRIMARY KEY,
	credit_card_vendor varchar(30)
	);

CREATE TABLE payment_status(
	payment_status_id int PRIMARY KEY,
	payment_status varchar(10)
	);
    

CREATE TABLE accommodation_type(
	accommodation_type_id int PRIMARY KEY,
	accommodation_type varchar(30)
	);
	
CREATE TABLE address(
	address_id int PRIMARY KEY,
	address varchar(255),
	postal_code varchar(10),
	city varchar(30),
	country varchar(30)
	);

CREATE TABLE currency(
	currency_id int PRIMARY KEY,
	iso_code varchar(3),
	currency_name varchar(50)
	);
CREATE TABLE guest(
	guest_id int PRIMARY KEY,
	invoice_address_id int,
	account_id int,
	profile_description varchar(5000),
	contact_email varchar(50),
	contact_phone varchar(20),
    FOREIGN KEY (invoice_address_id) REFERENCES address(address_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
	);
CREATE TABLE host(
	host_id int PRIMARY KEY,
	invoice_address_id int,
	account_id int,
	profile_description varchar(5000),
	contact_email varchar(50),
	contact_phone varchar(20),
	bank_account_number varchar(100),
	iban varchar(100),
	bic varchar(100),
    FOREIGN KEY (invoice_address_id) REFERENCES address(address_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
	);

CREATE TABLE social_media_profile_host(
	social_media_profile_id int PRIMARY KEY,
	host_id int,
	social_media_type_id int,
	account_url varchar(1000),
    FOREIGN KEY (host_id) REFERENCES host(host_id),
    FOREIGN KEY (social_media_type_id) REFERENCES social_media_type(social_media_type_id)
	);

CREATE TABLE social_media_profile_guest(
	social_media_profile_id int PRIMARY KEY,
	guest_id int,
	social_media_type_id int ,
	account_url varchar(1000),
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (social_media_type_id) REFERENCES social_media_type(social_media_type_id)
	);

CREATE TABLE profile_pic_guest(
	picture_id int PRIMARY KEY,
	guest_id int,
	file_location varchar(1000),
	title varchar(100),
	FOREIGN KEY (guest_id) REFERENCES guest(guest_id) ON DELETE CASCADE
	);

CREATE TABLE profile_pic_host(
	picture_id int PRIMARY KEY,
	host_id int,
	file_location varchar(1000),
	title varchar(100),
    FOREIGN KEY (host_id) REFERENCES host(host_id) ON DELETE CASCADE
	);

CREATE TABLE accommodation(
	accommodation_id  int PRIMARY KEY,
    accommodation_type_id int,
    address_id int,
    capacity int,
    host_id int,
    description varchar(5000),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (accommodation_type_id) REFERENCES  accommodation_type(accommodation_type_id),
    FOREIGN KEY (host_id) REFERENCES host(host_id) ON DELETE CASCADE
    );

CREATE TABLE booking_status(
	booking_status_id int PRIMARY KEY,
	booking_status varchar(10)
	);

CREATE TABLE booking(
	booking_id int PRIMARY KEY,
	guest_id int,
	accommodation_id int,
	booking_from date,
	booking_until date,
	booking_status_id int,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id),
    FOREIGN KEY (booking_status_id) REFERENCES booking_status(booking_status_id)
	);

CREATE TABLE review(
	review_id int PRIMARY KEY,
	booking_id int,
	guest_comment varchar(2000),
	host_comment varchar(2000),
	guest_rating int,
	host_rating int,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
	);


CREATE TABLE payment(
	payment_id int PRIMARY KEY,
	booking_id int,
	total_amount numeric(12,4),
	payment_date datetime,
	credit_card_number varchar(50),
	credit_card_security_number varchar(5),
	credit_card_validity_date date,
	credit_card_vendor_id int,
	commission_amount numeric(12,4),
	payment_status_id int,
	currency_id int,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
    FOREIGN KEY (credit_card_vendor_id) REFERENCES credit_card_vendor(credit_card_vendor_id),
    FOREIGN KEY (payment_status_id) REFERENCES payment_status(payment_status_id),
    FOREIGN KEY (currency_id) REFERENCES currency(currency_id)
	);

CREATE TABLE accommodation_pic(
	picture_id int PRIMARY KEY,
	accommodation_id int,
	file_location varchar(1000),
	title varchar(100),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id) ON DELETE CASCADE
	);

CREATE TABLE accommodation_calendar(
	accommodation_calendar_id int PRIMARY KEY,
	accommodation_id int,
	valid_from date,
	valid_to date,
	is_available bool,
	price_per_night numeric (12,4),
	currency_id int,
    FOREIGN KEY (currency_id) REFERENCES currency(currency_id),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id) ON DELETE CASCADE
	);

COMMIT;