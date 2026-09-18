<?php require_once __DIR__ . '/../config/app.php'; ?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($pageTitle ?? 'Civic Ballot') ?></title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
<header class="topbar"><a class="brand" href="index.php"><span class="brand-mark">CB</span><span>Civic Ballot</span></a><nav><a href="results.php">Results</a><?php if (!empty($_SESSION['voter_id'])): ?><a class="nav-quiet" href="logout.php">Sign out</a><?php endif; ?></nav></header>
<main class="shell">
