-- Create the database
CREATE DATABASE social_media;

-- Use the created database
USE social_media;

-- Create Users table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Posts table
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Comments table
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert sample records into Users table
INSERT INTO Users (username, email) VALUES 
('Aarav', 'aarav@google.com'),
('Meera', 'meera@google.com'),
('Rohan', 'rohan@google.com'),
('Kavya', 'kavya@microsoft.com'),
('Vivaan', 'vivaan@meta.com');

-- Insert sample records into Posts table
INSERT INTO Posts (user_id, content) VALUES 
(1, 'Excited for the new year!'),
(2, 'Just had a great meal!'),
(3, 'Traveling to Goa next week!'),
(1, 'What are your resolutions?'),
(4, 'Can\'t wait for the festival!'),
(5, 'Just finished a great book!');

-- Insert sample records into Comments table
INSERT INTO Comments (post_id, user_id, comment) VALUES 
(1, 2, 'Happy New Year, Aarav!'),
(1, 3, 'Cheers to a great year ahead!'),
(2, 1, 'Sounds delicious, Meera!'),
(3, 4, 'Enjoy your trip to Goa!'),
(4, 5, 'I want to travel too!'),
(5, 1, 'What book did you read?');

 -- Schemas of tables 
desc Users;
desc Posts;
desc Comments;

# Questions for SQL Queries

# What are all the users in the Users table?
SELECT * FROM Users; 

# What are all the posts in the Posts table?
SELECT * FROM Posts; 

# What are all the comments in the Comments table?
SELECT * FROM Comments; 

# What posts has the user with user_id = 1 created?
SELECT * FROM Posts WHERE user_id = 1; 

# What comments are associated with the post having post_id = 1?
SELECT * FROM Comments WHERE post_id = 1; 

# How many posts has each user made?
SELECT user_id, COUNT(*) AS post_count FROM Posts GROUP BY user_id; 

# How many comments are associated with each post?
SELECT post_id, COUNT(*) AS comment_count FROM Comments GROUP BY post_id; 

# What is the latest post made by each user?
SELECT user_id, content, created_at FROM Posts WHERE (user_id, created_at) IN (SELECT user_id, MAX(created_at) FROM Posts GROUP BY user_id); 

# What comments has the user with user_id = 2 made?
SELECT * FROM Comments WHERE user_id = 2; 

# What are the posts along with the username of the author?
SELECT p.*, u.username FROM Posts p JOIN Users u ON p.user_id = u.user_id; 

# What comments are there along with the username of the commenter and the content of the post?
SELECT c.*, u.username, p.content FROM Comments c JOIN Users u ON c.user_id = u.user_id JOIN Posts p ON c.post_id = p.post_id; 

# What posts were created after January 6, 2024?
SELECT * FROM Posts WHERE created_at > '2024-01-06'; 

# What is the updated email address for the user with user_id = 1?
UPDATE Users SET email = 'aarav123@example.com' WHERE user_id = 1; 

# Which comment with comment_id = 3 will be deleted?
DELETE FROM Comments WHERE comment_id = 3; 

# What new user is being added to the Users table?
INSERT INTO Users (username, email) VALUES ('Nisha', 'nisha@example.com'); 

# What new post is being created by the user with user_id = 2?
INSERT INTO Posts (user_id, content) VALUES (2, 'Feeling great today!'); 

# What new comment is being added to the post with post_id = 4 by the user with user_id = 3?
INSERT INTO Comments (post_id, user_id, comment) VALUES (4, 3, 'Looking forward to it!'); 

# What are the first 5 posts in the Posts table?
SELECT * FROM Posts LIMIT 5; 

# What is the total number of users in the Users table?
SELECT COUNT(*) AS total_users FROM Users; 

# What is the total number of comments in the Comments table?
SELECT COUNT(*) AS total_comments FROM Comments; 

# How many posts did each user create, including users with zero posts?
SELECT u.username, COUNT(p.post_id) AS post_count FROM Users u LEFT JOIN Posts p ON u.user_id = p.user_id GROUP BY u.username; 

# What is the comment count for each post?
SELECT p.content, COUNT(c.comment_id) AS comment_count FROM Posts p LEFT JOIN Comments c ON p.post_id = c.post_id GROUP BY p.post_id; 

# What posts contain the word "great"?
SELECT u.username, p.content FROM Posts p JOIN Users u ON p.user_id = u.user_id WHERE p.content LIKE '%great%'; 

# What comments has user with user_id = 2 made on post with post_id = 2?
SELECT c.comment, u.username FROM Comments c JOIN Users u ON c.user_id = u.user_id WHERE c.post_id = 2; 

# What is the updated content for the post with post_id = 3?
UPDATE Posts SET content = 'Traveling to Mumbai next week!' WHERE post_id = 3; 

# Which post with post_id = 6 is being deleted?
DELETE FROM Posts WHERE post_id = 6;

