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
ALTER TABLE net      DROP CONSTRAINT net_id_merchant_key;

-- удаляем ограничение NOT NULL
ALTER TABLE merchant ALTER password    DROP NOT NULL;
ALTER TABLE merchant ALTER email       DROP NOT NULL;
ALTER TABLE shop     ALTER id_merchant DROP NOT NULL;

-- добавляем тип DECIMAL(10, 2)
ALTER TABLE propvalue ADD COLUMN val_dec DECIMAL(10, 2);

COMMENT ON COLUMN propvalue.val_dec IS 'вещественное, два символа после запятой';

-- устанавливаем тип свойства "Цена" decimal
UPDATE paramvalue SET value = 'decimal' WHERE id_propgroup = 1 AND n_propgroup = 1 AND n_proptype = 1;

-- добавляем свойсво количество товара в наличии
INSERT INTO property (id_propgroup, n, id_proptype, name, visible) VALUES (1, 8, 1, 'Qty', true);
INSERT INTO paramvalue (id_propgroup, n_propgroup, id_proptype, n_proptype, value) VALUES (1, 8, 1, 1, 'integer');

-- добавляем фильр по крепости (% об)
UPDATE property SET filters = true, id_filterui = 1 WHERE n = 5;
INSERT INTO filterarg_link (id_propgroup, n_property, id_filterarg) VALUES (1, 5, 1);
INSERT INTO filterarg_link (id_propgroup, n_property, id_filterarg) VALUES (1, 5, 2);

-- меняем название для свойств тип данных у которых "отдельная таблица"
UPDATE proptype SET name = 'unitable'  WHERE id = 4;

-- удаляем таблицу client
DROP TABLE IF EXISTS client;


COMMIT;