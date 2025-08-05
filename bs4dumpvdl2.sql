PRAGMA foreign_keys=OFF;
PRAGMA synchronous=OFF;
BEGIN TRANSACTION;
CREATE TEMP TABLE _csv_import(
'icao24','timestamp','acars','adsb','built','categoryDescription','country','engines','firstFlightDate','firstSeen','icaoAircraftClass','lineNumber','manufacturerIcao','manufacturerName','model','modes','nextReg','notes','operator','operatorCallsign','operatorIata','operatorIcao','owner','prevReg','regUntil','registered','registration','selCal','serialNumber','status','typecode','vdl'
);
.mode csv
.separator ","
.import aircraftDatabaseu.csv _csv_import
DROP TABLE IF EXISTS Aircraft;
CREATE TABLE Aircraft(ModeS CHAR(6) UNIQUE PRIMARY KEY, Registration, ICAOTypeCode, OperatorFlagCode, Manufacturer, Type, RegisteredOwners);
INSERT OR IGNORE INTO Aircraft SELECT icao24, registration, typecode, operatoricao, manufacturericao, REPLACE(model,"'", '`'), REPLACE(REPLACE(owner, X'0A', ' '),"'", '`')
FROM _csv_import WHERE registration!='' ORDER BY icao24;
DROP TABLE _csv_import;
CREATE INDEX ix_aircraft_registration ON Aircraft(Registration);
COMMIT;
.exit
