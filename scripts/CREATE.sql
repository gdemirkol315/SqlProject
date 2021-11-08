CREATE DATABASE AIRBNB;
USE AIRBNB;

CREATE TABLE account(
	account_id int PRIMARY KEY,
	user_name varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	password_hash varchar(50) NOT NULL,
	first_name varchar(255) NOT NULL,
	last_name varchar(255) NOT NULL
	);
CREATE TABLE social_media_type(
	social_media_type_id int PRIMARY KEY,
	social_media_platform_name varchar(50) NOT NULL
	);

CREATE TABLE credit_card_vendor(
	credit_card_vendor_id int PRIMARY KEY,
	credit_card_vendor varchar(30) NOT NULL
	);

CREATE TABLE payment_status(
	payment_status_id int PRIMARY KEY,
	payment_status varchar(10) NOT NULL
	);
    

CREATE TABLE accommodation_type(
	accommodation_type_id int PRIMARY KEY,
	accommodation_type varchar(30) NOT NULL
	);
	
CREATE TABLE address(
	address_id int PRIMARY KEY,
	address varchar(255),
	postal_code varchar(10),
	city varchar(30) NOT NULL,
	country varchar(30) NOT NULL
	);

CREATE TABLE currency(
	currency_id int PRIMARY KEY,
	iso_code varchar(3) NOT NULL,
	currency_name varchar(50)
	);
CREATE TABLE guest(
	guest_id int PRIMARY KEY,
	invoice_address_id int NOT NULL,
	account_id int NOT NULL,
	profile_description varchar(5000),
	contact_email varchar(50),
	contact_phone varchar(20),
    FOREIGN KEY (invoice_address_id) REFERENCES address(address_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
	);
CREATE TABLE host(
	host_id int PRIMARY KEY,
	invoice_address_id int NOT NULL,
	account_id int NOT NULL,
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
	host_id int NOT NULL,
	social_media_type_id int NOT NULL,
	account_url varchar(1000) NOT NULL,
    FOREIGN KEY (host_id) REFERENCES host(host_id),
    FOREIGN KEY (social_media_type_id) REFERENCES social_media_type(social_media_type_id)
	);

CREATE TABLE social_media_profile_guest(
	social_media_profile_id int PRIMARY KEY,
	guest_id int NOT NULL,
	social_media_type_id int NOT NULL,
	account_url varchar(1000) NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (social_media_type_id) REFERENCES social_media_type(social_media_type_id)
	);

CREATE TABLE profile_pic_guest(
	picture_id int PRIMARY KEY,
	guest_id int NOT NULL,
	file_location varchar(1000) NOT NULL,
	title varchar(100),
	FOREIGN KEY (guest_id) REFERENCES guest(guest_id) ON DELETE CASCADE
	);

CREATE TABLE profile_pic_host(
	picture_id int PRIMARY KEY,
	host_id int NOT NULL,
	file_location varchar(1000) NOT NULL,
	title varchar(100),
    FOREIGN KEY (host_id) REFERENCES host(host_id) ON DELETE CASCADE
	);

CREATE TABLE accommodation(
	accommodation_id  int PRIMARY KEY,
    accommodation_type_id int,
    address_id int NOT NULL,
    capacity int,
    host_id int NOT NULL,
    description varchar(5000),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (accommodation_type_id) REFERENCES  accommodation_type(accommodation_type_id),
    FOREIGN KEY (host_id) REFERENCES host(host_id) ON DELETE CASCADE
    );

CREATE TABLE booking_status(
	booking_status_id int PRIMARY KEY,
	booking_status varchar(10) NOT NULL
	);

CREATE TABLE booking(
	booking_id int PRIMARY KEY,
	guest_id int NOT NULL,
	accommodation_id int NOT NULL,
	booking_from date NOT NULL,
	booking_until date NOT NULL,
	booking_status_id int NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id),
    FOREIGN KEY (booking_status_id) REFERENCES booking_status(booking_status_id)
	);

CREATE TABLE review(
	review_id int PRIMARY KEY,
	booking_id int NOT NULL,
	guest_comment varchar(2000),
	host_comment varchar(2000),
	guest_rating int,
	host_rating int,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
	);


CREATE TABLE payment(
	payment_id int PRIMARY KEY,
	booking_id int NOT NULL,
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
	accommodation_id int NOT NULL,
	file_location varchar(1000) NOT NULL,
	title varchar(100),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id) ON DELETE CASCADE
	);

CREATE TABLE accommodation_calendar(
	accommodation_calendar_id int PRIMARY KEY,
	accommodation_id int NOT NULL,
	valid_from date NOT NULL,
	valid_to date NOT NULL,
	is_available bool NOT NULL,
	price_per_night numeric (12,4) NOT NULL,
	currency_id int NOT NULL,
    FOREIGN KEY (currency_id) REFERENCES currency(currency_id),
    FOREIGN KEY (accommodation_id) REFERENCES accommodation(accommodation_id) ON DELETE CASCADE
	);

DELIMITER $$

CREATE TRIGGER booking_time_range_check
BEFORE INSERT ON booking
FOR EACH ROW
	BEGIN
		DECLARE count_existing_booking_range INT;
		SELECT count(booking_id) INTO count_existing_booking_range
			FROM booking b
            WHERE b.accommodation_id = new.accommodation_id and
				((b.booking_from BETWEEN new.booking_from and new.booking_until)
				or (b.booking_until BETWEEN new.booking_from and new.booking_until)
                or ((new.booking_from BETWEEN b.booking_from and b.booking_until)
                    and (new.booking_until BETWEEN b.booking_from and b.booking_until)));
        IF count_existing_booking_range>0 THEN
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'ERROR:There is already a booking during this dates for this accommodation! Entry not allowed!';
        END IF;
	END$$

CREATE TRIGGER ac_time_range_check
BEFORE INSERT ON accommodation_calendar
FOR EACH ROW
	BEGIN
		DECLARE count_existing_ac_range INT;
		SELECT count(accommodation_calendar_id) INTO count_existing_ac_range
			FROM accommodation_calendar ac
            WHERE ac.accommodation_id = new.accommodation_id and
				((ac.valid_from BETWEEN new.valid_from and new.valid_to)
				or (ac.valid_to BETWEEN new.valid_from and new.valid_to)
                or ((new.valid_from BETWEEN ac.valid_from and ac.valid_to)
                    and (new.valid_to BETWEEN ac.valid_from and ac.valid_to)));
        IF count_existing_ac_range>0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR:There is already accommodation calendar existing for this period!';
        END IF;
	END$$

DELIMITER ;

COMMIT;