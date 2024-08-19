DROP DATABASE IF EXISTS db;

CREATE DATABASE db;

USE db;

CREATE TABLE user
(
    username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

CREATE TABLE toy_listing
(
    initial_price    DOUBLE,
    category         VARCHAR(50),
    name             VARCHAR(50),
    start_age        INT,
    end_age          INT,
    secret_min_price DOUBLE,
    closing_datetime DATETIME,
    increment        DOUBLE,
    toy_id           INT auto_increment,
    start_datetime   DATETIME,
    username         VARCHAR(30) NOT NULL,
    openStatus       INT DEFAULT 1,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE action_figure
(
    toy_id         INT NOT NULL,
    height         DOUBLE,
    can_move       BOOLEAN,
    character_name VARCHAR(50),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE board_game
(
    toy_id        INT NOT NULL,
    player_count  INT,
    brand         VARCHAR(50),
    is_cards_game BOOLEAN,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE stuffed_animal
(
    toy_id INT NOT NULL,
    color  VARCHAR(30),
    brand  VARCHAR(50),
    animal VARCHAR(100),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE admin
(
    id       VARCHAR(30),
    password VARCHAR(30),
    PRIMARY KEY (id)
);

CREATE TABLE customer_representative
(
    id       VARCHAR(30),
    password VARCHAR(30),
    PRIMARY KEY (id)
);

CREATE TABLE alert(
                      alert_id int auto_increment,
                      name varchar(50),
                      max_price double,
                      category varchar(40),
                      min_price double,
                      age_range char(5),
                      username varchar(30) NOT NULL,
                      Primary key (alert_id),
                      Foreign key (username) references user(username) ON DELETE CASCADE
                          ON UPDATE CASCADE);

CREATE TABLE custom_alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    alert_name VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    max_price DECIMAL(10, 2) NOT NULL,
    min_price DECIMAL(10, 2) NOT NULL,
    start_age INT NOT NULL,
    end_age INT NOT NULL,
    height double,
    can_move BOOLEAN default NULL,
    character_name VARCHAR(255) default NULL,
    color VARCHAR(255) default NULL,
    brand VARCHAR(255) default NULL,
    animal VARCHAR(255) default NULL,
    player_count INT default NULL,
    game_brand VARCHAR(255) default NULL,
    is_cards_game BOOLEAN default NULL,
    username VARCHAR(255) NOT NULL,
    custom_alert_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (username) REFERENCES user(username) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE admin_creates
(
    a_id VARCHAR(30),
    c_id VARCHAR(30),
    FOREIGN KEY(a_id) REFERENCES admin(id),
    FOREIGN KEY(c_id) REFERENCES customer_representative(id)
);

CREATE TABLE bid
(
    b_id        INT auto_increment,
    time        DATETIME,
    price       DOUBLE,
    username    VARCHAR(30) NOT NULL,
    toy_id      INT NOT NULL,
    is_auto_bid BOOLEAN,
    bid_status varchar(10) default 'active',
    PRIMARY KEY (b_id),
    FOREIGN KEY (username) REFERENCES user(username)ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE sale
(
    sale_id INT auto_increment,
    date    DATETIME,
    toy_id  INT NOT NULL,
    b_id    INT NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (b_id) REFERENCES bid(b_id)ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE report
(
    report_id      VARCHAR(9),
    date           DATETIME,
    total_earnings DOUBLE,
    admin_id       VARCHAR(30) NOT NULL,
    earnings_per   DOUBLE,
    best_selling   VARCHAR(100),
    PRIMARY KEY (report_id),
    FOREIGN KEY (admin_id) REFERENCES admin(id)ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE automatic_bid
(
    ab_id            INT auto_increment,
    increment        DOUBLE,
    secret_max_price DOUBLE,
    last_bid_id      INT NOT NULL,
    toy_id           INT NOT NULL,
    active           boolean default 1,
    PRIMARY KEY (ab_id, last_bid_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id)ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (last_bid_id) REFERENCES bid(b_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE question
(
    question_text VARCHAR(500),
    q_id          VARCHAR(30),
    username      VARCHAR(30),
    PRIMARY KEY (q_id),
    FOREIGN KEY (username) REFERENCES user(username) ON DELETE CASCADE ON
        UPDATE CASCADE
);

CREATE TABLE answer
(
    q_id        VARCHAR(30),
    c_id        VARCHAR(30),
    answer_text VARCHAR(500),
    PRIMARY KEY (q_id),
    FOREIGN KEY(q_id) REFERENCES question(q_id) ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(c_id) REFERENCES customer_representative(id) ON DELETE CASCADE
        ON UPDATE CASCADE
);