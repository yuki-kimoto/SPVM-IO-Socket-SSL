package SPVM::IO::Socket::SSL;

our $VERSION = "0.007";

1;

=head1 Name

SPVM::IO::Socket::SSL - Sockets for SSL Communication.

=head1 Description

B<This class is highly experimental and not yet implemented completly and not tested well and not yet documented.>

IO::Socket::SSL class in L<SPVM> represents sockets for SSL communication.

=head1 Usage

  use IO::Socket::SSL;
  
  # Client
  my $host = "www.google.com";
  my $port = 443;
  my $socket = IO::Socket::SSL->new({PeerAddr => $host, PeerPort => $port});
  
  my $write_buffer = "GET / HTTP/1.0\r\nHost: $host\r\n\r\n";
  $socket->write($write_buffer);
  
  my $read_buffer = (mutable string)new_string_len 100000;
  while (1) {
    my $read_length = $socket->read($read_buffer);
    
    if ($read_length < 0) {
      die "Read error";
    }
    
    if ($read_length < length $read_buffer) {
      last;
    }
  }
  
  # Server
  my $server_socket = IO::Socket::SSL->new({
    Listen => 10,
  });
  $server_socket->accept;
  
=head1 Super Class

L<IO::Socket::IP|SPVM::IO::Socket::IP>

=head1 Fields

=head2 ssl_ctx

C<has ssl_ctx : ro L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX>;>

A L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> object.

=head2 ssl

C<has ssl : ro L<Net::SSLeay|SPVM::Net::SSLeay>;>

A L<Net::SSLeay|SPVM::Net::SSLeay> object. This object is set after L</"connect_SSL"> method or L</"accept_SSL"> method succeeds.

=head2 before_connect_SSL_cbs_list

C<has before_connect_SSL_cbs_list : ro List of L<IO::Socket::SSL::Callback::BeforeConnectSSL|SPVM::IO::Socket::SSL::Callback::BeforeConnectSSL>;>

A list of callbacks called before L</"connect_SSL"> method.

=head2 before_accept_SSL_cbs_list

C<has before_accept_SSL_cbs_list : ro List of L<IO::Socket::SSL::Callback::BeforeAcceptSSL|SPVM::IO::Socket::SSL::Callback::BeforeAcceptSSL>;>

A list of callbacks called before L</"accept_SSL"> method.

=head1 Constructor Options

=head2 SSL_startHandshake

Type: L<Int|SPVM::Int>

Default: 1

It this option is a true value, L</"configure"> method calls L</"connect_SSL"> method in the case that the instance is a client socket, and L</"accept"> method calls L</"accept_SSL">.

=head2 SSL_verify_mode

Type: L<Int|SPVM::Int>

If the option is not specified and the instance is a client socket, the option value is set to C<SSL_VERIFY_PEER|SPVM::Net::SSLeay::Constant/"SSL_VERIFY_PEER">.

Otherwise it is set to C<SSL_VERIFY_NONE|SPVM::Net::SSLeay::Constant/"SSL_VERIFY_NONE">.

L</"configure_SSL"> method calls L<set_verify|Net::SSLeay::SSL_CTX#set_verify> method given the option value and the value of C<SSL_verify_callback> option.

=head2 SSL_verify_callback

Type: L<Net::SSLeay::Callback::Verify|SPVM::Net::SSLeay::Callback::Verify>

See C<SSL_verify_mode> option about its beheivior.

=head2 SSL_passwd_cb

Type: L<Net::SSLeay::Callback::PemPassword|SPVM::Net::SSLeay::Callback::PemPassword>

If the option value is defined, L</"configure_SSL"> method calls L<set_default_passwd_cb|Net::SSLeay::SSL_CTX#set_default_passwd_cb> method given the option value.

=head2 SSL_check_crl

Type: L<Int|SPVM::Int>

