package Mojolicious::Plugin::HTMLLint;
use Mojo::Base 'Mojolicious::Plugin';

use HTML::Lint;

our $VERSION = '0.01';

sub register {
    my ( $self, $app ) = @_;
    
    my $lint = HTML::Lint->new;
    my $log = $app->log;
    
    $app->hook(
        'after_dispatch' => sub {
            my ( $c ) = @_;
            my $res = $c->res;

            # Only successful response
            return if $res->code !~ m/^2/;
 
            ## Only html response
            return unless $res->headers->content_type;
            return if $res->headers->content_type !~ /html/;
            
            $lint->parse($res->body);

            foreach my $error ( $lint->errors ) {
                $log->warn("HTMLLint: " . $error->as_string );
            }            
        } );
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::HTMLLint - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('HTMLLint');

  # Mojolicious::Lite
  plugin 'HTMLLint';

=head1 DESCRIPTION

L<Mojolicious::Plugin::HTMLLint> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::HTMLLint> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 C<register>

  $plugin->register;

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
