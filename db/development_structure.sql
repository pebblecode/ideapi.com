CREATE TABLE `account_template_documents` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) default NULL,
  `template_document_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `account_users` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `redeemed_at` datetime default NULL,
  `document_creation` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `admin` tinyint(1) default '0',
  `can_create_documents` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_account_users_on_account_id` (`account_id`),
  KEY `index_account_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `full_domain` varchar(255) collate utf8_unicode_ci default NULL,
  `deleted_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_accounts_on_full_domain` (`full_domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `assets` (
  `id` int(11) NOT NULL auto_increment,
  `attachable_id` int(11) default NULL,
  `attachable_type` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `data_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `data_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `data_file_size` int(11) default NULL,
  `data_updated_at` datetime default NULL,
  `description` text collate utf8_unicode_ci,
  PRIMARY KEY  (`id`),
  KEY `index_assets_on_attachable_id_and_attachable_type` (`attachable_id`,`attachable_type`),
  KEY `index_assets_on_attachable_id` (`attachable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `document_item_versions` (
  `id` int(11) NOT NULL auto_increment,
  `document_item_id` int(11) default NULL,
  `version` int(11) default NULL,
  `title` text collate utf8_unicode_ci,
  `body` text collate utf8_unicode_ci,
  `position` int(11) default NULL,
  `document_id` int(11) default NULL,
  `template_question_id` int(11) default NULL,
  `revised_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_document_item_versions_on_document_id` (`document_id`),
  KEY `index_document_item_versions_on_document_item_id` (`document_item_id`),
  KEY `index_document_item_versions_on_template_question_id` (`template_question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `document_items` (
  `id` int(11) NOT NULL auto_increment,
  `title` text collate utf8_unicode_ci,
  `body` text collate utf8_unicode_ci,
  `position` int(11) default NULL,
  `document_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `template_question_id` int(11) default NULL,
  `version` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_document_items_on_document_id` (`document_id`),
  KEY `index_document_items_on_template_question_id` (`template_question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `documents` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `site_id` int(11) default NULL,
  `template_document_id` int(11) default NULL,
  `most_important_message` text collate utf8_unicode_ci,
  `delta` tinyint(1) default NULL,
  `approver_id` int(11) default NULL,
  `author_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `updated_at` datetime default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_documents_on_approver_id` (`approver_id`),
  KEY `index_documents_on_delta` (`delta`),
  KEY `index_documents_on_site_id` (`site_id`),
  KEY `index_documents_on_template_document_id` (`template_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) collate utf8_unicode_ci default '',
  `comment` text collate utf8_unicode_ci,
  `commentable_id` int(11) default NULL,
  `commentable_type` varchar(255) collate utf8_unicode_ci default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_comments_on_commentable_id` (`commentable_id`),
  KEY `index_comments_on_commentable_type` (`commentable_type`),
  KEY `index_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `user_id` int(11) default NULL,
  `remote_ip` varchar(255) collate utf8_unicode_ci default NULL,
  `token` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `proposals` (
  `id` int(11) NOT NULL auto_increment,
  `short_description` text collate utf8_unicode_ci,
  `long_description` text collate utf8_unicode_ci,
  `document_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `published_at` datetime default NULL,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_proposals_on_document_id` (`document_id`),
  KEY `index_proposals_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL auto_increment,
  `body` text collate utf8_unicode_ci,
  `author_answer` text collate utf8_unicode_ci,
  `document_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `document_item_id` int(11) default NULL,
  `answered_by_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_questions_on_document_id` (`document_id`),
  KEY `index_questions_on_document_item_id` (`document_item_id`),
  KEY `index_questions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `subscription_affiliates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `rate` decimal(6,4) default '0.0000',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `token` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_subscription_affiliates_on_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `subscription_discounts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `code` varchar(255) collate utf8_unicode_ci default NULL,
  `amount` decimal(6,2) default '0.00',
  `percent` tinyint(1) default NULL,
  `start_on` date default NULL,
  `end_on` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `apply_to_setup` tinyint(1) default '1',
  `apply_to_recurring` tinyint(1) default '1',
  `trial_period_extension` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `subscription_payments` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) default NULL,
  `subscription_id` int(11) default NULL,
  `amount` decimal(10,2) default '0.00',
  `transaction_id` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `setup` tinyint(1) default NULL,
  `misc` tinyint(1) default NULL,
  `subscription_affiliate_id` int(11) default NULL,
  `affiliate_amount` decimal(6,2) default '0.00',
  PRIMARY KEY  (`id`),
  KEY `index_subscription_payments_on_account_id` (`account_id`),
  KEY `index_subscription_payments_on_subscription_id` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `subscription_plans` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `amount` decimal(10,2) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `setup_amount` decimal(10,2) default NULL,
  `trial_period` int(11) default '1',
  `document_limit` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL auto_increment,
  `amount` decimal(10,2) default NULL,
  `next_renewal_at` datetime default NULL,
  `card_number` varchar(255) collate utf8_unicode_ci default NULL,
  `card_expiration` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `state` varchar(255) collate utf8_unicode_ci default 'trial',
  `subscription_plan_id` int(11) default NULL,
  `account_id` int(11) default NULL,
  `user_limit` int(11) default NULL,
  `renewal_period` int(11) default '1',
  `billing_id` varchar(255) collate utf8_unicode_ci default NULL,
  `subscription_discount_id` int(11) default NULL,
  `subscription_affiliate_id` int(11) default NULL,
  `document_limit` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_subscriptions_on_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_document_questions` (
  `id` int(11) NOT NULL auto_increment,
  `template_document_id` int(11) default NULL,
  `template_question_id` int(11) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_template_document_questions_on_template_document_id` (`template_document_id`),
  KEY `index_template_document_questions_on_template_question_id` (`template_question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_documents` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) collate utf8_unicode_ci default NULL,
  `site_id` int(11) default NULL,
  `default` tinyint(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `index_template_documents_on_site_id` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_questions` (
  `id` int(11) NOT NULL auto_increment,
  `body` text collate utf8_unicode_ci,
  `help_message` text collate utf8_unicode_ci,
  `optional` tinyint(1) default NULL,
  `template_section_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_template_questions_on_template_section_id` (`template_section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `template_sections` (
  `id` int(11) NOT NULL auto_increment,
  `title` text collate utf8_unicode_ci,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `timeline_events` (
  `id` int(11) NOT NULL auto_increment,
  `event_type` varchar(255) collate utf8_unicode_ci default NULL,
  `subject_type` varchar(255) collate utf8_unicode_ci default NULL,
  `actor_type` varchar(255) collate utf8_unicode_ci default NULL,
  `secondary_subject_type` varchar(255) collate utf8_unicode_ci default NULL,
  `subject_id` int(11) default NULL,
  `actor_id` int(11) default NULL,
  `secondary_subject_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `log_level` int(11) default '1',
  PRIMARY KEY  (`id`),
  KEY `index_timeline_events_on_actor_id_and_actor_type` (`actor_id`,`actor_type`),
  KEY `index_timeline_events_ssubs` (`secondary_subject_id`,`secondary_subject_type`),
  KEY `index_timeline_events_on_subject_id_and_subject_type` (`subject_id`,`subject_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_documents` (
  `id` int(11) NOT NULL auto_increment,
  `document_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `author` tinyint(1) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `view_count` int(11) default '0',
  `last_viewed_at` datetime default NULL,
  `added_by_user_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_user_documents_on_document_id` (`document_id`),
  KEY `index_user_documents_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `screename` varchar(255) collate utf8_unicode_ci default NULL,
  `email` varchar(255) collate utf8_unicode_ci default NULL,
  `crypted_password` varchar(255) collate utf8_unicode_ci default NULL,
  `password_salt` varchar(255) collate utf8_unicode_ci default NULL,
  `persistence_token` varchar(255) collate utf8_unicode_ci default NULL,
  `avatar_file_name` varchar(255) collate utf8_unicode_ci default NULL,
  `avatar_content_type` varchar(255) collate utf8_unicode_ci default NULL,
  `avatar_file_size` int(11) default NULL,
  `avatar_updated_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `last_request_at` datetime default NULL,
  `invite_count` int(11) default NULL,
  `friends_count` int(11) NOT NULL default '0',
  `first_name` varchar(255) collate utf8_unicode_ci default NULL,
  `last_name` varchar(255) collate utf8_unicode_ci default NULL,
  `state` varchar(255) collate utf8_unicode_ci default NULL,
  `invite_code` varchar(255) collate utf8_unicode_ci default NULL,
  `job_title` varchar(255) collate utf8_unicode_ci default NULL,
  `telephone` varchar(255) collate utf8_unicode_ci default NULL,
  `telephone_ext` varchar(255) collate utf8_unicode_ci default NULL,
  `current_login_at` datetime default NULL,
  `invited_by_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `watched_documents` (
  `id` int(11) NOT NULL auto_increment,
  `document_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_watched_documents_on_document_id` (`document_id`),
  KEY `index_watched_documents_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

INSERT INTO schema_migrations (version) VALUES ('20090706173356');

INSERT INTO schema_migrations (version) VALUES ('20090708153039');

INSERT INTO schema_migrations (version) VALUES ('20090721164143');

INSERT INTO schema_migrations (version) VALUES ('20090727091635');

INSERT INTO schema_migrations (version) VALUES ('20090727101154');

INSERT INTO schema_migrations (version) VALUES ('20090729115808');

INSERT INTO schema_migrations (version) VALUES ('20090729144931');

INSERT INTO schema_migrations (version) VALUES ('20090805154545');

INSERT INTO schema_migrations (version) VALUES ('20090810120457');

INSERT INTO schema_migrations (version) VALUES ('20090813151529');

INSERT INTO schema_migrations (version) VALUES ('20090818112146');

INSERT INTO schema_migrations (version) VALUES ('20090818135917');

INSERT INTO schema_migrations (version) VALUES ('20090826091117');

INSERT INTO schema_migrations (version) VALUES ('20090826121647');

INSERT INTO schema_migrations (version) VALUES ('20090903141325');

INSERT INTO schema_migrations (version) VALUES ('20090908125624');

INSERT INTO schema_migrations (version) VALUES ('20090908153925');

INSERT INTO schema_migrations (version) VALUES ('20090922114803');

INSERT INTO schema_migrations (version) VALUES ('20090922114922');

INSERT INTO schema_migrations (version) VALUES ('20090922142556');

INSERT INTO schema_migrations (version) VALUES ('20090922170223');

INSERT INTO schema_migrations (version) VALUES ('20090922170252');

INSERT INTO schema_migrations (version) VALUES ('20090923115903');

INSERT INTO schema_migrations (version) VALUES ('20090929100720');

INSERT INTO schema_migrations (version) VALUES ('20090930152121');

INSERT INTO schema_migrations (version) VALUES ('20091002132543');

INSERT INTO schema_migrations (version) VALUES ('20091006095216');

INSERT INTO schema_migrations (version) VALUES ('20091006095715');

INSERT INTO schema_migrations (version) VALUES ('20091006103048');

INSERT INTO schema_migrations (version) VALUES ('20091009145658');

INSERT INTO schema_migrations (version) VALUES ('20091015101445');

INSERT INTO schema_migrations (version) VALUES ('20091022134100');

INSERT INTO schema_migrations (version) VALUES ('20091029170330');

INSERT INTO schema_migrations (version) VALUES ('20091029170354');

INSERT INTO schema_migrations (version) VALUES ('20091030163139');

INSERT INTO schema_migrations (version) VALUES ('20091109131434');

INSERT INTO schema_migrations (version) VALUES ('20091110184312');

INSERT INTO schema_migrations (version) VALUES ('20091110215425');

INSERT INTO schema_migrations (version) VALUES ('20091112205750');

INSERT INTO schema_migrations (version) VALUES ('20091114223659');

INSERT INTO schema_migrations (version) VALUES ('20091115194955');

INSERT INTO schema_migrations (version) VALUES ('20091116115958');

INSERT INTO schema_migrations (version) VALUES ('20091116132517');

INSERT INTO schema_migrations (version) VALUES ('20091116140053');

INSERT INTO schema_migrations (version) VALUES ('20091119142903');

INSERT INTO schema_migrations (version) VALUES ('20091120121202');

INSERT INTO schema_migrations (version) VALUES ('20091124135201');

INSERT INTO schema_migrations (version) VALUES ('20091124173839');

INSERT INTO schema_migrations (version) VALUES ('20091124174658');

INSERT INTO schema_migrations (version) VALUES ('20091125215822');

INSERT INTO schema_migrations (version) VALUES ('20091126152142');