The option value is a true value, C<X509_V_FLAG_CRL_CHECK|SPVM::Net::SSLeay::Constant/"X509_V_FLAG_CRL_CHECK"> flag is set to the L<Net::SSLeay::X509_VERIFY_PARAM|SPVM::Net::SSLeay::X509_VERIFY_PARAM> object stored in the L<Net::SSLeay::SSL_CTX> object.

Adds C<X509_V_FLAG_CRL_CHECK> flag to the certificate store options.

=head2 SSL_crl_file

Type: string

Add all CRLs contained in the file specified by this option to the certificate store.

=head2 SSL_ca_file

Type: string

=head2 SSL_ca_path

Type: string

=head2 SSL_ca

Type: L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509>[]

=head2 SSL_cert_file

Type: string

=head2 SSL_cert

Type: L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509>[]

=head2 SSL_key_file

Type: string

=head2 SSL_key

Type: L<Net::SSLeay::EVP_PKEY|SPVM::Net::SSLeay::EVP_PKEY>

=head2 SSL_hostname

Type: string

=head2 SSL_alpn_protocols

Type: string[]

=head1 Class Methods

=head2 new

C<static method new : L<IO::Socket::SSL|SPVM::IO::Socket::SSL> ($options : object[] = undef);>

Creates a new L<IO::Socket::SSL|SPVM::IO::Socket::SSL> object, calls L</"init"> method given the options $options, calls L</"configure"> method, and returns the new object.

See L</"Constructor Options"> about $options.

=head1 Instance Methods

=head2 init

C<protected method init : void ($options : object[] = undef);>

Initialize the instance given the options $options.

See L</"Constructor Options"> about $options.

=head2 option_names

C<protected method option_names : string[] ();>

Returns available option names passed to L</"init"> method.

=head2 configure

C<protected method configure : void ();>

Congigures the instance by the following logic.

Calls L<configure|SPVM::IO::Socket::IP> method in the super class and calls L</"configure_SSL"> method.

If the value of L</"SSL_startHandshake"> option is a true value and the instance is a client socket, calls L</"connect_SSL"> method.

=head2 configure_SSL

C<protected method configure_SSL : void ();>

Creates a new L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> object, configures the new L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> using L<options|/"Constructor Options"> passed to L</"init"> method, and sets L</"ssl_ctx"> field to the new L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> object.

=head2 connect_SSL

C<method connect_SSL : void ();>

Creates a new L<Net::SSLeay|SPVM::Net::SSLeay> object, and connects the SSL connection by calling L<Net::SSLeay#connect|SPVM::Net::SSLeay/"connect"> method.

If there are callbacks in L</"before_connect_SSL_cbs_list"> field, these callbacks are performed given the instance, the new L<Net::SSLeay|SPVM::Net::SSLeay> object before calling L<Net::SSLeay#connect|SPVM::Net::SSLeay/"connect"> method.

If an IO wait occurs, the program jumps to the L<goroutine scheduler|SPVM::Go>, and retries this operation until it succeeds or the timeout seconds set by L<Timeout|SPVM::IO::Socket/"Timeout"> field expires.

Exceptions:

Exceptions thrown by L<Net::SSLeay#connect|SPVM::Net::SSLeay/"connect"> method could be thrown.

If timeout occurs, an exception is thrown with C<eval_error_id> set to the basic type ID of L<Go::Error::IOTimeout|SPVM::Go::Error::IOTimeout>.

=head2 accept_SSL

C<method accept_SSL : void ();>

Creates a new L<Net::SSLeay|SPVM::Net::SSLeay> object, and accepts the SSL connection by calling L<Net::SSLeay#accept|SPVM::Net::SSLeay/"accept"> method.

If there are callbacks in L</"before_accept_SSL_cbs_list"> field, these callbacks are performed given the instance, the new L<Net::SSLeay|SPVM::Net::SSLeay> object before calling L<Net::SSLeay#accept|SPVM::Net::SSLeay/"accept"> method.

