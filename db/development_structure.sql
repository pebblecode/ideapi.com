CREATE TABLE "brief_answers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "body" text, "brief_question_id" integer, "brief_id" integer, "brief_section_id" integer);
CREATE TABLE "brief_configs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE 'brief_questions' ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "help_text" text, "response_type_id" integer, "optional" boolean DEFAULT 'f');
CREATE TABLE "brief_section_brief_questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "brief_section_id" integer, "brief_question_id" integer, "created_at" datetime, "updated_at" datetime, "position" integer);
CREATE TABLE "brief_section_brief_templates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "brief_section_id" integer, "brief_template_id" integer);
CREATE TABLE 'brief_sections' ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "strapline" text, "position" integer, "brief_config_id" integer);
CREATE TABLE "brief_templates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "brief_config_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "briefs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "author_id" integer, "brief_template_id" integer, "state" varchar(255));
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(50) DEFAULT '', "comment" text DEFAULT '', "commentable_id" integer, "commentable_type" varchar(255), "user_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "creative_proposals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "short_description" varchar(255), "long_description" text, "brief_id" integer, "user_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "creative_questions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "body" text, "love_count" integer DEFAULT 0, "hate_count" integer DEFAULT 0, "answer" text, "user_id" integer, "brief_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "response_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "input_type" varchar(255), "options" varchar(255));
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(255), "email" varchar(255), "crypted_password" varchar(255), "password_salt" varchar(255), "persistence_token" varchar(255), "type" varchar(255));
CREATE INDEX "index_comments_on_commentable_id" ON "comments" ("commentable_id");
CREATE INDEX "index_comments_on_commentable_type" ON "comments" ("commentable_type");
CREATE INDEX "index_comments_on_user_id" ON "comments" ("user_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090526095655');

INSERT INTO schema_migrations (version) VALUES ('20090526100437');

INSERT INTO schema_migrations (version) VALUES ('20090526100931');

INSERT INTO schema_migrations (version) VALUES ('20090526101654');

INSERT INTO schema_migrations (version) VALUES ('20090526112626');

INSERT INTO schema_migrations (version) VALUES ('20090526112633');

INSERT INTO schema_migrations (version) VALUES ('20090526112637');

INSERT INTO schema_migrations (version) VALUES ('20090526112641');

INSERT INTO schema_migrations (version) VALUES ('20090527103415');

INSERT INTO schema_migrations (version) VALUES ('20090528082730');

INSERT INTO schema_migrations (version) VALUES ('20090528113118');

INSERT INTO schema_migrations (version) VALUES ('20090603122349');

INSERT INTO schema_migrations (version) VALUES ('20090603123154');

INSERT INTO schema_migrations (version) VALUES ('20090603123254');

INSERT INTO schema_migrations (version) VALUES ('20090603123344');

INSERT INTO schema_migrations (version) VALUES ('20090603124035');

INSERT INTO schema_migrations (version) VALUES ('20090603124633');

INSERT INTO schema_migrations (version) VALUES ('20090603132254');

INSERT INTO schema_migrations (version) VALUES ('20090603134948');

INSERT INTO schema_migrations (version) VALUES ('20090603192624');

INSERT INTO schema_migrations (version) VALUES ('20090603192804');

INSERT INTO schema_migrations (version) VALUES ('20090603202842');

INSERT INTO schema_migrations (version) VALUES ('20090603230433');

INSERT INTO schema_migrations (version) VALUES ('20090603231205');

INSERT INTO schema_migrations (version) VALUES ('20090604132206');