BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mpesa_payment" (
    "id" bigserial PRIMARY KEY,
    "orderId" bigint NOT NULL,
    "phoneNumber" text NOT NULL,
    "amount" bigint NOT NULL,
    "merchantRequestId" text,
    "checkoutRequestId" text,
    "status" text NOT NULL DEFAULT 'pending'::text,
    "mpesaReceiptNumber" text,
    "resultCode" bigint,
    "resultDesc" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "mpesa_payment_checkout_idx" ON "mpesa_payment" USING btree ("checkoutRequestId");
CREATE INDEX "mpesa_payment_order_idx" ON "mpesa_payment" USING btree ("orderId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "mpesa_payment"
    ADD CONSTRAINT "mpesa_payment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "shop_order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR shop
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shop', '20261013112813553', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013112813553', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
