/******************************************************************************
*
* This is a proof of concept for auditing data in MySQL databases.
* It works by adding triggers to tables you want to audit. The triggers
* make sure the changed/inserted/deleted data gets written to another
* table, which is the Audit table. By reading out the Audit table,
* you can see what happened with all the data in the database
*
******************************************************************************/

/******************************************************************************
*                               SET UP DATABASE
******************************************************************************/

# We'll start with an easy table to add some data to
CREATE TABLE ship (
  ship_id INT(8) AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255)
) ENGINE = InnoDB;

# Now the audit table
# NOTE to use a user row (given no user is specified in the triggers)
# you have to specify it somewhere in the DB connection with:
# SET @username := 'admin'; and add a user row in this table
# NOTE operation is 'INS' - 'UPD' - 'DEL'
CREATE TABLE ship_audit (
  ship_id INT(8) AUTO_INCREMENT PRIMARY KEY,
  operation CHAR(3),
  updatedate DATETIME,
  name VARCHAR(255)
) ENGINE = InnoDB;

/******************************************************************************
*                               SET UP TRIGGERS
******************************************************************************/

# Define a delimiter for the entire following block now
delimiter //

# Start with the insert trigger. This gets called and run whenever an insert
# operation is run on the ship table. It adds a row into the audit table with
# the changes occured into the original ship table
CREATE DEFINER = CURRENT_USER TRIGGER ship_audit_ins
AFTER INSERT
ON ship
FOR EACH ROW
BEGIN
  INSERT INTO ship_audit (ship_id, operation, updatedate, name)
  VALUES (NEW.SHIP_ID, 'INS', NOW(), NEW.NAME);
END;
//

# And the update trigger. This gets called and run whenever an upate
# operation is run on the ship table. It adds a row into the audit table with
# the changes occured into the original ship table
CREATE DEFINER = CURRENT_USER TRIGGER ship_audit_upd
AFTER UPDATE
ON ship
FOR EACH ROW
BEGIN
  INSERT INTO ship_audit (ship_id, operation, updatedate, name)
  VALUES (NEW.SHIP_ID, 'UPD', NOW(), NEW.NAME);
END;
//

# Now the delete trigger. This gets called and run whenever a delete
# operation is run on the ship table. It adds a row into the audit table with
# the changes occured into the original ship table
CREATE DEFINER = CURRENT_USER TRIGGER ship_audit_del
AFTER DELETE
ON ship
FOR EACH ROW
BEGIN
  INSERT INTO ship_audit (ship_id, operation, updatedate, name)
  VALUES (OLD.SHIP_ID, 'DEL', NOW(), OLD.NAME);
END;
