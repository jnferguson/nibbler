CREATE SEQUENCE "scan_status_seq";
CREATE TABLE "scan_status" (
	"id" BIGINT NOT NULL DEFAULT nextval('scan_status_seq'),
	"percent" SMALLINT NOT NULL DEFAULT 0 CHECK ("percent" <= 100),
	"time_start" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "scan_status_id_pkey" PRIMARY KEY("id")
);

CREATE TYPE scan_proto AS ENUM ('tcp', 'udp');
CREATE SEQUENCE "scan_data_seq";
CREATE TABLE "scan_data" (
	"id" BIGINT NOT NULL DEFAULT nextval('scan_data_seq'),
	"ssid" BIGINT NOT NULL,
	"address" CIDR NOT NULL,
	"port" INTEGER NOT NULL CHECK ("port" >= 0 AND "port" <= 65535),
	"protocol" scan_proto NOT NULL DEFAULT 'tcp',
	CONSTRAINT "scan_data_id_pkey" PRIMARY KEY("id"),
	FOREIGN KEY (ssid) REFERENCES scan_status (id) ON DELETE RESTRICT
);

CREATE TYPE port_status AS ENUM ('open', 'closed', 'unknown');
CREATE SEQUENCE "scan_address_data_seq";
CREATE TABLE "scan_address_data" (
	"id" BIGINT NOT NULL DEFAULT nextval('scan_address_data_seq'),
	"sid" BIGINT NOT NULL,  
	"address" INET NOT NULL UNIQUE,
	"port" INTEGER NOT NULL CHECK ("port" >= 0 AND "port" <= 65535),
	"status" port_status NOT NULL DEFAULT 'unknown',
	CONSTRAINT "scan_address_data_id_pkey" PRIMARY KEY("id"),
	FOREIGN KEY (sid) REFERENCES scan_data (id) ON DELETE RESTRICT
);

GRANT INSERT, SELECT, UPDATE, DELETE,TRUNCATE,REFERENCES ON scan_address_data,scan_data,scan_status TO inet_rw;
GRANT USAGE,SELECT,UPDATE ON scan_address_data_seq,scan_data_seq,scan_status_seq TO inet_rw;
GRANT SELECT ON scan_address_data,scan_data,scan_status TO inet_ro;
GRANT USAGE,SELECT ON scan_address_data_seq,scan_data_seq,scan_status_seq TO inet_ro; 

