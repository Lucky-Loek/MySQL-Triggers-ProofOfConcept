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
  ship_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
) ENGINE = InnoDB;

# Now the audit table
# NOTE to use this user row (given no user is specified in the triggers)
# you have to specify it somewhere in the DB connection with:
# SET @username := 'admin';
CREATE TABLE ship_audit (
  ship_id INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  operation CHAR(1),
  updatedate DATETIME,
  name DECIMAL(10,2)
/*  user VARCHAR(30)  */
) ENGINE = InnoDB;
