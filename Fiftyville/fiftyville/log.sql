-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Identify which tables of data I have
.tables

-- See the types of data in crime_scene_reports
.schema

-- Look for crime scenes in day, month and year and look for the matching description (10:15)
SELECT *
FROM crime_scene_reports
WHERE day = 28
AND month = 7
AND year = 2021;

-- Look into the interviews of July 28, 2021 and with the word bakery in it

SELECT *
FROM interviews
WHERE day = 28
AND month = 7
AND year = 2021
AND transcript LIKE '%bakery%';

-- 1. Identify which origin_id's area from Fiftyville to match with the flights of July 29

SELECT *
FROM flights
WHERE origin_airport_id IN
    (SELECT id
    FROM airports
    WHERE city = 'Fiftyville')
AND day = 29
AND month = 7
AND year = 2021;

-- 1. identify the destination_airport_id of the flight leaving at 8:20

SELECT *
FROM airports
WHERE id =
    (SELECT destination_airport_id
    FROM flights
    WHERE hour = 8
    AND minute = 20);

-- 1. THE THIEF ESCAPED TO NEW YORK

-- 2. Check the transactions at atm that day on Leggett Street
SELECT *
FROM atm_transactions
WHERE day = 28
AND month = 7
AND year = 2021
AND atm_location = 'Leggett Street';

-- 2. Get the names of the people that made those transactions

SELECT name
FROM people
WHERE id IN
    (SELECT person_id
    FROM bank_accounts
    WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE day = 28
        AND month = 7
        AND year = 2021
        AND atm_location = 'Leggett Street'));

-- 2. Look into the bakery_security_logs of July 28, 2021, the exit status and compare licence plates

SELECT name
FROM people
WHERE license_plate IN
    (SELECT *
    FROM bakery_security_logs
    WHERE day = 28
    AND month = 7
    AND year = 2021
    AND activity = 'exit'
    AND minute >= 15
    AND minute <= 25)
AND id IN
    (SELECT person_id
    FROM bank_accounts
    WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE day = 28
        AND month = 7
        AND year = 2021
        AND atm_location = 'Leggett Street'));

-- 2. Identify possible phonecalls

SELECT caller
FROM phone_calls
WHERE day = 28
AND month = 7
AND year = 2021
AND duration < 60;

-- 2. match phonecall with license and account

SELECT name
FROM people
WHERE license_plate IN
    (SELECT license_plate
    FROM bakery_security_logs
    WHERE day = 28
    AND month = 7
    AND year = 2021
    AND activity = 'exit'
    AND minute >= 15
    AND minute <= 25)
AND id IN
    (SELECT person_id
    FROM bank_accounts
    WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE day = 28
        AND month = 7
        AND year = 2021
        AND atm_location = 'Leggett Street'))
AND phone_number IN
    (SELECT caller
    FROM phone_calls
    WHERE day = 28
    AND month = 7
    AND year = 2021
    AND duration < 60);

-- 2. match passport with phone_number, bank_account and lisence

SELECT name
FROM people
WHERE license_plate IN
    (SELECT license_plate
    FROM bakery_security_logs
    WHERE day = 28
    AND month = 7
    AND year = 2021
    AND activity = 'exit'
    AND minute >= 15
    AND minute <= 25)
AND id IN
    (SELECT person_id
    FROM bank_accounts
    WHERE account_number IN
        (SELECT account_number
        FROM atm_transactions
        WHERE day = 28
        AND month = 7
        AND year = 2021
        AND atm_location = 'Leggett Street'))
AND phone_number IN
    (SELECT caller
    FROM phone_calls
    WHERE day = 28
    AND month = 7
    AND year = 2021
    AND duration < 60)
AND passport_number IN
    (SELECT passport_number
    FROM passengers
    WHERE flight_id IN
        (SELECT id
        FROM flights
        WHERE id = 36));

-- 2. THIEF IS BRUCE

-- 3. Find who was the one talking to Bruce
SELECT name
FROM people
WHERE phone_number IN
    (SELECT receiver
    FROM phone_calls
    WHERE caller IN
        (SELECT phone_number
        FROM people
        WHERE name = 'Bruce')
    AND day = 28
    AND month = 7
    AND year = 2021
    AND duration < 60);

-- 3. THE ACCOMPLICE IS ROBIN