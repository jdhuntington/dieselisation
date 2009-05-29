CREATE TABLE "games" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "status" varchar(255), "created_at" datetime, "updated_at" datetime, "owner_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "seatings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "position" integer, "user_id" integer, "game_id" integer, "created_at" datetime, "updated_at" datetime, "active" boolean);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "email" varchar(255), "password" varchar(255), "actual_name" varchar(255), "identifier" string, "email_notification" boolean);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090405030805');

INSERT INTO schema_migrations (version) VALUES ('20090515040301');

INSERT INTO schema_migrations (version) VALUES ('20090515045649');

INSERT INTO schema_migrations (version) VALUES ('20090515045933');

INSERT INTO schema_migrations (version) VALUES ('20090516180130');

INSERT INTO schema_migrations (version) VALUES ('20090528142837');

INSERT INTO schema_migrations (version) VALUES ('20090529010804');