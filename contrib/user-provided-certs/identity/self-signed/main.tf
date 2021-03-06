# Identity's gRPC server/client certificates

resource "tls_private_key" "identity_server" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "identity_server" {
  key_algorithm   = "${tls_private_key.identity_server.algorithm}"
  private_key_pem = "${tls_private_key.identity_server.private_key_pem}"

  subject {
    common_name = "tectonic-identity-api.tectonic-system.svc.cluster.local"
  }
}

resource "tls_locally_signed_cert" "identity_server" {
  cert_request_pem = "${tls_cert_request.identity_server.cert_request_pem}"

  ca_key_algorithm   = "${var.ca_key_alg}"
  ca_private_key_pem = "${var.ca_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  validity_period_hours = 26280

  allowed_uses = [
    "server_auth",
  ]
}

resource "tls_private_key" "identity_client" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "identity_client" {
  key_algorithm   = "${tls_private_key.identity_client.algorithm}"
  private_key_pem = "${tls_private_key.identity_client.private_key_pem}"

  subject {
    common_name = "tectonic-identity-api.tectonic-system.svc.cluster.local"
  }
}

resource "tls_locally_signed_cert" "identity_client" {
  cert_request_pem = "${tls_cert_request.identity_client.cert_request_pem}"

  ca_key_algorithm   = "${var.ca_key_alg}"
  ca_private_key_pem = "${var.ca_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  validity_period_hours = 26280

  allowed_uses = [
    "client_auth",
  ]
}

resource "local_file" "server_crt_pem" {
  content  = "${tls_locally_signed_cert.identity_server.cert_pem}"
  filename = "./generated/tls/identity-server.crt"
}

resource "local_file" "server_key_pem" {
  content  = "${tls_private_key.identity_server.private_key_pem}"
  filename = "./generated/tls/identity-server.key"
}

resource "local_file" "client_crt_pem" {
  content  = "${tls_locally_signed_cert.identity_client.cert_pem}"
  filename = "./generated/tls/identity-client.crt"
}

resource "local_file" "client_key_pem" {
  content  = "${tls_private_key.identity_client.private_key_pem}"
  filename = "./generated/tls/identity-client.key"
}
