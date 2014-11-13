CREATE SEQUENCE "organization_description_seq";
CREATE TABLE "organization_description" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('organization_description_seq'),
	"description" TEXT NOT NULL CHECK ("description" <> ''),
	CONSTRAINT "organization_description_id_pkey" PRIMARY KEY ("id")
);


CREATE SEQUENCE "organization_seq";
CREATE TABLE "organization" (
	"id" BIGINT NOT NULL DEFAULT NEXTVAL('organization_seq'),
	"name" VARCHAR(2048) NOT NULL CHECK ("name" <> '') UNIQUE,
	"description" BIGINT NOT NULL,
	"country" BIGINT NOT NULL,
	"section" BIGINT NOT NULL,
	"group" BIGINT NOT NULL,
	"division" BIGINT NOT NULL,
	"class" BIGINT NOT NULL,
	CONSTRAINT "organization_id_pkey" PRIMARY KEY ("id"),
	FOREIGN KEY ("description") REFERENCES "organization_description" ("id") ON DELETE RESTRICT,
	FOREIGN KEY ("country") REFERENCES "country_codes" ("id") ON DELETE RESTRICT,
	FOREIGN KEY ("section") REFERENCES "isic_section" ("id") ON DELETE RESTRICT,
	FOREIGN KEY ("group") REFERENCES "isic_group" ("id") ON DELETE RESTRICT,
	FOREIGN KEY ("division") REFERENCES "isic_division" ("id") ON DELETE RESTRICT,
	FOREIGN KEY ("class") REFERENCES "isic_class" ("id") ON DELETE RESTRICT
);