If an IO wait occurs, the program jumps to the L<goroutine scheduler|SPVM::Go>, and retries this operation until it succeeds or the timeout seconds set by L<Timeout|SPVM::IO::Socket/"Timeout"> field expires.

Exceptions:

Exceptions thrown by L<Net::SSLeay#accept|SPVM::Net::SSLeay/"accept"> method could be thrown.

If timeout occurs, an exception is thrown with C<eval_error_id> set to the basic type ID of L<Go::Error::IOTimeout|SPVM::Go::Error::IOTimeout>.

=head2 accept

C<method accept : L<IO::Socket::SSL|SPVM::IO::Socket::SSL> ($peer_ref : Sys::Socket::Sockaddr[] = undef);>

Creates a new L<IO::Socket::SSL|SPVM::IO::Socket::SSL> object by calling L<accept|SPVM::IO::Socket::IP/"accept"> method in the super class.

And sets the L</"ssl_ctx"> field in the new object to the value of L</"ssl_ctx"> field in the instance.

And if the value of L</"SSL_startHandshake"> option is a true value, calls L</"accept_SSL"> method.

And returns the new object.

=head2 read

C<method read : int ($buffer : mutable string, $length : int = -1, $offset : int = 0);>

Reads the buffer $buffer at offset $offset to the length $length from the socket by calling L<Net::SSLeay#read|SPVM::Net::SSLeay/"read"> method.

If an IO wait occurs, the program jumps to the L<goroutine scheduler|SPVM::Go>, and retries this operation until it succeeds or the timeout seconds set by L<Timeout|SPVM::IO::Socket/"Timeout"> field expires.

Exceptions:

Exceptions thrown by L<Net::SSLeay#read|SPVM::Net::SSLeay/"read"> method could be thrown.

If timeout occurs, an exception is thrown with C<eval_error_id> set to the basic type ID of L<Go::Error::IOTimeout|SPVM::Go::Error::IOTimeout>.

=head2 write

C<method write : int ($buffer : string, $length : int = -1, $offset : int = 0);>

Writes the buffer $buffer at offset $offset to the length $length to the socket by calling L<Net::SSLeay#write|SPVM::Net::SSLeay/"write"> method.

If an IO wait occurs, the program jumps to the L<goroutine scheduler|SPVM::Go>, and retries this operation until it succeeds or the timeout seconds set by L<Timeout|SPVM::IO::Socket/"Timeout"> field expires.

Exceptions:

Exceptions thrown by L<Net::SSLeay#write|SPVM::Net::SSLeay/"write"> method could be thrown.

If timeout occurs, an exception is thrown with C<eval_error_id> set to the basic type ID of L<Go::Error::IOTimeout|SPVM::Go::Error::IOTimeout>.

=head2 shutdown_SSL

C<method shutdown_SSL : int ();>

Shutdowns the SSL connection by calling L<Net::SSLeay#shutdown|SPVM::Net::SSLeay/"shutdown"> method.

If an IO wait occurs, the program jumps to the L<goroutine scheduler|SPVM::Go>, and retries this operation until it succeeds or the timeout seconds set by L<Timeout|SPVM::IO::Socket/"Timeout"> field expires.

Exceptions:

Exceptions thrown by L<Net::SSLeay#shutdown|SPVM::Net::SSLeay/"shutdown"> method could be thrown.

If timeout occurs, an exception is thrown with C<eval_error_id> set to the basic type ID of L<Go::Error::IOTimeout|SPVM::Go::Error::IOTimeout>.

=head2 alpn_selected

C<method alpn_selected : string ();>

Calls L<Net::SSLeay#get0_alpn_selected_return_string|SPVM::Net::SSLeay/"get0_alpn_selected_return_string"> method and returns its return value.

=head2 get_sslversion

C<method get_sslversion : string ();>

Calls L<Net::SSLeay#get_version|SPVM::Net::SSLeay/"get_version"> method given the value of L</"ssl"> field, and returns its return value.

Exceptions:

If the version number is unknown, an exception is thrown.

