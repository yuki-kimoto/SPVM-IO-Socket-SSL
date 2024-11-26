# Development Note

## What features are not implemented and why?

### Options

#### SSL_dh_file, SSL_dh, SSL_ecdh_curve

I'm not a security expert so I select the default OpenSSL settings.

#### verify_hostname

Too complex to implement for now. It is good that another module implements this method.

#### errstr

Errors are reported by exceptions.

#### OCSP and SCSP Stapling Features

Too complex to implement for now. It is good that another module implements a callback for OCSP stapling.

#### Session Features

Too complex to implement for now. It is good that another module implements a callback for SSL session.
