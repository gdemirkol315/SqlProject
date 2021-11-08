-- Below 3 insert statements will fail due to trigger booking_time_range_check
INSERT INTO booking (booking_id, guest_id, accommodation_id, booking_from, booking_until, booking_status_id)
    VALUES (61, 1, 13, str_to_date('06.05.2022','%d.%m.%Y'), str_to_date('06.06.2022','%d.%m.%Y'), 6);
INSERT INTO booking (booking_id, guest_id, accommodation_id, booking_from, booking_until, booking_status_id)
    VALUES (113, 19, 16, str_to_date('04.09.2021','%d.%m.%Y'), str_to_date('21.10.2021','%d.%m.%Y'), 4);
INSERT INTO booking (booking_id, guest_id, accommodation_id, booking_from, booking_until, booking_status_id)
    VALUES (131, 13, 40, str_to_date('23.06.2021','%d.%m.%Y'), str_to_date('28.07.2021','%d.%m.%Y'), 2);

-- Below 3 insert statements will fail due to trigger ac_time_range_check
INSERT INTO accommodation_calendar (accommodation_calendar_id,accommodation_id,valid_from,valid_to,is_available,price_per_night,currency_id)
    VALUES (752,3,'2023-06-12','2023-06-18',1,30.5500,64);
INSERT INTO accommodation_calendar (accommodation_calendar_id,accommodation_id,valid_from,valid_to,is_available,price_per_night,currency_id)
    VALUES (753,23,'2023-01-29','2023-01-30',1,150.0900,160);
INSERT INTO accommodation_calendar (accommodation_calendar_id,accommodation_id,valid_from,valid_to,is_available,price_per_night,currency_id)
    VALUES (754,27,'2023-09-21','2023-09-23',1,20.8200,110);

-- Cascade on accommodation_pic for accommodations.
select * from accommodation_pic where accommodation_id=61;
-- with this select you will see 2 accommodation_pic entries
-- Below delete will only work for accommodations which does not have bookings. These accommodations will not be deleted
-- as they are foreign keys connected to booking table
delete from accommodation where accommodation_id=61;
-- after deleting the row in accommodation select again these accommodation_pics, you will not see any entries
select * from accommodation_pic where accommodation_id=61;