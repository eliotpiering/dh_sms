# DhSms

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API
### Bulk Load Contactss

```
curl -d "@contacts.json" -X POST -H "Content-Type: application/json" http://localhost:4000/contacts/bulk
```
