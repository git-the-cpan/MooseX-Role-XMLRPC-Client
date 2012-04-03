#!/usr/bin/env perl
#
# This file is part of MooseX-Role-XMLRPC-Client
#
# This software is Copyright (c) 2011 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#

use Test::More 0.88;

{
    package MultipleWiths;

    use Moose;

    with 'MooseX::Role::XMLRPC::Client' => {
        name => 'bugzilla',
        uri  => 'https://bugzilla.redhat.com/xmlrpc.cgi',
        login_info => 0,
    };

    with 'MooseX::Role::XMLRPC::Client' => {
        name => 'foo',
        uri  => 'http://foo.org/a/b/c',
    };

    sub _build_foo_userid { __LINE__ }
    sub _build_foo_passwd { __LINE__ }

    sub foo_login  { __LINE__ }
    sub foo_logout { __LINE__ }
}

my $a = MultipleWiths->new;

ok  $a->can('bugzilla_uri'),        'can uri';
ok !$a->can('bugzilla_userid'),     'cannot userid';
ok  $a->can('_build_bugzilla_rpc'), 'can build rpc';
ok  $a->can('_build_bugzilla_uri'), 'can build uri';

isa_ok $a->bugzilla_rpc => 'RPC::XML::Client';

isa_ok $a->bugzilla_uri => 'URI';
is     $a->bugzilla_uri => 'https://bugzilla.redhat.com/xmlrpc.cgi', 'uri ok';

my $b = $a;  # lazy!

ok  $b->can('foo_uri'),        'can uri';
ok  $b->can('foo_userid'),     'cannot userid';
ok  $b->can('_build_foo_rpc'), 'can build rpc';
ok  $b->can('_build_foo_uri'), 'can build uri';

isa_ok $b->foo_rpc => 'RPC::XML::Client';

isa_ok $b->foo_uri => 'URI';
is     $b->foo_uri => 'http://foo.org/a/b/c', 'uri ok';

done_testing;
