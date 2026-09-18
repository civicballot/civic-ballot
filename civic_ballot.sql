-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 18, 2026 at 03:02 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `civic_ballot`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `actor_type` enum('voter','admin','system') NOT NULL,
  `actor_reference` varchar(80) DEFAULT NULL,
  `event_type` varchar(80) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `ip_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `actor_type`, `actor_reference`, `event_type`, `metadata`, `ip_hash`, `created_at`) VALUES
(1, 'voter', 'VOTER-78291', 'verification_success', NULL, 'eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3', '2026-09-15 14:21:22'),
(2, 'voter', 'VOTER-78291', 'verification_success', NULL, 'eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3', '2026-09-15 14:23:33'),
(3, 'voter', 'VOTER-78291', 'verification_success', NULL, 'eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3', '2026-09-15 14:23:53'),
(4, 'voter', NULL, 'ballot_cast', NULL, 'eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3', '2026-09-15 14:27:14');

-- --------------------------------------------------------

--
-- Table structure for table `ballots`
--

CREATE TABLE `ballots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `election_id` int(10) UNSIGNED NOT NULL,
  `receipt_code` char(16) NOT NULL,
  `cast_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ballots`
--

INSERT INTO `ballots` (`id`, `election_id`, `receipt_code`, `cast_at`) VALUES
(1, 1, 'AC24F3E526ABF395', '2026-09-15 15:27:14');

-- --------------------------------------------------------

--
-- Table structure for table `ballot_choices`
--

