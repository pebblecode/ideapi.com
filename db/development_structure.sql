CREATE TABLE `assets` (
  `id` int(11) NOT NULL auto_increment,
  `attachable_id` int(11) default NULL,
  `attachable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `data_file_name` varchar(255) default NULL,
  `data_content_type` varchar(255) default NULL,
  `data_file_size` int(11) default NULL,
  `data_updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_assets_on_attachable_id` (`attachable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `brief_item_versions` (
  `id` int(11) NOT NULL auto_increment,
  `brief_item_id` int(11) default NULL,
  `version` int(11) default NULL,
  `title` text,
  `body` text,
  `position` int(11) default NULL,
  `brief_id` int(11) default NULL,
  `template_question_id` int(11) default NULL,
  `revised_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_brief_item_versions_on_brief_item_id` (`brief_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;

CREATE TABLE `brief_items` (
  `id` int(11) NOT NULL auto_increment,
  `title` text,
  `body` text,
  `position` int(11) default NULL,
  `brief_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `template_question_id` int(11) default NULL,
  `version` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

CREATE TABLE `brief_user_views` (
  `id` int(11) NOT NULL auto_increment,
  `brief_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `view_count` int(11) default '0',
  `last_viewed_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `briefs` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  `site_id` int(11) default NULL,
  `template_brief_id` int(11) default NULL,
  `most_important_message` text,
  `delta` tinyint(1) default NULL,
  `approver_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_briefs_on_delta` (`delta`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default '',
  `comment` text,
  `commentable_id` int(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_comments_on_commentable_type` (`commentable_type`),
  KEY `index_comments_on_commentable_id` (`commentable_id`),
  KEY `index_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `friendships` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `accepted_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `invitations` (
  `id` int(11) NOT NULL auto_increment,
  `recipient_email` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `code` varchar(255) default NULL,
  `redeemed_at` datetime default NULL,
  `redeemed_by_id` int(11) default NULL,
  `state` varchar(255) default NULL,
  `redeemable_id` int(11) default NULL,
  `redeemable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `proposals` (
  `id` int(11) NOT NULL auto_increment,
  `short_description` text,
  `long_description` text,
  `brief_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `published_at` datetime default NULL,
  `title` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `author_answer` text,
  `brief_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `brief_item_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `template_brief_questions` (
  `id` int(11) NOT NULL auto_increment,
  `template_brief_id` int(11) default NULL,
  `template_question_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `template_briefs` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `site_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `template_questions` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `help_message` text,
  `optional` tinyint(1) default NULL,
  `template_section_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `template_sections` (
  `id` int(11) NOT NULL auto_increment,
  `title` text,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `timeline_events` (
  `id` int(11) NOT NULL auto_increment,
  `event_type` varchar(255) default NULL,
  `subject_type` varchar(255) default NULL,
  `actor_type` varchar(255) default NULL,
  `secondary_subject_type` varchar(255) default NULL,
  `subject_id` int(11) default NULL,
  `actor_id` int(11) default NULL,
  `secondary_subject_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `log_level` int(11) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(255) default NULL,
  `password_salt` varchar(255) default NULL,
  `persistence_token` varchar(255) default NULL,
  `avatar_file_name` varchar(255) default NULL,
  `avatar_content_type` varchar(255) default NULL,
  `avatar_file_size` int(11) default NULL,
  `avatar_updated_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `last_request_at` datetime default NULL,
  `invite_count` int(11) default NULL,
  `friends_count` int(11) NOT NULL default '0',
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `watched_briefs` (
  `id` int(11) NOT NULL auto_increment,
  `brief_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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