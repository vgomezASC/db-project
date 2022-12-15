/*
	Kyle Timmermans (kt2578), Vicente Gomez (vg994)
	Prof. Stoyanovich
	Principles of Database Systems
	Final Project

	schema.sql
*/


/* Drop ALL tables if they already exist */

DROP TABLE IF EXISTS users, websites, games, game_dev_companies;
DROP TABLE IF EXISTS customer_support, front_end_devs, uxui_experts;
DROP TABLE IF EXISTS programmers, artists, qa_testers, soundtrack_devs;
DROP TABLE IF EXISTS animators, level_designers, rate, buy, trade, sell;
DROP TABLE IF EXISTS programmers_program_for, artists_make_art_for;
DROP TABLE IF EXISTS qa_testers_test_games_for, soundtrack_devs_make_music_for;
DROP TABLE IF EXISTS animators_animate_for, level_designers_design_for;
DROP TABLE IF EXISTS front_end_devs_design_websites_for, uxui_experts_designs;
DROP TABLE IF EXISTS customer_support_works_for, customer_support_assists;
DROP TABLE IF EXISTS users_visit, front_end_devs_designs, uxui_experts_designs;
DROP TABLE IF EXISTS uxui_experts_designs, game_dev_companies_owns;
DROP TABLE IF EXISTS game_dev_companies_develop, users_friend;

/* Entities */

CREATE TABLE users (
	uid INTEGER PRIMARY KEY,
	username VARCHAR(32) NOT NULL,
	email VARCHAR(32) NOT NULL,
	password VARCHAR(64) NOT NULL,
	UNIQUE(username, email)
);

CREATE TABLE websites (
	wid INTEGER PRIMARY KEY,
	name VARCHAR(32) NOT NULL
);

CREATE TABLE games (
	gid INTEGER PRIMARY KEY,
	name VARCHAR(32) NOT NULL,
	game_dev_company INTEGER NOT NULL,
	genre VARCHAR(32),
	UNIQUE(name, genre)
);

CREATE TABLE game_dev_companies (
	cid INTEGER PRIMARY KEY,
	name VARCHAR(32) NOT NULL,
	year_established DATE,
	wid INTEGER NOT NULL,
	FOREIGN KEY (wid) REFERENCES websites (wid)
);

