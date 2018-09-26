CREATE TABLE USER_T(
user_id INTEGER AUTO_INCREMENT NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL UNIQUE,
pass VARCHAR(255) NOT NULL,
about_me VARCHAR(1000) NOT NULL,
img VARCHAR(255),
CONSTRAINT user_pk PRIMARY KEY(user_id)
);

CREATE TABLE POSTS(
post_id INTEGER AUTO_INCREMENT  NOT NULL,
user_id INTEGER NOT NULL,
post_text VARCHAR(1000) NOT NULL,
date_col DATE,
CONSTRAINT post_pk PRIMARY KEY(post_id),
FOREIGN KEY (user_id) REFERENCES USER_T(user_id)
);

CREATE TABLE REQUEST(
request_id INTEGER AUTO_INCREMENT  NOT NULL,
user_request INTEGER NOT NULL,
request_to INTEGER NOT NULL,
responded INTEGER DEFAULT 0 NOT NULL,
date_col DATE,
CONSTRAINT request_pk PRIMARY KEY(request_id),
FOREIGN KEY (user_request) REFERENCES USER_T(user_id)
);

CREATE TABLE FRIENDS(
friends_id INTEGER AUTO_INCREMENT  NOT NULL,
user_request INTEGER NOT NULL,
user_accepted INTEGER NOT NULL,
request_id INTEGER NOT NULL,
CONSTRAINT friends_pk PRIMARY KEY(friends_id),
FOREIGN KEY (user_request) REFERENCES USER_T(user_id),
FOREIGN KEY (user_accepted) REFERENCES USER_T(user_id),
FOREIGN KEY (request_id) REFERENCES REQUEST(request_id)
);

INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('bairon', 'vasquez', 'bvasquez@gmail.com', '234', 'Programmable motivating flexibility', 'img1.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Luke', 'ArmStrong', 'lArmStrong@gmail.com', '456', 'Distributed next generation adapter', 'img2.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Lance', 'tance', 'ltance@gmail.com', '789', 'Optional motivating concept', 'img3.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Lenna', 'Paprocki', 'lpaprocki@hotmail.com', '99501', 'Persevering content-based definition', 'img4.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Simona', 'Morasca', 'simona@morasca.com', '44805', 'Optimized bandwidth-monitored throughput', 'img5.png');          
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Sage', 'Wieser', 'sage_wieser@cox.net', '57105', 'User-centric object-oriented policy', 'img6.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Kris', 'Marrier', 'kris@gmail.com', '19443', 'Business-focused global approach', 'img7.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Cammy', 'Albares', 'calbares@gmail.com', '78045', 'Self-enabling fresh-thinking contingency', 'img8.png'); 
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Donte', 'Kines', 'dkines@hotmail.com', '1602', 'Front-line secondary matrix', 'img9.png');
INSERT INTO USER_T(FIRST_NAME, LAST_NAME, EMAIL, PASS, ABOUT_ME, IMG)
                    VALUES('Talia', 'Riopelle', 'talia_riopelle@aol.com', '7050', 'Diverse zero defect website', 'img10.png');

commit;