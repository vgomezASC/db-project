-- Get list of friends who've not been friended yet and list by number of friends they have
SELECT S.sender_username, SUM(S.count) FROM
(SELECT sender_username, count(*)
FROM users_friend
WHERE sender_username != 'hi1' AND receiver_username != 'hi1'
GROUP BY sender_username
UNION
SELECT receiver_username, count(*)
FROM users_friend
WHERE sender_username != 'hi1' AND receiver_username != 'hi1'
GROUP BY receiver_username) S
GROUP BY S.sender_username
ORDER BY SUM(S.count) DESC

-- Get all friends and the games they have
SELECT DISTINCT username, game_name FROM users as U
JOIN user_inventory AS UI ON UI.owner_id = U.uid
JOIN users_friend AS UF ON (UF.sender_username = 'hi1' OR UF.receiver_username = 'hi1')
WHERE username != 'hi1'
ORDER BY username