CREATE TABLE customer_support (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE front_end_devs (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE uxui_experts (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE programmers (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE artists (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE qa_testers (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE soundtrack_devs (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE animators (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);

CREATE TABLE level_designers (
	eid INTEGER NOT NULL,
	gcid INTEGER NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY(gcid) REFERENCES game_dev_companies(cid),
	PRIMARY KEY(eid, gcid)
);



/* Entity Relationships */

CREATE TABLE rate (
	score INTEGER,
	rating_user INTEGER,
	rated_game INTEGER,
	FOREIGN KEY (rating_user) REFERENCES users (uid),
	FOREIGN KEY (rated_game) REFERENCES games (gid),
	PRIMARY KEY(rating_user, rated_game)
);

CREATE TABLE buy (
	buyer_id INTEGER,
	game_id INTEGER,
	FOREIGN KEY (buyer_id) REFERENCES users (uid),
	FOREIGN KEY (game_id) REFERENCES games (gid),
	PRIMARY KEY(buyer_id, game_id)
);

CREATE TABLE trade (
	game_one INTEGER,
	game_two INTEGER,
	trader_one INTEGER,
	trader_two INTEGER,
	FOREIGN KEY (trader_one) REFERENCES users (uid),
	FOREIGN KEY (trader_two) REFERENCES users (uid),
	PRIMARY KEY(trader_one, trader_two, game_one, game_two)
);

CREATE TABLE sell (
	game_id INTEGER,
	seller_id INTEGER,
	buyer_id INTEGER,
	FOREIGN KEY (game_id) REFERENCES games (gid),
	FOREIGN KEY (seller_id) REFERENCES users (uid),
	FOREIGN KEY (buyer_id) REFERENCES users (uid),
	PRIMARY KEY(game_id, seller_id, buyer_id)
);

CREATE TABLE programmers_program_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE artists_make_art_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE qa_testers_test_games_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE soundtrack_devs_make_music_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE animators_animate_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE level_designers_design_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE front_end_devs_design_websites_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE uxui_experts_design_websites_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE customer_support_works_for (
	eid INTEGER NOT NULL,
	game_dev_cid INTEGER NOT NULL,
	name VARCHAR(32),
	FOREIGN KEY (game_dev_cid) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(eid, game_dev_cid)
);

CREATE TABLE customer_support_assists (
	support_worker_id INTEGER,
	support_worker_company_id INTEGER,
	user_helped INTEGER,
	date_helped DATE,
	FOREIGN KEY (support_worker_id, support_worker_company_id) REFERENCES customer_support (eid, gcid),
	FOREIGN KEY (user_helped) REFERENCES users (uid),
	PRIMARY KEY(support_worker_id, support_worker_company_id, user_helped, date_helped)
);

CREATE TABLE users_visit (
	user_id INTEGER,
	website_id INTEGER,
	date_visited DATE,
	FOREIGN KEY (user_id) REFERENCES users (uid),
	FOREIGN KEY (website_id) REFERENCES websites (wid),
	PRIMARY KEY(user_id, website_id, date_visited)
);

CREATE TABLE front_end_devs_designs (
	front_end_dev_id INTEGER,
	front_end_dev_company INTEGER,
	website_designed INTEGER,
	FOREIGN KEY (front_end_dev_id, front_end_dev_company) REFERENCES front_end_devs (eid, gcid),
	FOREIGN KEY (website_designed) REFERENCES websites (wid),
	PRIMARY KEY(front_end_dev_id, front_end_dev_company, website_designed)
);

CREATE TABLE uxui_experts_designs (
	uxui_expert_id INTEGER,
	uxui_expert_company INTEGER,
	website_designed INTEGER,
	FOREIGN KEY (uxui_expert_id, uxui_expert_company) REFERENCES uxui_experts (eid, gcid),
	FOREIGN KEY (website_designed) REFERENCES websites (wid),
	PRIMARY KEY(uxui_expert_id, uxui_expert_company, website_designed)
);

CREATE TABLE game_dev_companies_owns (
	game_dev_company_id INTEGER,
	name VARCHAR(32),
	game_dev_company_wid INTEGER NOT NULL,
	FOREIGN KEY (game_dev_company_wid) REFERENCES websites (wid),
	FOREIGN KEY (game_dev_company_id) REFERENCES game_dev_companies (cid),
	PRIMARY KEY(game_dev_company_id, game_dev_company_wid)
);

CREATE TABLE game_dev_companies_develop (
	game_dev_company_id INTEGER,
	game_developed INTEGER NOT NULL,
	game_name VARCHAR(32),
	game_genre VARCHAR(32),
	FOREIGN KEY (game_dev_company_id) REFERENCES game_dev_companies (cid),
	FOREIGN KEY (game_developed) REFERENCES games (gid),
	FOREIGN KEY (game_name, game_genre) REFERENCES games (name, genre),
	PRIMARY KEY(game_dev_company_id, game_developed)
);

CREATE TABLE users_friend (
	sender_uid INTEGER,
	receiver_uid INTEGER,
	sender_username VARCHAR(32),
	receiver_username VARCHAR(32),
	FOREIGN KEY (sender_uid) REFERENCES users (uid),
	FOREIGN KEY (receiver_uid) REFERENCES users (uid),	
	PRIMARY KEY(sender_uid, receiver_uid) 
);

CREATE TABLE user_inventory (
	owner_id INTEGER,
	game_id INTEGER,
	game_name VARCHAR(32),
	FOREIGN KEY (owner_id) REFERENCES users (uid),
	FOREIGN KEY (game_id) REFERENCES games (gid),
	PRIMARY KEY(owner_id, game_id)
);



/* Insert Test Data */

INSERT INTO users (uid, username, email, password) VALUES (0, 'user', 'hi@gmail.com', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb');
INSERT INTO users (uid, username, email, password) VALUES (1, 'user1', 'hi1@gmail.com', '0a041b9462caa4a31bac3567e0b6e6fd9100787db2ab433d96f6d178cabfce90');
INSERT INTO users (uid, username, email, password) VALUES (2, 'user2', 'hi2@gmail.com', '6025d18fe48abd45168528f18a82e265dd98d421a7084aa09f61b341703901a3');
INSERT INTO users (uid, username, email, password) VALUES (3, 'user3', 'hi3@gmail.com', '5860faf02b6bc6222ba5aca523560f0e364ccd8b67bee486fe8bf7c01d492ccb');
INSERT INTO users (uid, username, email, password) VALUES (4, 'user4', 'hi4@gmail.com', '5269ef980de47819ba3d14340f4665262c41e933dc92c1a27dd5d01b047ac80e');

INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (0, 1, 'user', 'user1');
INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (4, 0, 'user4', 'user');
INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (1, 2, 'user1', 'user2');
INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (3, 1, 'user3', 'user1');
INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (2, 3, 'user2', 'user3');
INSERT INTO users_friend (sender_uid, receiver_uid, sender_username, receiver_username) VALUES (4, 3, 'user4', 'user3');

INSERT INTO websites (wid, name) VALUES (1, 'Bungie Website');
INSERT INTO websites (wid, name) VALUES (2, 'Activision Website');
INSERT INTO websites (wid, name) VALUES (3, 'Nintendo Website');

INSERT INTO game_dev_companies (cid, name, year_established, wid) VALUES (1, 'Bungie', '2004-01-01 11:00:00', 1);
INSERT INTO game_dev_companies (cid, name, year_established, wid) VALUES (2, 'Activision', '1995-01-01 11:00:00', 2);
INSERT INTO game_dev_companies (cid, name, year_established, wid) VALUES (3, 'Nintendo', '1987-01-01 11:00:00', 3);

INSERT INTO games (gid, name, game_dev_company, genre) VALUES (1, 'Halo', 1, 'Action');
INSERT INTO games (gid, name, game_dev_company, genre) VALUES (2, 'CoD', 2, 'Action');
INSERT INTO games (gid, name, game_dev_company, genre) VALUES (3, 'Smash Bros', 3, 'Fighter');

INSERT INTO user_inventory (owner_id, game_id, game_name) VALUES (2, 1, 'Halo');
INSERT INTO user_inventory (owner_id, game_id, game_name) VALUES (2, 3, 'Smash Bros');
INSERT INTO user_inventory (owner_id, game_id, game_name) VALUES (3, 3, 'Smash Bros');
INSERT INTO user_inventory (owner_id, game_id, game_name) VALUES (3, 2, 'CoD');
