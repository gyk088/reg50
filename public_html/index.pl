#! /usr/bin/perl
#
# Homepage
#

use strict;
use warnings;

use WooF::Debug;
use ALKO::Server;
use ALKO::SendMail qw(send_mail);

my $Server = WooF::Server->new(output_t => 'JSON', auth => 0);

# Простейший обработчик. Клиенту отдается статичный шаблон, в лог веб-сервера - версия постгрис.
# URL: /
$Server->add_handler(DEFAULT => {
	call => sub {
		my $S = shift;

		my $rc = $S->D->fetch('SELECT VERSION()');
		debug 'VERSION=', $rc;

		OK;
	},
});

# Получить данные представителя магазина
#
# GET
# URL: /?
#   action = send_mail
#   name   = string
#   email  = string
#   phone  = string
#
$Server->add_handler(SEND_MAIL => {
	input => {
		allow => ['action', 'name', 'email', 'phone'],
	},
	call => sub {
		my $S = shift;
		my ($I, $O) = ($S->I, $S->O);

		send_mail({
			template => 'new_client',
			subject  => 'REG50 Регистрация',
			info     => $I
		});

		OK;
	},
});

$Server->dispatcher(sub {
	my $S = shift;
	my $I = $S->I;

	return ['SEND_MAIL'] if exists $I->{action} and $I->{action} eq 'send_mail';

	['DEFAULT'];
});


$Server->listen;
