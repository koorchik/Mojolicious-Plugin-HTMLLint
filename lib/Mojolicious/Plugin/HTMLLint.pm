package Mojolicious::Plugin::HTMLLint;
use Mojo::Base 'Mojolicious::Plugin';

use HTML::Lint;

our $VERSION = '0.02';

sub register {
    my ( $self, $app, $conf ) = @_;
    $conf ||= {};
    
    my $skip = delete $conf->{skip} // [];
    
    my $lint = HTML::Lint->new(%$conf);
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
                my $err_msg = $error->as_string();
                next if $err_msg ~~ $skip;
                $log->warn("HTMLLint: " . $error->as_string );
            }            
        } );
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::HTMLLint - HTML::Lint support for Mojolicious

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('HTMLLint');
  
  # Mojolicious (skip errors that contain "placeholder" string)
  $self->plugin( 'HTMLLint', { skip => [ qr/placeholder/ ] } ); 

  # Mojolicious::Lite
  plugin 'HTMLLint';

=head1 DESCRIPTION

L<Mojolicious::Plugin::HTMLLint> - allows you to validate HTML rendered by your application. The plugin uses HTML::Lint for validation. Errors will appear in Mojolicious log. 

=head1 CONFIG

Config will be passed to HTML::Lint->new();  
For support options see L<HTML::Lint>

=head2 C<skip> 

  $app->plugin('HTMLLint', { skip => [ qr//, qr// ]} );

This options says what message not to show.   

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Viktor Turskyi <koorchik@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to Github L<https://github.com/koorchik/Mojolicious-Plugin-HTMLLint>

=head1 SEE ALSO

L<Mojolicious>, L<HTML::Lint>, L<HTML::Tidy>  

=cut
