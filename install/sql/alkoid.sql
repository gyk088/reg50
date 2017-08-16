-- Добавляем ид заказчика
-- step 0016

BEGIN;


-- добавить ид заказчика
ALTER TABLE merchant ADD COLUMN alkoid VARCHAR(64) UNIQUE;
ALTER TABLE official ADD COLUMN alkoid VARCHAR(64) UNIQUE;
ALTER TABLE product  ADD COLUMN alkoid VARCHAR(64) UNIQUE;

COMMENT ON COLUMN merchant.alkoid  IS 'ид в системе заказчика';
COMMENT ON COLUMN official.alkoid  IS 'ид в системе заказчика';
COMMENT ON COLUMN product.alkoid   IS 'ид в системе заказчика';

-- добавить поле person (директор)
ALTER TABLE official ADD COLUMN person VARCHAR(128);

COMMENT ON COLUMN official.person IS 'имя директора';

-- удаляем ограничение UNIQUE
ALTER TABLE official DROP CONSTRAINT official_taxcode_key;
ALTER TABLE shop     DROP CONSTRAINT shop_id_merchant_key;

-- удаляем ограничение NOT NULL
ALTER TABLE merchant ALTER password DROP NOT NULL;
ALTER TABLE merchant ALTER email    DROP NOT NULL;

-- устанавливаем тип свотйсва "Цена" float
UPDATE paramvalue SET value = 'float' WHERE id_propgroup = 1 AND n_propgroup = 1 AND n_proptype = 1;

-- добавляем свойсво количество
INSERT INTO property (id_propgroup, n, id_proptype, name, visible) VALUES (1, 8, 1, 'Qty', true);
INSERT INTO paramvalue (id_propgroup, n_propgroup, id_proptype, n_proptype, value) VALUES (1, 8, 1, 1, 'integer');

-- удаляем таблицу client
DROP TABLE IF EXISTS client;


COMMIT;