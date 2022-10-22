# HorizonStore

## About
This is an MVP for a store checkout feature. These are the current capabilites of the store:
- The available products are build by parsing a json config.
- A user can scan products and that will add them to a basket.
- A user can calculate the total of the products in the basket. The total will apply discounts if the content of the
  basket quialifies for any discount.

For more information about the project have a looc at the [challange.md](challange.md)

## Running the application locally

1. Clone the repo.
2. Run `mix deps.get`
3. Test the implementation in the console - `iex -S mix`

## Testing

The application has a suit of ExUnit tests. To run the whole suit use:

```bash
mix test
```

To speed up the development you can use:

```bash
mix test --stale --listen-on-stdin
```

This will run the whole suit the first time and will listen for an enter. When you hit enter only tests using stale
components or tests that were changed will be run. For more information see `mix help test`.
