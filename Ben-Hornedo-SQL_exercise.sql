/* PROVIDED SPEC */
CREATE​ ​TABLE​ game_items (
​id​ ​uuid​ PRIMARY ​KEY​,
item_type enum_game_item_type ​NOT​ ​NULL​, display_name ​character​ ​varying​(​255​) ​NOT​ ​NULL​, spendables_required ​json
);
CREATE​ ​TABLE​ transactions ( ​id​ ​uuid​ PRIMARY ​KEY​, user_id ​uuid​ ​NOT​ ​NULL​, received ​json​ ​NOT​ ​NULL​, spent ​json
);
CREATE​ ​TABLE​ locations (
​id​ ​uuid​ PRIMARY ​KEY​,
geom geometry(Point) ​NOT​ ​NULL );
INSERT​ ​INTO​ ​"game_items"​(​"id"​,​"item_type"​,​"display_name"​,​"spendables_required"​)
VALUES
(E​'e6623c34-64b5-47c6-8e7a-cd944f4141ee'​,E​'receivable'​,E​'western tanager'​,E​'{"5c0e1be2-ed5d-4be8-b45f-26961e27b169": 2, "ac0eff93-59e4-4f7a-b4d4-82fedc7914ca": 1}'​), (E​'5c0e1be2-ed5d-4be8-b45f-26961e27b169'​,E​'spendable'​,E​'worm'​,​NULL​), (E​'ac0eff93-59e4-4f7a-b4d4-82fedc7914ca'​,E​'spendable'​,E​'berry'​,​NULL​), (E​'c90636c6-6e72-4da8-af2e-5761eee72a32'​,E​'receivable'​,E​'downy woodpecker'​,E​'{"5c0e1be2-ed5d-4be8-b45f-26961e27b169": 1, "be13a699-8328-4d82-827c-bdfa9488804a": 1, "ac0eff93-59e4-4f7a-b4d4-82fedc7914ca": 1}'​), (E​'be13a699-8328-4d82-827c-bdfa9488804a'​,E​'spendable'​,E​'wheat'​,​NULL​), (E​'bfca8ebe-2c47-4fe6-8248-c5f356650380'​,E​'receivable'​,E​'tree swallow'​,E​'{"ac0eff93-59e4-4f7a-b4d4-82fedc7914ca": 1, "5c0e1be2-ed5d-4be8-b45f-26961e27b169": 1}'​);
INSERT​ ​INTO​ ​"transactions"​(​"id"​,​"user_id"​,​"received"​,​"spent"​)
VALUES (E​'0cb93a3f-bb45-4c79-ba06-68689c35b21f'​,E​'ba637a13-4ae0-45c0-b36a-06e762b4d46f'​,E​'{"5c0e1be 2-ed5d-4be8-b45f-26961e27b169": 1}'​,​NULL​), (E​'fb922e00-7b10-4891-841e-1dcfafcb3ac8'​,E​'427dfaca-cdc8-4004-a329-27b46e2d1900'​,E​'{"ac0eff9 3-59e4-4f7a-b4d4-82fedc7914ca": 1}'​,​NULL​), (E​'8e6dfe23-8cee-4632-ac0c-114ad33123b3'​,E​'427dfaca-cdc8-4004-a329-27b46e2d1900'​,E​'{"5c0e1be 2-ed5d-4be8-b45f-26961e27b169": 1}'​,​NULL​), (E​'f3131592-25da-4688-8cb4-e9fd9f8270b8'​,E​'427dfaca-cdc8-4004-a329-27b46e2d1900'​,E​'{"bfca8eb e-2c47-4fe6-8248-c5f356650380": 1}'​,E​'{"ac0eff93-59e4-4f7a-b4d4-82fedc7914ca": 1, "5c0e1be2-ed5d-4be8-b45f-26961e27b169": 1}'​);
/* ------ */



/*
1. What should be the CREATE statement for a new table game_item_locations
that consists of different game_items assigned to locations per user_id?
*/

CREATE TABLE game_item_locations (
    id uuid PRIMARY KEY,
    user_id uuid
    game_item uuid
    location uuid
    FOREIGN KEY (user_id) REFERENCES users(id)
    FOREIGN KEY (game_item) REFERENCES game_items(id)
    FOREIGN KEY (location) REFERENCES locations(id)
);

/*
2. Insert dummy data for for transactions, locations, game_item_locations (5k rows for each
table for 100 different user_ids)
*/
BEGIN
    INSERT INTO "users" (id, username) VALUES (...) RETURNING id AS uid
    INSERT INTO "location" ("geom") VALUES ((...),(...)) RETURNING id AS lid;
    INSERT INTO "transactions" ("user_id","received","spent") VALUES ((uid,...),(uid,...))
COMMIT;


/*
3. Which user has received the ​downy woodpecker​ the most often​?
*/
SELECT user_id FROM transactions t WHERE t.received->>(SELECT id FROM game_items WHERE display_name='downy woodpecker' LIMIT 1)=1 ORDER BY COUNT(t.user_id) DESC LIMIT 1

/*
4. What are the aggregated counts per item for each user or itemCounts?
*/


/*
5. What are the item_locations within a 3km radius for a given lat, lng for a user_id, sorted by distance?
*/
PREPARE locations_in_radius(int) AS
SELECT * FROM item_locations, ST_DistanceSphere(ST_MakePoint($1, $2),4236), item_locations.geom) as loc_dist WHERE loc_dist < 3000 ORDER BY loc_dist;


