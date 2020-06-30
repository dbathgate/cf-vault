VAULT_VERSION=1.4.2

.DEFAULT_GOAL := download-vault

download-vault:
	rm -f vault
	curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -LO
	unzip vault_${VAULT_VERSION}_linux_amd64.zip
	rm vault_${VAULT_VERSION}_linux_amd64.zip

clean:
	rm -f vault