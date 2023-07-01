CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "orders" ("id" varchar NOT NULL PRIMARY KEY, "state" varchar, "promotion_codes" text, "discount_code" varchar, "total_price" decimal(10,2), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_orders_on_id" ON "orders" ("id");
CREATE TABLE IF NOT EXISTS "items" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "size" varchar, "add" text, "remove" text, "order_id" uuid NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_53153f3b4b"
FOREIGN KEY ("order_id")
  REFERENCES "orders" ("id")
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX "index_items_on_order_id" ON "items" ("order_id");
INSERT INTO "schema_migrations" (version) VALUES
('20230627131639'),
('20230627132731');


