#! /usr/bin/perl

use strict;
use warnings;
use utf8;

use WooF::Install;

my $install = WooF::Install->new(__FILE__);

$install->sql('alkoid.sql');

$install->complete(<<MSG);
- Добавлены ид закзчика в таблицы offical, merchant и product
- Изменили тип свойства Price на Float
- Добавили свойсво Qty
- Убрали ограничение UNIQUE
- Убрали ограничение NOT NULL
- Удалили таблицу clinet
MSG