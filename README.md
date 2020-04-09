# homebus-gofundme

This is a simple HomeBus data source which publishes the current status of a GoFundMe campaign by scraping the campaign's front page.

## Usage

On its first run, `homebus-gofundme` needs to know how to find the HomeBus provisioning server.

```
bundle exec homebus-gofundme -b homebus-server-IP-or-domain-name -P homebus-server-port
```

The port will usually be 80 (its default value).

Once it's provisioned it stores its provisioning information in `.env.provisioning`.

`homebus-gofundme` also reads `GOFUNDME_URL` from `.env`, which will be the URL for the GOFUNDME campaign page.
