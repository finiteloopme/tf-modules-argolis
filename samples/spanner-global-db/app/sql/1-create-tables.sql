-- This script creates four tables:
-- gcloud spanner databases create policu-svc-db --instance="quote-svc" --ddl="$(cat app/sql/1-raw.sql)"
-- insurance_policy: This table stores information about all the insurance policies in the system.
-- policyholder: This table stores information about the policyholders of the insurance policies.
-- address: This table stores information about addresses of the policyholders.
-- claim: This table stores information about claims that have been filed against insurance policies.
-- The policyholder_address table is a junction table between the policyholder table and the address table. It stores the relationship between policyholders and addresses.
-- The claim table has a foreign key to the insurance_policy table. This means that each claim must be associated with an insurance policy.

-- Create the insurance_policy table
CREATE TABLE insurance_policy (
  policy_id INT NOT NULL,
  policy_number VARCHAR(20) NOT NULL,
  policy_type VARCHAR(50) NOT NULL,
  policy_start_date DATE NOT NULL,
  policy_end_date DATE NOT NULL,
  premium DOUBLE NOT NULL,
  deductible DOUBLE NOT NULL,
  PRIMARY KEY (policy_id)
);

-- Create the policyholder table
CREATE TABLE policyholder (
  policyholder_id INT NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  email VARCHAR(50) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  PRIMARY KEY (policyholder_id)
);

-- Create the address table
CREATE TABLE address (
  address_id INT NOT NULL,
  street VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(2) NOT NULL,
  zip_code VARCHAR(10) NOT NULL,
  PRIMARY KEY (address_id)
);

-- Create the policyholder_address table
CREATE TABLE policyholder_address (
  policyholder_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (policyholder_id, address_id),
  FOREIGN KEY (policyholder_id) REFERENCES policyholder (policyholder_id),
  FOREIGN KEY (address_id) REFERENCES address (address_id)
);

-- Create the claim table
CREATE TABLE claim (
  claim_id INT NOT NULL,
  policy_id INT NOT NULL,
  claim_date DATE NOT NULL,
  claim_description VARCHAR(255) NOT NULL,
  claim_amount DOUBLE NOT NULL,
  claim_status VARCHAR(20) NOT NULL,
  PRIMARY KEY (claim_id),
  FOREIGN KEY (policy_id) REFERENCES insurance_policy (policy_id)
);


-- Create a variable to store the current date
DECLARE current_date DATE;
SET current_date = CURRENT_DATE();

-- Insert 10 policy records
INSERT INTO insurance_policy (policy_number, policy_type, policy_start_date, policy_end_date, premium, deductible)
VALUES
-- Auto
  ('1234567890', 'Auto', CURRENT_DATE, CURRENT_DATE + 3 MONTH, 800, 500),
  ('9876543210', 'Auto', CURRENT_DATE, CURRENT_DATE + 6 MONTH, 900, 500),
  ('0123456789', 'Auto', CURRENT_DATE, CURRENT_DATE + 9 MONTH, 1000, 500),
  ('2345678901', 'Auto', CURRENT_DATE, CURRENT_DATE + 1 YEAR, 1200, 600),
  ('3456789012', 'Auto', CURRENT_DATE, CURRENT_DATE + 2 YEAR, 1800, 800),
-- Home
  ('9000000028', 'Home', CURRENT_DATE, CURRENT_DATE + 3 MONTH, 400, 100),
  ('9000000029', 'Home', CURRENT_DATE, CURRENT_DATE + 6 MONTH, 600, 200),
  ('9000000030', 'Home', CURRENT_DATE, CURRENT_DATE + 9 MONTH, 700, 300),
  ('9000000031', 'Home', CURRENT_DATE, CURRENT_DATE + 1 YEAR, 1000, 500),
  ('9000000032', 'Home', CURRENT_DATE, CURRENT_DATE + 2 YEAR, 1400, 500),
  ('9000000033', 'Home', CURRENT_DATE, CURRENT_DATE + 3 YEAR, 2200, 500),
  ('9000000034', 'Home', CURRENT_DATE, CURRENT_DATE + 4 YEAR, 3200, 500),
  ('9000000035', 'Home', CURRENT_DATE, CURRENT_DATE + 5 YEAR, 4500, 500),
  ('9000000036', 'Home', CURRENT_DATE, CURRENT_DATE + 6 YEAR, 5600, 500),
-- Medical
  ('8901234598', 'Medical', CURRENT_DATE, CURRENT_DATE + 6 MONTH, 900, 100),
  ('8901234599', 'Medical', CURRENT_DATE, CURRENT_DATE + 9 MONTH, 1200, 200),
  ('9000000000', 'Medical', CURRENT_DATE, CURRENT_DATE + 1 YEAR, 1500, 300),
  ('9000000001', 'Medical', CURRENT_DATE, CURRENT_DATE + 2 YEAR, 2000, 400),
  ('9000000002', 'Medical', CURRENT_DATE, CURRENT_DATE + 3 YEAR, 2500, 500),
  ('9000000003', 'Medical', CURRENT_DATE, CURRENT_DATE + 4 YEAR, 3000, 600),
-- Car Rental
  ('9000000008', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 1 DAYS, 50, 0),
  ('9000000009', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 2 DAYS, 50, 10),
  ('9000000010', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 3 DAYS, 50, 20),
  ('9000000011', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 4 DAYS, 100, 0),
  ('9000000012', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 5 DAYS, 100, 10),
  ('9000000013', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 6 DAYS, 100, 20),
  ('9000000014', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 1 WEEK, 120, 0),
  ('9000000015', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 2 WEEK, 150, 10),
  ('9000000016', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 3 WEEK, 250, 10),
  ('9000000017', 'Car Rental', CURRENT_DATE, CURRENT_DATE + 1 MONTH, 320, 10),
-- Travel
  ('9000000018', 'Travel', CURRENT_DATE, CURRENT_DATE + 1 WEEK, 200, 100),
  ('9000000019', 'Travel', CURRENT_DATE, CURRENT_DATE + 2 WEEK, 300, 125),
  ('9000000020', 'Travel', CURRENT_DATE, CURRENT_DATE + 3 WEEK, 400, 150),
  ('9000000021', 'Travel', CURRENT_DATE, CURRENT_DATE + 4 WEEK, 450, 150),
  ('9000000022', 'Travel', CURRENT_DATE, CURRENT_DATE + 1 MONTH, 500, 150),
  ('9000000023', 'Travel', CURRENT_DATE, CURRENT_DATE + 2 MONTH, 700, 200),
  ('9000000024', 'Travel', CURRENT_DATE, CURRENT_DATE + 3 MONTH, 900, 200),
  ('9000000025', 'Travel', CURRENT_DATE, CURRENT_DATE + 6 MONTH, 1100, 200),
  ('9000000026', 'Travel', CURRENT_DATE, CURRENT_DATE + 1 YEAR, 1500, 200),
  ('9000000027', 'Travel', CURRENT_DATE, CURRENT_DATE + 2 YEAR, 2000, 200);