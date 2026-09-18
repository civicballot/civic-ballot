<?php
require_once '../config/app.php';
$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $provided = (string) ($_POST['admin_key'] ?? '');
    $expected = getenv('ADMIN_KEY') ?: '';
    if ($expected !== '' && hash_equals($expected, $provided)) {
        $_SESSION['is_admin'] = true;
        header('Location: index.php');
        exit;
    }
    $error = 'Admin access could not be verified.';
}
?><!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Admin sign in</title><link rel="stylesheet" href="../assets/style.css"></head><body><main class="shell"><div class="form-wrap"><div class="eyebrow">Restricted access</div><h1>Admin sign in.</h1><p>Use the server-side admin key configured in the environment.</p><?php if ($error): ?><div class="notice"><?= e($error) ?></div><?php endif; ?><form method="post"><div class="field"><label for="admin_key">Admin key</label><input id="admin_key" name="admin_key" type="password" required></div><button class="button" type="submit">Open dashboard</button></form></div></main></body></html>
