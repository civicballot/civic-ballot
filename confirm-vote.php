<?php
require_once 'config/app.php';
require_voter();
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['choices'])) { header('Location: vote.php'); exit; }
$_SESSION['choices'] = array_map('intval', $_POST['choices']);
$pageTitle = 'Review your ballot';
$pdo = db();
$ids = array_values($_SESSION['choices']); $marks = implode(',', array_fill(0, count($ids), '?'));
$stmt = $pdo->prepare("SELECT c.id, c.name, o.name office_name, p.abbreviation FROM candidates c JOIN offices o ON o.id = c.office_id JOIN parties p ON p.id = c.party_id WHERE c.id IN ($marks)"); $stmt->execute($ids); $choices = $stmt->fetchAll();
include 'includes/header.php';
?><div class="form-wrap"><div class="eyebrow">Step 03 / review</div><h1>Check your selections.</h1><p>Your ballot will be locked after submission. You will receive a receipt code, but it will not reveal your choices.</p><div class="panel"><?php foreach ($choices as $choice): ?><div class="results-row"><strong><?= e($choice['office_name']) ?></strong><span><?= e($choice['name']) ?></span><span class="party"><?= e($choice['abbreviation']) ?></span></div><?php endforeach; ?></div><form method="post" action="submit-vote.php" data-confirm="Submit this ballot? It cannot be changed afterward."><button class="button orange" type="submit">Cast anonymous ballot</button> <a class="button secondary" href="vote.php">Edit choices</a></form></div><?php include 'includes/footer.php'; ?>