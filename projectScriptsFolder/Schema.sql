START TRANSACTION;

CREATE TABLE "Projects" (
                            id uuid NOT NULL,
                            "licenseId" uuid NOT NULL,
                            name text NOT NULL,
                            description text NOT NULL,
                            created timestamp with time zone NOT NULL,
                            "licenseName" text NULL,
                            "licenseEmail" text NULL,
                            "licenseExpiresAt" timestamp with time zone NULL,
                            CONSTRAINT "PK_Projects" PRIMARY KEY (id)
);

COMMIT;