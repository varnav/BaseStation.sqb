PRAGMA foreign_keys=OFF;
PRAGMA synchronous=OFF;
BEGIN TRANSACTION;
CREATE TEMP TABLE _csv_import(
  "icao24" TEXT,
  "registration" TEXT,
  "manufacturericao" TEXT,
  "manufacturername" TEXT,
  "model" TEXT,
  "typecode" TEXT,
  "serialnumber" TEXT,
  "linenumber" TEXT,
  "icaoaircrafttype" TEXT,
  "operator" TEXT,
  "operatorcallsign" TEXT,
  "operatoricao" TEXT,
  "operatoriata" TEXT,
  "owner" TEXT,
  "testreg" TEXT,
  "registered" TEXT,
  "reguntil" TEXT,
  "status" TEXT,
  "built" TEXT,
  "firstflightdate" TEXT,
  "seatconfiguration" TEXT,
  "engines" TEXT,
  "modes" TEXT,
  "adsb" TEXT,
  "acars" TEXT,
  "notes" TEXT,
  "categoryDescription" TEXT
);
.mode csv
.separator ","
.import aircraftDatabaseu.csv _csv_import
DROP TABLE IF EXISTS Aircraft;
CREATE TABLE Aircraft(ModeS CHAR(6) UNIQUE PRIMARY KEY, Registration, ICAOTypeCode, OperatorFlagCode, Manufacturer, Type, RegisteredOwners);
INSERT OR IGNORE INTO Aircraft SELECT icao24, registration, typecode, operatoricao, manufacturericao, REPLACE(model,"'", '`'), REPLACE(REPLACE(owner, X'0A', ' '),"'", '`')
FROM _csv_import WHERE registration!='' ORDER BY icao24;
DROP TABLE _csv_import;
COMMIT;
.exit
