CREATE SEQUENCE record_type_seq;
CREATE TABLE record_type (
    id BIGINT NOT NULL DEFAULT nextval('record_type_seq'),
    name VARCHAR(32) NOT NULL CHECK (name <> '') UNIQUE,
    CONSTRAINT rt_id_pkey PRIMARY KEY (id)
);

CREATE FUNCTION getRecordTypeId(t VARCHAR(32)) RETURNS BIGINT AS $$
DECLARE
    retval BIGINT;
BEGIN
    SELECT id INTO retval FROM record_type WHERE name = UPPER(t);
RETURN retval;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE registry_seq;
CREATE TABLE registry (
    id BIGINT NOT NULL DEFAULT NEXTVAL('registry_seq'),
    name VARCHAR(32) NOT NULL CHECK (name <> '') UNIQUE,
    CONSTRAINT re_id_pkey PRIMARY KEY (id)
);

CREATE FUNCTION getRegistryId(r VARCHAR(32)) RETURNS BIGINT AS $$
DECLARE
    retval BIGINT;
BEGIN
    SELECT id INTO retval FROM registry WHERE name = UPPER(r);
RETURN retval;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE entry_status_type_seq;
CREATE TABLE entry_status_type (
    id BIGINT NOT NULL DEFAULT NEXTVAL('entry_status_type_seq'),
    name VARCHAR(32) NOT NULL CHECK (name <> '') UNIQUE,
    CONSTRAINT es_id_pkey PRIMARY KEY (id)
);

CREATE FUNCTION getEntryStatusTypeId(t VARCHAR(32)) RETURNS BIGINT AS $$
DECLARE
    retval BIGINT;
BEGIN
    SELECT id INTO retval FROM entry_status_type WHERE name = UPPER(t);
RETURN retval;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE country_codes_seq;
CREATE TABLE country_codes (
    id BIGINT NOT NULL DEFAULT NEXTVAL('country_codes_seq'),
    name VARCHAR(64) NOT NULL CHECK (name <> '') UNIQUE,
    alpha2 CHAR(2) NOT NULL CHECK (alpha2 <> '') UNIQUE,
    alpha3 CHAR(3) NOT NULL CHECK (alpha3 <> '') UNIQUE,
    code SMALLINT NOT NULL CHECK (code <> 0) UNIQUE,
    iso_cc CHAR(2) NOT NULL CHECK (iso_cc <> ''),
    region_code SMALLINT NOT NULL CHECK (region_code <> 0),
    subregion_code SMALLINT NOT NULL CHECK (subregion_code <> 0),
    CONSTRAINT country_code_id_key PRIMARY KEY (id)
);

CREATE FUNCTION getCountryCodeId(c CHAR(2)) RETURNS BIGINT AS $$
DECLARE
    retval BIGINT;
BEGIN
    SELECT id INTO retval FROM country_codes WHERE iso_cc = UPPER(c);
RETURN retval;
END;
$$ LANGUAGE plpgsql;


CREATE SEQUENCE record_seq;
CREATE TABLE records (
    id BIGINT NOT NULL DEFAULT nextval('record_seq'),
    type BIGINT NOT NULL,
    registry BIGINT NOT NULL,
    etype BIGINT NOT NULL,
    country BIGINT NOT NULL,
    CONSTRAINT record_id_pkey PRIMARY KEY(id),
    FOREIGN KEY (type) REFERENCES record_type (id) ON DELETE RESTRICT,
    FOREIGN KEY (registry) REFERENCES registry (id) ON DELETE RESTRICT,
    FOREIGN KEY (etype) REFERENCES entry_status_type (id) ON DELETE RESTRICT,
    FOREIGN KEY (country) REFERENCES country_codes (id) ON DELETE RESTRICT
);

CREATE FUNCTION createNewRecord(t VARCHAR(32), r VARCHAR(32), e VARCHAR(32), c CHAR(2)) RETURNS BIGINT AS $$
DECLARE
    retval BIGINT;
BEGIN
    INSERT INTO records (type, registry,etype,country)
        VALUES (    (SELECT getRecordTypeId(t)),
                    (SELECT getRegistryId(r)),
                    (SELECT getEntryStatusTypeId(e)),
                    (SELECT getCountryCodeId(c))
        ) RETURNING id INTO retval;

RETURN retval;
END;
$$ LANGUAGE plpgsql;

INSERT INTO entry_status_type (name) VALUES ('ALLOCATED');
INSERT INTO entry_status_type (name) VALUES ('ASSIGNED');
INSERT INTO entry_status_type (name) VALUES ('RESERVED');
INSERT INTO entry_status_type (name) VALUES ('AVAILABLE');