CREATE TABLE `ballot_choices` (
  `ballot_id` bigint(20) UNSIGNED NOT NULL,
  `office_id` int(10) UNSIGNED NOT NULL,
  `candidate_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ballot_choices`
--

INSERT INTO `ballot_choices` (`ballot_id`, `office_id`, `candidate_id`) VALUES
(1, 1, 1),
(1, 2, 4),
(1, 3, 6);

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `id` int(10) UNSIGNED NOT NULL,
  `office_id` int(10) UNSIGNED NOT NULL,
  `party_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(160) NOT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`id`, `office_id`, `party_id`, `name`, `photo_path`, `bio`) VALUES
(1, 1, 1, 'Amaka Okafor', NULL, 'Community organizer focused on transparent leadership.'),
(2, 1, 2, 'Daniel Mensah', NULL, 'Advocate for practical member services and accountability.'),
(3, 1, 3, 'Fatima Bello', NULL, 'Independent voice for inclusive decision-making.'),
(4, 2, 1, 'Kelechi Nwosu', NULL, 'Brings a decade of administrative experience.'),
(5, 2, 2, 'Musa Ibrahim', NULL, 'Focused on clear records and responsive communication.'),
(6, 3, 3, 'Ngozi Eze', NULL, 'Small-business owner and community volunteer.'),
(7, 3, 2, 'Tunde Adebayo', NULL, 'Financial controller committed to accessible reporting.');

-- --------------------------------------------------------

--
-- Table structure for table `elections`
--

CREATE TABLE `elections` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(160) NOT NULL,
  `description` text NOT NULL,
  `opens_at` datetime NOT NULL,
  `closes_at` datetime NOT NULL,
  `status` enum('draft','open','closed') NOT NULL DEFAULT 'draft',
  `results_mode` enum('live','after_close') NOT NULL DEFAULT 'after_close',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `elections`
--

INSERT INTO `elections` (`id`, `title`, `description`, `opens_at`, `closes_at`, `status`, `results_mode`, `created_at`) VALUES
(1, '2026 Community Association Election', 'A private demonstration election for registered association members.', '2026-09-15 14:16:17', '2026-09-25 15:16:17', 'open', 'live', '2026-09-15 14:16:17');

-- --------------------------------------------------------

--
-- Table structure for table `offices`
--

CREATE TABLE `offices` (
  `id` int(10) UNSIGNED NOT NULL,
  `election_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `display_order` tinyint(3) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `offices`
--

INSERT INTO `offices` (`id`, `election_id`, `name`, `display_order`) VALUES
(1, 1, 'President', 1),
(2, 1, 'Secretary', 2),
(3, 1, 'Treasurer', 3);

-- --------------------------------------------------------

--
-- Table structure for table `parties`
--

CREATE TABLE `parties` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `abbreviation` varchar(20) NOT NULL,
  `color` char(7) NOT NULL DEFAULT '#1f6f5b',
  `logo_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parties`
--

INSERT INTO `parties` (`id`, `name`, `abbreviation`, `color`, `logo_path`) VALUES
(1, 'Forward Together', 'FT', '#d47b4a', NULL),
(2, 'Common Ground', 'CG', '#397a76', NULL),
(3, 'Independent', 'IND', '#7e725e', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `voters`
--

CREATE TABLE `voters` (
  `id` int(10) UNSIGNED NOT NULL,
  `voter_reference` char(12) NOT NULL,
  `nin_hash` char(64) NOT NULL,
  `pvc_reference` varchar(40) NOT NULL,
  `full_name` varchar(160) NOT NULL,
  `state` varchar(80) NOT NULL,
  `lga` varchar(100) NOT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voters`
--

INSERT INTO `voters` (`id`, `voter_reference`, `nin_hash`, `pvc_reference`, `full_name`, `state`, `lga`, `verified_at`, `created_at`) VALUES
(1, 'VOTER-78291', 'c3acd451546da2436817dcb24647c4906d93f794d6320833d9a3f234fdf65480', 'PVC-2026-0042', 'Amina Yusuf', 'Lagos', 'Ikeja', '2026-09-15 15:16:18', '2026-09-15 14:16:18');

-- --------------------------------------------------------

--
-- Table structure for table `voter_election_status`
--

CREATE TABLE `voter_election_status` (
  `voter_id` int(10) UNSIGNED NOT NULL,
  `election_id` int(10) UNSIGNED NOT NULL,
  `has_voted` tinyint(1) NOT NULL DEFAULT 0,
  `voted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voter_election_status`
--

INSERT INTO `voter_election_status` (`voter_id`, `election_id`, `has_voted`, `voted_at`) VALUES
(1, 1, 1, '2026-09-15 15:27:14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ballots`
--
ALTER TABLE `ballots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `receipt_code` (`receipt_code`),
  ADD KEY `election_id` (`election_id`);

--
-- Indexes for table `ballot_choices`
--
ALTER TABLE `ballot_choices`
  ADD PRIMARY KEY (`ballot_id`,`office_id`),
  ADD KEY `office_id` (`office_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `office_id` (`office_id`),
  ADD KEY `party_id` (`party_id`);

--
-- Indexes for table `elections`
--
ALTER TABLE `elections`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `offices`
--
ALTER TABLE `offices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `election_id` (`election_id`);

--
-- Indexes for table `parties`
--
ALTER TABLE `parties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `voters`
--
ALTER TABLE `voters`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `voter_reference` (`voter_reference`),
  ADD UNIQUE KEY `nin_hash` (`nin_hash`),
  ADD UNIQUE KEY `pvc_reference` (`pvc_reference`);

--
-- Indexes for table `voter_election_status`
--
ALTER TABLE `voter_election_status`
  ADD PRIMARY KEY (`voter_id`,`election_id`),
  ADD KEY `election_id` (`election_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `ballots`
--
ALTER TABLE `ballots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `candidates`
--
ALTER TABLE `candidates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `elections`
--
ALTER TABLE `elections`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `offices`
--
ALTER TABLE `offices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `parties`
--
ALTER TABLE `parties`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `voters`
--
ALTER TABLE `voters`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ballots`
--
ALTER TABLE `ballots`
  ADD CONSTRAINT `ballots_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `elections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ballot_choices`
--
ALTER TABLE `ballot_choices`
  ADD CONSTRAINT `ballot_choices_ibfk_1` FOREIGN KEY (`ballot_id`) REFERENCES `ballots` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ballot_choices_ibfk_2` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ballot_choices_ibfk_3` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`id`);

--
-- Constraints for table `candidates`
--
ALTER TABLE `candidates`
  ADD CONSTRAINT `candidates_ibfk_1` FOREIGN KEY (`office_id`) REFERENCES `offices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `candidates_ibfk_2` FOREIGN KEY (`party_id`) REFERENCES `parties` (`id`);

--
-- Constraints for table `offices`
--
ALTER TABLE `offices`
  ADD CONSTRAINT `offices_ibfk_1` FOREIGN KEY (`election_id`) REFERENCES `elections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `voter_election_status`
--
ALTER TABLE `voter_election_status`
  ADD CONSTRAINT `voter_election_status_ibfk_1` FOREIGN KEY (`voter_id`) REFERENCES `voters` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `voter_election_status_ibfk_2` FOREIGN KEY (`election_id`) REFERENCES `elections` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
