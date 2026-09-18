# Civic Ballot

A private-election PHP/MySQL prototype for associations, schools, parties, shareholder groups, and test environments. It is not an INEC election system and does not connect to NIMC, BVAS, or any public voter register.

## Run locally

1. Create a MySQL database by importing `database/voting_system.sql`.
2. Set `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`, and `ADMIN_KEY` in the environment, or use the defaults in `config/database.php`.
3. Start PHP from the project root: `php -S localhost:8000`.
4. Open `http://localhost:8000`.

The demo login accepts a reference such as `VOTER-78291` and any non-empty PVC value. Replace `login.php` with a server-side authorized identity provider integration before using real identities. Never store raw NIN values.

Open `/admin/login.php` with the configured `ADMIN_KEY` to access the admin dashboard. This is a prototype gate, not a complete production admin identity system.

## Privacy model

`voters` and `voter_election_status` track eligibility and whether a person has voted. `ballots` and `ballot_choices` contain only anonymous ballot data. The submit transaction locks the voter status row, verifies it is unused, inserts the anonymous ballot, records choices, and marks the status used. Admin reporting should only aggregate `ballot_choices`.