INSERT INTO registry (name) VALUES ('AFRINIC');
INSERT INTO registry (name) VALUES ('APNIC');
INSERT INTO registry (name) VALUES ('ARIN');
INSERT INTO registry (name) VALUES ('IANA');
INSERT INTO registry (name) VALUES ('LACNIC');
INSERT INTO registry (name) VALUES ('RIPE-NCC');

INSERT INTO record_type (name) VALUES ('ASN');
INSERT INTO record_type (name) VALUES ('IPv4');
INSERT INTO record_type (name) VALUES ('IPv6');


INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
    VALUES ('Afghanistan','AF','AFG',004,'AF',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Åland Islands','AX','ALA',248,'AX',150,154);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Albania','AL','ALB',008,'AL',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Algeria','DZ','DZA',012,'DZ',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('American Samoa','AS','ASM',016,'AS',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Andorra','AD','AND',020,'AD',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Angola','AO','AGO',024,'AO',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Anguilla','AI','AIA',660,'AI',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Antarctica','AQ','ATA',010,'AQ',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Antigua and Barbuda','AG','ATG',028,'AG',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Argentina','AR','ARG',032,'AR',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Armenia','AM','ARM',051,'AM',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Aruba','AW','ABW',533,'AW',019,029);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Australia','AU','AUS',036,'AU',009,053);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Austria','AT','AUT',040,'AT',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Azerbaijan','AZ','AZE',031,'AZ',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bahamas','BS','BHS',044,'BS',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bahrain','BH','BHR',048,'BH',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bangladesh','BD','BGD',050,'BD',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Barbados','BB','BRB',052,'BB',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Belarus','BY','BLR',112,'BY',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Belgium','BE','BEL',056,'BE',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Belize','BZ','BLZ',084,'BZ',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Benin','BJ','BEN',204,'BJ',002,011);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bermuda','BM','BMU',060,'BM',019,021);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bhutan','BT','BTN',064,'BT',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Plurinational State of Bolivia','BO','BOL',068,'BO',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bonaire, Sint Eustatius and Saba','BQ','BES',535,'BQ',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bosnia and Herzegovina','BA','BIH',070,'BA',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Botswana','BW','BWA',072,'BW',002,018);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bouvet Island','BV','BVT',074,'BV',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Brazil','BR','BRA',076,'BR',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('British Indian Ocean Territory','IO','IOT',086,'IO',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Brunei Darussalam','BN','BRN',096,'BN',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Bulgaria','BG','BGR',100,'BG',150,151);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Burkina Faso','BF','BFA',854,'BF',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Burundi','BI','BDI',108,'BI',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cambodia','KH','KHM',116,'KH',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cameroon','CM','CMR',120,'CM',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Canada','CA','CAN',124,'CA',019,021);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cape Verde','CV','CPV',132,'CV',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cayman Islands','KY','CYM',136,'KY',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Central African Republic','CF','CAF',140,'CF',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Chad','TD','TCD',148,'TD',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Chile','CL','CHL',152,'CL',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('China','CN','CHN',156,'CN',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Christmas Island','CX','CXR',162,'CX',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cocos (Keeling) Islands','CC','CCK',166,'CC',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Colombia','CO','COL',170,'CO',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Comoros','KM','COM',174,'KM',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Congo','CG','COG',178,'CG',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('The Democratic Republic of the Congo','CD','COD',180,'CD',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Cook Islands','CK','COK',184,'CK',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Costa Rica','CR','CRI',188,'CR',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ($$Côte d'Ivoire$$,'CI','CIV',384,'CI',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Croatia','HR','HRV',191,'HR',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Cuba','CU','CUB',192,'CU',019,029);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Curaçao','CW','CUW',531,'CW',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Cyprus','CY','CYP',196,'CY',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Czech Republic','CZ','CZE',203,'CZ',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Denmark','DK','DNK',208,'DK',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Djibouti','DJ','DJI',262,'DJ',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Dominica','DM','DMA',212,'DM',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Dominican Republic','DO','DOM',214,'DO',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ecuador','EC','ECU',218,'EC',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Egypt','EG','EGY',818,'EG',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('El Salvador','SV','SLV',222,'SV',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Equatorial Guinea','GQ','GNQ',226,'GQ',002,017);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Eritrea','ER','ERI',232,'ER',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Estonia','EE','EST',233,'EE',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ethiopia','ET','ETH',231,'ET',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Falkland Islands (Malvinas)','FK','FLK',238,'FK',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Faroe Islands','FO','FRO',234,'FO',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Fiji','FJ','FJI',242,'FJ',009,054);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Finland','FI','FIN',246,'FI',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('France','FR','FRA',250,'FR',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('French Guiana','GF','GUF',254,'GF',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('French Polynesia','PF','PYF',258,'PF',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('French Southern Territories','TF','ATF',260,'TF',999,999);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Gabon','GA','GAB',266,'GA',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Gambia','GM','GMB',270,'GM',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Georgia','GE','GEO',268,'GE',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Germany','DE','DEU',276,'DE',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ghana','GH','GHA',288,'GH',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Gibraltar','GI','GIB',292,'GI',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Greece','GR','GRC',300,'GR',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Greenland','GL','GRL',304,'GL',019,021);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Grenada','GD','GRD',308,'GD',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guadeloupe','GP','GLP',312,'GP',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guam','GU','GUM',316,'GU',009,057);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guatemala','GT','GTM',320,'GT',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guernsey','GG','GGY',831,'GG',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guinea','GN','GIN',324,'GN',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guinea-Bissau','GW','GNB',624,'GW',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Guyana','GY','GUY',328,'GY',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Haiti','HT','HTI',332,'HT',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Heard Island and McDonald Islands','HM','HMD',334,'HM',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Holy See (Vatican City State)','VA','VAT',336,'VA',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Honduras','HN','HND',340,'HN',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Hong Kong','HK','HKG',344,'HK',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Hungary','HU','HUN',348,'HU',150,151);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Iceland','IS','ISL',352,'IS',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('India','IN','IND',356,'IN',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Indonesia','ID','IDN',360,'ID',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Islamic Republic of Iran','IR','IRN',364,'IR',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Iraq','IQ','IRQ',368,'IQ',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ireland','IE','IRL',372,'IE',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Isle of Man','IM','IMN',833,'IM',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Israel','IL','ISR',376,'IL',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Italy','IT','ITA',380,'IT',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Jamaica','JM','JAM',388,'JM',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Japan','JP','JPN',392,'JP',142,030);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Jersey','JE','JEY',832,'JE',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Jordan','JO','JOR',400,'JO',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Kazakhstan','KZ','KAZ',398,'KZ',142,143);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Kenya','KE','KEN',404,'KE',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Kiribati','KI','KIR',296,'KI',009,057);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ($$Democratic People's Republic of Korea$$,'KP','PRK',408,'KP',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Republic of Korea','KR','KOR',410,'KR',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Kuwait','KW','KWT',414,'KW',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ('Kyrgyzstan','KG','KGZ',417,'KG',142,143);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code)
VALUES ($$People's Democratic Republic of Lao$$,'LA','LAO',418,'LA',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Latvia','LV','LVA',428,'LV',150,154);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Lebanon','LB','LBN',422,'LB',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Lesotho','LS','LSO',426,'LS',002,018);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Liberia','LR','LBR',430,'LR',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Libya','LY','LBY',434,'LY',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Liechtenstein','LI','LIE',438,'LI',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Lithuania','LT','LTU',440,'LT',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Luxembourg','LU','LUX',442,'LU',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Macao','MO','MAC',446,'MO',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('The former Yugoslav Republic of Macdeonia','MK','MKD',807,'MK',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Madagascar','MG','MDG',450,'MG',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Malawi','MW','MWI',454,'MW',002,014);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Malaysia','MY','MYS',458,'MY',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Maldives','MV','MDV',462,'MV',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mali','ML','MLI',466,'ML',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Malta','MT','MLT',470,'MT',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Marshall Islands','MH','MHL',584,'MH',009,057);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Martinique','MQ','MTQ',474,'MQ',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mauritania','MR','MRT',478,'MR',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mauritius','MU','MUS',480,'MU',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mayotte','YT','MYT',175,'YT',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('The United States of Mexico','MX','MEX',484,'MX',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Federated States of Micronesia','FM','FSM',583,'FM',009,057);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Republic of Moldova','MD','MDA',498,'MD',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Monaco','MC','MCO',492,'MC',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mongolia','MN','MNG',496,'MN',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Montenegro','ME','MNE',499,'ME',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Montserrat','MS','MSR',500,'MS',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Morocco','MA','MAR',504,'MA',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Mozambique','MZ','MOZ',508,'MZ',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Myanmar','MM','MMR',104,'MM',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Namibia','NA','NAM',516,'NA',002,018);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Nauru','NR','NRU',520,'NR',009,057);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Nepal','NP','NPL',524,'NP',142,034);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Netherlands','NL','NLD',528,'NL',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('New Caledonia','NC','NCL',540,'NC',009,054);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('New Zealand','NZ','NZL',554,'NZ',009,053);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Nicaragua','NI','NIC',558,'NI',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Niger','NE','NER',562,'NE',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Nigeria','NG','NGA',566,'NG',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Niue','NU','NIU',570,'NU',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Norfolk Island','NF','NFK',574,'NF',009,053);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Northern Mariana Islands','MP','MNP',580,'MP',009,057);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Norway','NO','NOR',578,'NO',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Oman','OM','OMN',512,'OM',142,145);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Pakistan','PK','PAK',586,'PK',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Palau','PW','PLW',585,'PW',009,057);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('State of Palestine','PS','PSE',275,'PS',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Panama','PA','PAN',591,'PA',019,013);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Papua New Guinea','PG','PNG',598,'PG',009,054);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Paraguay','PY','PRY',600,'PY',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Peru','PE','PER',604,'PE',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Philippines','PH','PHL',608,'PH',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Pitcairn','PN','PCN',612,'PN',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Poland','PL','POL',616,'PL',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Portugal','PT','PRT',620,'PT',150,039);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Puerto Rico','PR','PRI',630,'PR',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Qatar','QA','QAT',634,'QA',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Réunion','RE','REU',638,'RE',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Romania','RO','ROU',642,'RO',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Russian Federation','RU','RUS',643,'RU',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Rwanda','RW','RWA',646,'RW',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Barthélemy','BL','BLM',652,'BL',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ascension and Tristan da Cunha Saint Helena','SH','SHN',654,'SH',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Kitts and Nevis','KN','KNA',659,'KN',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Lucia','LC','LCA',662,'LC',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Martin (French part)','MF','MAF',663,'MF',019,029);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Pierre and Miquelon','PM','SPM',666,'PM',019,021);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saint Vincent and the Grenadines','VC','VCT',670,'VC',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Samoa','WS','WSM',882,'WS',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('San Marino','SM','SMR',674,'SM',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sao Tome and Principe','ST','STP',678,'ST',002,017);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Saudi Arabia','SA','SAU',682,'SA',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Senegal','SN','SEN',686,'SN',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Serbia','RS','SRB',688,'RS',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Seychelles','SC','SYC',690,'SC',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sierra Leone','SL','SLE',694,'SL',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Singapore','SG','SGP',702,'SG',142,035);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sint Maarten (Dutch part)','SX','SXM',534,'SX',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Slovakia','SK','SVK',703,'SK',150,151);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Slovenia','SI','SVN',705,'SI',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Solomon Islands','SB','SLB',090,'SB',009,054);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Somalia','SO','SOM',706,'SO',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('South Africa','ZA','ZAF',710,'ZA',002,018);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('South Georgia and the South Sandwich Islands','GS','SGS',239,'GS',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('South Sudan','SS','SSD',728,'SS',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Spain','ES','ESP',724,'ES',150,039);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sri Lanka','LK','LKA',144,'LK',142,034);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sudan','SD','SDN',729,'SD',002,015);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Suriname','SR','SUR',740,'SR',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Svalbard and Jan Mayen','SJ','SJM',744,'SJ',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Swaziland','SZ','SWZ',748,'SZ',002,018);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Sweden','SE','SWE',752,'SE',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Switzerland','CH','CHE',756,'CH',150,155);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Syrian Arab Republic','SY','SYR',760,'SY',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Taiwan','TW','TWN',158,'TW',142,030);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Tajikistan','TJ','TJK',762,'TJ',142,143);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('United Republic of Tanzania','TZ','TZA',834,'TZ',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Thailand','TH','THA',764,'TH',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Timor-Leste','TL','TLS',626,'TL',142,035);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Togo','TG','TGO',768,'TG',002,011);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Tokelau','TK','TKL',772,'TK',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Tonga','TO','TON',776,'TO',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Trinidad and Tobago','TT','TTO',780,'TT',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Tunisia','TN','TUN',788,'TN',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Turkey','TR','TUR',792,'TR',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Turkmenistan','TM','TKM',795,'TM',142,143);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Turks and Caicos Islands','TC','TCA',796,'TC',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Tuvalu','TV','TUV',798,'TV',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Uganda','UG','UGA',800,'UG',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Ukraine','UA','UKR',804,'UA',150,151);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('United Arab Emirates','AE','ARE',784,'AE',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('United Kingdom','GB','GBR',826,'GB',150,154);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('United States','US','USA',840,'US',019,021);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('United States Minor Outlying Islands','UM','UMI',581,'UM',999,999);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Uruguay','UY','URY',858,'UY',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Uzbekistan','UZ','UZB',860,'UZ',142,143);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Vanuatu','VU','VUT',548,'VU',009,054);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Bolivarian Republic of Venezuela','VE','VEN',862,'VE',019,005);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Viet Nam','VN','VNM',704,'VN',142,035);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('British Virgin Islands','VG','VGB',092,'VG',019,029);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('U.S. Virgin Islands','VI','VIR',850,'VI',019,029);
INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Wallis and Futuna','WF','WLF',876,'WF',009,061);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Western Sahara','EH','ESH',732,'EH',002,015);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Yemen','YE','YEM',887,'YE',142,145);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Zambia','ZM','ZMB',894,'ZM',002,014);

INSERT INTO country_codes (name,alpha2,alpha3,code,iso_cc,region_code,subregion_code) 
VALUES ('Zimbabwe','ZW','ZWE',716,'ZW',002,014);