=head2 get_sslversion_int

C<method get_sslversion_int : int ();>

Calls L<Net::SSLeay#version|SPVM::Net::SSLeay/"version"> method given the value of L</"ssl"> field, and returns its return value.

=head2 get_cipher

C<method get_cipher : string ();>

Calls L<Net::SSLeay#get_cipher|SPVM::Net::SSLeay/"get_cipher"> method given the value of L</"ssl"> field, and returns its return value.

Exceptions:

Exceptions thrown by L<Net::SSLeay#get_cipher|SPVM::Net::SSLeay/"get_cipher"> method could be thrown.

=head2 get_servername

C<method get_servername : string ();>

Calls L<Net::SSLeay#get_servername|SPVM::Net::SSLeay/"get_servername"> method given the value of L</"ssl"> field, the value of C<TLSEXT_NAMETYPE_host_name>, and returns its return value.

Exceptions:

Exceptions thrown by L<Net::SSLeay#get_servername|SPVM::Net::SSLeay/"get_servername"> method could be thrown.

=head2 peer_certificate

C<method peer_certificate : L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509> ();>

Calls L<Net::SSLeay#get_peer_certificate|SPVM::Net::SSLeay/"get_peer_certificate"> method given the value of L</"ssl"> field, and returns its return value.

Exceptions:

Exceptions thrown by L<Net::SSLeay#get1_peer_certificate|SPVM::Net::SSLeay/"get1_peer_certificate"> method could be thrown.

=head2 peer_certificates

C<method peer_certificates : L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509>[];>

Returns the array that contains a certificate and all chain certificates of the peer.

If a certificate cannot be got, return an empty array.

=head2 sock_certificate

C<method sock_certificate : L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509> ();>

Calls L<Net::SSLeay#get_certificate|SPVM::Net::SSLeay/"get_certificate"> method given the value of L</"ssl"> field, and returns its return value.

Exceptions:

Exceptions thrown by L<Net::SSLeay#get_certificate|SPVM::Net::SSLeay/"get_certificate"> method could be thrown.

=head2 add_before_connect_SSL_cb

C<method add_before_connect_SSL_cb : void ($cb : L<IO::Socket::SSL::Callback::BeforeConnectSSL|SPVM::IO::Socket::SSL::Callback::BeforeConnectSSL>);>

Adds the callback $cb to the end of the elements of L</"before_connect_SSL_cb_list"> field.

=head2 add_before_accept_SSL_cb

C<method add_before_accept_SSL_cb : void ($cb : L<IO::Socket::SSL::Callback::BeforeAcceptSSL|SPVM::IO::Socket::SSL::Callback::BeforeAcceptSSL>);>

Adds the callback $cb to the end of the elements of L</"before_accept_SSL_cb_list"> field.

=head2 dump_peer_certificate

C<method dump_peer_certificate : string ();>

Calls L<Net::SSLeay#dump_peer_certificate|SPVM::Net::SSLeay/"dump_peer_certificate"> method given the value of L</"ssl"> field, and returns its return value.

Exceptions:

Exceptions thrown by L<Net::SSLeay#dump_peer_certificate|SPVM::Net::SSLeay/"dump_peer_certificate"> method could be thrown.

=head2 stat

C<method stat : L<Sys::IO::Stat|SPVM::Sys::IO::Stat> ();>

This method is not supported in L<IO::Socket::SSL|SPVM::IO::Socket::SSL>.

Exceptions:

An exception is thrown.

=head2 send

C<method send : int ($buffer : string, $flags : int = 0, $length : int = -1, $offset : int = 0);>

This method is not supported in L<IO::Socket::SSL|SPVM::IO::Socket::SSL>.

Exceptions:

An exception is thrown.

=head2 sendto

C<method sendto : int ($buffer : string, $flags : int, $to : Sys::Socket::Sockaddr, $length : int = -1, $offset : int = 0);>

This method is not supported in L<IO::Socket::SSL|SPVM::IO::Socket::SSL>.

