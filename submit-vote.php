<?php
require_once 'config/app.php';
require_voter();
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_SESSION['choices'])) { header('Location: vote.php'); exit; }
$pdo = db(); $pdo->beginTransaction();
try {
    $lock = $pdo->prepare('SELECT has_voted FROM voter_election_status WHERE voter_id = ? AND election_id = ? FOR UPDATE'); $lock->execute([$_SESSION['voter_id'], $_SESSION['election_id']]);
    if ((int) $lock->fetchColumn() === 1) throw new RuntimeException('Already voted');
    $receipt = strtoupper(bin2hex(random_bytes(8)));
    $ballot = $pdo->prepare('INSERT INTO ballots (election_id, receipt_code) VALUES (?, ?)'); $ballot->execute([$_SESSION['election_id'], $receipt]); $ballotId = $pdo->lastInsertId();
    $choice = $pdo->prepare('INSERT INTO ballot_choices (ballot_id, office_id, candidate_id) SELECT ?, office_id, id FROM candidates WHERE id = ?');
    foreach ($_SESSION['choices'] as $candidateId) $choice->execute([$ballotId, $candidateId]);
    $mark = $pdo->prepare('UPDATE voter_election_status SET has_voted = 1, voted_at = NOW() WHERE voter_id = ? AND election_id = ?'); $mark->execute([$_SESSION['voter_id'], $_SESSION['election_id']]);
    $pdo->commit(); audit('ballot_cast'); unset($_SESSION['choices']);
} catch (Throwable $error) { $pdo->rollBack(); http_response_code(409); exit('This ballot could not be submitted.'); }
$pageTitle = 'Ballot received'; include 'includes/header.php';
?><div class="form-wrap"><div class="eyebrow">Step 04 / complete</div><h1>Your ballot is locked.</h1><p>Your anonymous ballot has been recorded. Keep this receipt for your own reference.</p><div class="panel"><div class="label">Receipt code</div><div class="stat"><?= e($receipt) ?></div></div><p><a class="button" href="results.php">View results</a></p></div><?php include 'includes/footer.php'; ?>