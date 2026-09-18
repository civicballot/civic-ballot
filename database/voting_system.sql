CREATE DATABASE IF NOT EXISTS civic_ballot CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE civic_ballot;

CREATE TABLE elections (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(160) NOT NULL,
    description TEXT NOT NULL,
    opens_at DATETIME NOT NULL,
    closes_at DATETIME NOT NULL,
    status ENUM('draft', 'open', 'closed') NOT NULL DEFAULT 'draft',
    results_mode ENUM('live', 'after_close') NOT NULL DEFAULT 'after_close',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE offices (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    election_id INT UNSIGNED NOT NULL,
    name VARCHAR(120) NOT NULL,
    display_order TINYINT UNSIGNED NOT NULL DEFAULT 1,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
);

CREATE TABLE parties (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    abbreviation VARCHAR(20) NOT NULL,
    color CHAR(7) NOT NULL DEFAULT '#1f6f5b',
    logo_path VARCHAR(255) NULL
);

CREATE TABLE candidates (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    office_id INT UNSIGNED NOT NULL,
    party_id INT UNSIGNED NOT NULL,
    name VARCHAR(160) NOT NULL,
    photo_path VARCHAR(255) NULL,
    bio TEXT NULL,
    FOREIGN KEY (office_id) REFERENCES offices(id) ON DELETE CASCADE,
    FOREIGN KEY (party_id) REFERENCES parties(id)
);

CREATE TABLE voters (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    voter_reference CHAR(12) NOT NULL UNIQUE,
    nin_hash CHAR(64) NOT NULL UNIQUE,
    pvc_reference VARCHAR(40) NOT NULL UNIQUE,
    full_name VARCHAR(160) NOT NULL,
    state VARCHAR(80) NOT NULL,
    lga VARCHAR(100) NOT NULL,
    verified_at DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE voter_election_status (
    voter_id INT UNSIGNED NOT NULL,
    election_id INT UNSIGNED NOT NULL,
    has_voted TINYINT(1) NOT NULL DEFAULT 0,
    voted_at DATETIME NULL,
    PRIMARY KEY (voter_id, election_id),
    FOREIGN KEY (voter_id) REFERENCES voters(id) ON DELETE CASCADE,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
);

CREATE TABLE ballots (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    election_id INT UNSIGNED NOT NULL,
    receipt_code CHAR(16) NOT NULL UNIQUE,
    cast_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
);

CREATE TABLE ballot_choices (
    ballot_id BIGINT UNSIGNED NOT NULL,
    office_id INT UNSIGNED NOT NULL,
    candidate_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (ballot_id, office_id),
    FOREIGN KEY (ballot_id) REFERENCES ballots(id) ON DELETE CASCADE,
    FOREIGN KEY (office_id) REFERENCES offices(id) ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);

CREATE TABLE audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    actor_type ENUM('voter', 'admin', 'system') NOT NULL,
    actor_reference VARCHAR(80) NULL,
    event_type VARCHAR(80) NOT NULL,
    metadata JSON NULL,
    ip_hash CHAR(64) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO elections (title, description, opens_at, closes_at, status, results_mode)
VALUES ('2026 Community Association Election', 'A private demonstration election for registered association members.', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 10 DAY, 'open', 'live');
SET @election_id = LAST_INSERT_ID();
INSERT INTO offices (election_id, name, display_order) VALUES
(@election_id, 'President', 1), (@election_id, 'Secretary', 2), (@election_id, 'Treasurer', 3);
INSERT INTO parties (name, abbreviation, color) VALUES ('Forward Together', 'FT', '#d47b4a'), ('Common Ground', 'CG', '#397a76'), ('Independent', 'IND', '#7e725e');
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Amaka Okafor', 'Community organizer focused on transparent leadership.' FROM offices o JOIN parties p ON p.abbreviation = 'FT' WHERE o.name = 'President' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Daniel Mensah', 'Advocate for practical member services and accountability.' FROM offices o JOIN parties p ON p.abbreviation = 'CG' WHERE o.name = 'President' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Fatima Bello', 'Independent voice for inclusive decision-making.' FROM offices o JOIN parties p ON p.abbreviation = 'IND' WHERE o.name = 'President' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Kelechi Nwosu', 'Brings a decade of administrative experience.' FROM offices o JOIN parties p ON p.abbreviation = 'FT' WHERE o.name = 'Secretary' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Musa Ibrahim', 'Focused on clear records and responsive communication.' FROM offices o JOIN parties p ON p.abbreviation = 'CG' WHERE o.name = 'Secretary' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Ngozi Eze', 'Small-business owner and community volunteer.' FROM offices o JOIN parties p ON p.abbreviation = 'IND' WHERE o.name = 'Treasurer' AND o.election_id = @election_id;
INSERT INTO candidates (office_id, party_id, name, bio) SELECT o.id, p.id, 'Tunde Adebayo', 'Financial controller committed to accessible reporting.' FROM offices o JOIN parties p ON p.abbreviation = 'CG' WHERE o.name = 'Treasurer' AND o.election_id = @election_id;
INSERT INTO voters (voter_reference, nin_hash, pvc_reference, full_name, state, lga, verified_at)
VALUES ('VOTER-78291', SHA2('demo-nin-never-use-in-production', 256), 'PVC-2026-0042', 'Amina Yusuf', 'Lagos', 'Ikeja', NOW());
SET @voter_id = LAST_INSERT_ID();
INSERT INTO voter_election_status (voter_id, election_id) VALUES (@voter_id, @election_id);
