CREATE TABLE "brief_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" text, "body" text, "position" integer, "brief_id" integer, "created_at" datetime, "updated_at" datetime, "template_question_id" integer);
CREATE TABLE "briefs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "author_id" integer, "state" varchar(255), "site_id" integer, "template_brief_id" integer, "most_important_message" text);
CREATE TABLE "creative_proposals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "short_description" text, "long_description" text, "brief_id" integer, "creative_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "creative_questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "body" text, "author_answer" text, "brief_id" integer, "creative_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "sites" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255));
CREATE TABLE "template_brief_questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "template_brief_id" integer, "template_question_id" integer);
CREATE TABLE "template_briefs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "site_id" integer);
CREATE TABLE "template_questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "body" text, "help_message" text, "optional" boolean, "template_section_id" integer);
CREATE TABLE "template_sections" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" text, "position" integer);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(255), "email" varchar(255), "crypted_password" varchar(255), "password_salt" varchar(255), "persistence_token" varchar(255), "type" varchar(255), "avatar_file_name" varchar(255), "avatar_content_type" varchar(255), "avatar_file_size" integer, "avatar_updated_at" datetime);
CREATE TABLE "watched_briefs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "brief_id" integer, "creative_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090526100437');

INSERT INTO schema_migrations (version) VALUES ('20090526100931');

INSERT INTO schema_migrations (version) VALUES ('20090603122349');

INSERT INTO schema_migrations (version) VALUES ('20090603132254');

INSERT INTO schema_migrations (version) VALUES ('20090603231205');

INSERT INTO schema_migrations (version) VALUES ('20090604132206');

INSERT INTO schema_migrations (version) VALUES ('20090605163227');

INSERT INTO schema_migrations (version) VALUES ('20090629110714');

INSERT INTO schema_migrations (version) VALUES ('20090629110949');

INSERT INTO schema_migrations (version) VALUES ('20090629111416');

INSERT INTO schema_migrations (version) VALUES ('20090629111859');

INSERT INTO schema_migrations (version) VALUES ('20090629112013');

INSERT INTO schema_migrations (version) VALUES ('20090629113513');

INSERT INTO schema_migrations (version) VALUES ('20090629114313');

INSERT INTO schema_migrations (version) VALUES ('20090630103741');

INSERT INTO schema_migrations (version) VALUES ('20090630180122');

INSERT INTO schema_migrations (version) VALUES ('20090703105128');

INSERT INTO schema_migrations (version) VALUES ('20090703132939');