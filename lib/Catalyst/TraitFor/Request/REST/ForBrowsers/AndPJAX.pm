package Catalyst::TraitFor::Request::REST::ForBrowsers::AndPJAX;

# ABSTRACT: Acknowledge C<PJAX> requests as browser requests

use Moose::Role;
use namespace::autoclean;

with 'Catalyst::TraitFor::Request::REST::ForBrowsers' =>{
    -excludes => [ '_build_looks_like_browser' ],
    -alias    => {
        _build_looks_like_browser => '_original_build_looks_like_browser',
    },
};

=method looks_like_browser

This method is wrapped to return true if the method is GET and the C<X-Pjax>
header is present and is 'true'.

Otherwise we hand things off to the original method, to render its verdict as
to the tenor of the request.

=cut

sub _build_looks_like_browser {
    my ($self) = @_;

    my $pjax = $self->header('X-Pjax') || 'false';

    return 1
        if $pjax eq 'true' && uc $self->method eq 'GET';

    return $self->_original_build_looks_like_browser;
}


!!42;
__END__

=head1 SYNOPSIS

    # in your app class
    use CatalystX::RoleApplicator;
    __PACKAGE__->apply_request_class_roles(qw/
        Catalyst::TraitFor::Request::REST::ForBrowsers::AndPJAX
    /);

    # then, off in an controller somewhere...
    sub action_GET_html { ... also called for PJAX requests ...  }

=head1 DESCRIPTION

This is a tiny little L<Catalyst::Request> class trait that recognizes that a
PJAX request is also a browser request, and thus looks_like_browser() also
returns true when the method is GET and the C<X-Pjax> header is present and is
'true'.

This allows actions using an action class of REST::ForBrowsers to
transparently handle PJAX requests, without requiring any more modification to
the controller or application than applying this trait to the request class,
rather than plain-old L<Catalyst::TraitFor::Request::REST::ForBrowsers>.

=head1 SEE ALSO

L<Catalyst::TraitFor::Request::REST::ForBrowsers>
L<Catalyst::Action::REST::ForBrowsers>
L<Plack::Middleware::Pjax>

=cut