Exceptions:

An exception is thrown.

=head2 recv

C<method recv : int ($buffer : mutable string, $length : int = -1, $flags : int = 0, $offset : int = 0);>

This method is not supported in L<IO::Socket::SSL|SPVM::IO::Socket::SSL>.

Exceptions:

An exception is thrown.

=head2 recvfrom

C<method recvfrom : int ($buffer : mutable string, $length : int, $flags : int, $from_ref : Sys::Socket::Sockaddr[], $offset : int = 0);>

This method is not supported in L<IO::Socket::SSL|SPVM::IO::Socket::SSL>.

Exceptions:

An exception is thrown.

=head2 DESTROY

C<method DESTROY : void ();>

Shutdowns the SSL connection and closes the socket.

Implementation:

If the socket is opened, performs the following logic.

If the SSL connection is established, calls L</"shutdown_SSL"> method.

And closes the socket.

=head1 FAQ

=head2 How to customize L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> object?

Sets L</"SSL_startHandshake"> option to 0, gets a L<Net::SSLeay::SSL_CTX|SPVM::Net::SSLeay::SSL_CTX> object by L</"ssl_ctx"> getter, customizes it, and calls L</"connect_SSL"> method in a client or calls L</"accept_SSL"> method.

Client:

  use Net::SSLeay::Constant as SSL;
  
  my $host = "www.google.com";
  my $port = 443;
  my $socket = IO::Socket::SSL->new({PeerAddr => $host, PeerPort => $port, SSL_startHandshake => 0});
  
  my $ssl_ctx = $socket->ssl_ctx;
  
  $ssl_ctx->set_min_proto_version(SSL->TLS1_1_VERSION);
  
  $socket->connect_SSL;
  
  my $ssl = $socket->ssl;

Server:

  use Net::SSLeay::Constant as SSL;
  
  my $host = "www.google.com";
  my $port = 443;
  my $socket = IO::Socket::SSL->new({Listen => 1, SSL_startHandshake => 0});
  
  my $ssl_ctx = $socket->ssl_ctx;
  
  $ssl_ctx->set_min_proto_version(SSL->TLS1_1_VERSION);
  
  my $accepted_socket = $socket->accept;
  
  $accepted_socket->accept_SSL;

=head2 How to create L<Net::SSLeay::X509|SPVM::Net::SSLeay::X509> objects for C<SSL_ca> option from the return value of L<Mozilla::CA#SSL_ca|SPVM::Mozilla::CA/"SSL_ca"> method?

  use Mozilla::CA;
  use Net::SSLeay::BIO;
  use Net::SSLeay::PEM;
  use List;
  
  my $ca = Mozilla::CA->SSL_ca;
  
  my $bio = Net::SSLeay::BIO->new;
  
  $bio->write($ca);
  
  my $x509s_list = List->new(new Net::SSLeay::X509[0]);
  while (1) {
    my $x509 = (Net::SSLeay::X509)undef;
    
    eval { $x509 = Net::SSLeay::PEM->read_bio_X509($bio); }
    
    if ($@) {
      if (eval_error_id isa_error Net::SSLeay::Error::PEM_R_NO_START_LINE) {
        last;
      }
      else {
        die $@;
      }
    }
    
    $x509s_list->push($x509);
  }
  
  my $x509s = (Net::SSLeay::X509[])$x509s_list->to_array;
  
  my $SSL_ca_option = $x509x;

=head1 See Also

=over 2

=item * L<IO::Socket::IP|SPVM::IO::Socket::IP>

=item * L<Net::SSLeay|SPVM::Net::SSLeay>

=back

=head1 Repository

L<SPVM::IO::Socket::SSL - Github|https://github.com/yuki-kimoto/SPVM-IO-Socket-SSL>

=head1 Author

Yuki Kimoto C<kimoto.yuki@gmail.com>

=head1 Copyright & License

Copyright (c) 2024 Yuki Kimoto

MIT License

