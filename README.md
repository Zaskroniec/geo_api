# GEOExcercise

## Requirements

* Elixir v1.15+
* Erlang 26.1+
* PostgreSQL 15.3+

## Setup

To start your Phoenix server:
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Endpoints

```bash
curl -i http://localhost:4000/api/locations/200.106.141.15
```

## Released application 

```bash
curl -i http://geo.gigalixirapp.com/api/locations/200.106.141.15
```

## Development

1. Setup your DB and adjust environment variables in `config/dev.exs` and `config/test.exs`
    1. As alternative of local PostgreSQL dependency use predefined docker-compose setup.
1. Run `mix test` to check if everything pass.

## Notes

### GeoImpoter lib

#### General

Lib is not implemented as a standalone OTP application. The strategy for implementation was to deliver a simple solution for use in API projects. Introducing configuration settings to the library might be considered an anti-pattern, but I chose this approach as the most optimal way to deliver the required functionality. Alternatively, the entire library could be refactored into a standalone OTP application with own supervision tree, registry and flexible configuration.

#### Data import

The row was marked as invalid when certain conditions were not met. As a result, the importer did not persist the row to the database.

The row was marked as invalid in the following cases:

* When any of the column data was empty (equals to "").
* When the changeset validation was unsuccessful, which included:
  * The inability to cast ip_address to the Postgres.Inet format.
  * Incorrect ranges for Longitude or Latitude.
  * Country_code not matching the two-character ISO format.
* When a row with the same ip_address was already present in the database.

#### Impoter

I chose to rely on an existing Hex package for parsing CSV files, which helped me avoid the extra work of handling complex parsing of raw data. In this case, the risk of using a 3rd-party library for such operations is not highly critical and is unlikely to be a potential blocker when updating the core Elixir version in the application.

#### LocationQuery

I deliberately chose to use `Ecto.NoResultError` as an error result from `EctoNetwork.INET` to avoid revealing specific information about an invalid `ip_address` format. All supported data structures are thoroughly documented in the function. Alternatively, the function could return `{:error, :invalid_format}`, which could then be handled by a dedicated API error.

#### Location schema

For the `ip_address` column, I used an already existing Hex package that supports the Postgres INET column type. For the `lon` and `lat` columns, I opted to use the `Decimal` column type to represent the most accurate data. It's worth noting that using `Decimal` may consume more disk space. Alternatively, types like inet, point (for lat and lon) could be implemented as own Ecto.Type modules.

### API

#### General

I don't have much experience yet in creating script-type functionalities that execute Elixir code directly. Therefore, I opted to create a simple script that triggers the built-in Gigalixir CLI within the container to run the Importer logic that could be used in crontab. If my application requires any scheduled tasks to be run in crontab, I prefer using already existing Hex packages that provide convenient wrappers for managing scheduled tasks (e.g., Oban).

